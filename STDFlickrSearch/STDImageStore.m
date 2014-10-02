//
//  STDImageStore.m
//  STDFlickrSearch
//
//  Created by Alexis Bastide on 02/10/14.
//  Copyright (c) 2014 Steed. All rights reserved.
//

#import "STDImageStore.h"

@interface STDImageStore ()

@property (nonatomic) NSMutableArray *privateImages;

@end

@implementation STDImageStore

#pragma mark - access to images

- (NSArray *)allImages
{
    return self.privateImages;
}

#pragma mark - initialization

+ (instancetype)sharedStore
{
    static STDImageStore *sharedStore = nil;
    
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory= [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"[STDImageStore sharedStore] + use" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        NSString *path = [self itemArchivePath];
        _privateImages = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_privateImages)
        {
            _privateImages = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

#pragma mark - images management

- (void)addImage:(UIImage *)image
{
    [self.privateImages addObject:image];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privateImages toFile:path];
}

@end
