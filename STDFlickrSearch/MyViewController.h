//
//  MyViewController.h
//  STDFlickrSearch
//
//  Created by Alexis Bastide on 01/10/14.
//  Copyright (c) 2014 Steed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    __weak IBOutlet UICollectionView *myCollectionView;
}

@end
