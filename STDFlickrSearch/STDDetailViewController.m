//
//  STDDetailViewController.m
//  STDFlickrSearch
//
//  Created by Alexis Bastide on 02/10/14.
//  Copyright (c) 2014 Steed. All rights reserved.
//

#import "STDDetailViewController.h"
#import "STDImageStore.h"

@interface STDDetailViewController ()

- (UIScrollView *)createNewScrollview;
- (void)fillScrollView:(UIScrollView *)scrollView;

@end

@implementation STDDetailViewController

#pragma mark - View events

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *scrollView = [self createNewScrollview];
    [self.view addSubview:scrollView];
    self.navigationController.hidesBarsOnTap = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.hidesBarsOnTap = NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIView *viewToRemove = [self.view viewWithTag:42];
    [viewToRemove removeFromSuperview];
    
    UIScrollView *newScrollView = [self createNewScrollview];
    [self.view addSubview:newScrollView];
    
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create a new Scrollview

- (UIScrollView *)createNewScrollview
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGRect scrollRect = CGRectMake(0.0, 0.0, screenRect.size.width, screenRect.size.height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.tag = 42;
    
    NSArray *imageStore = [[STDImageStore sharedStore] allImages];
    float scrollWidth = 0;
    for (int i = 0; i < [imageStore count]; i++)
        scrollWidth += screenRect.size.width;
    scrollView.contentSize = CGSizeMake(scrollWidth, scrollView.bounds.size.height);
    [self fillScrollView:scrollView];
    scrollView.contentOffset = CGPointMake(0, 0);
    
    // Move the view to the selected image
    CGRect frame = scrollView.frame;
    frame.origin.x = screenRect.size.width * self.row;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
    
    return scrollView;
}

- (void)fillScrollView:(UIScrollView *)scrollView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSArray *imageStore = [[STDImageStore sharedStore] allImages];
    float xOrigin = 0;
    
    // Adding Images to UIScrollView
        for (int i = 0; i < [imageStore count]; i++)
        {
            CGRect imgRect = CGRectMake(xOrigin, 0,
                                        screenRect.size.width, scrollView.bounds.size.height);
//            CGRect imgRect = CGRectMake((xOrigin + screenRect.size.width / 30), 10,
//                                        screenRect.size.width - (screenRect.size.width / 15), scrollView.bounds.size.height - 20);
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgRect];
        imgView.image = [imageStore objectAtIndex:i];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:imgView];
        xOrigin = xOrigin + screenRect.size.width;
    }
}

@end
