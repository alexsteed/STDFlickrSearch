//
//  STDImageStore.h
//  STDFlickrSearch
//
//  Created by Alexis Bastide on 02/10/14.
//  Copyright (c) 2014 Steed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface STDImageStore : NSObject

+ (instancetype)sharedStore;
- (void)clearData;

@property (nonatomic, readonly) NSArray *allImages;
- (void)addImage:(UIImage *)image;
- (BOOL)saveChanges;

@end
