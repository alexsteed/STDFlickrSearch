//
//  MyViewController.h
//  STDFlickrSearch
//
//  Created by Alexis Bastide on 01/10/14.
//  Copyright (c) 2014 Steed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UICollectionView *myCollectionView;
    __weak IBOutlet UIButton *searchButton;
    __weak IBOutlet UIActivityIndicatorView *activityViewer;
}

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end
