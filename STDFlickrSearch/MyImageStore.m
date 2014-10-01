//
//  MyImageStore.m
//  STDFlickrSearch
//
//  Created by Alexis Bastide on 01/10/14.
//  Copyright (c) 2014 Steed. All rights reserved.
//

#import "MyImageStore.h"

@interface MyImageStore()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation MyImageStore

#pragma mark - Shared Store

+ (instancetype)sharedStore
{
    static MyImageStore *sharedStore = nil;
    
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

#pragma mark - initialization

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [MyImageStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Image management

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *result = self.dictionary[key];
    return result;
}

@end
