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

@end

@implementation STDDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize UIScrollView
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect scrollRect = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];

    NSArray *imageStore = [[STDImageStore sharedStore] allImages];
    float scrollWidth = 0;
    for (int i = 0; i < [imageStore count]; i++)
        scrollWidth += screenRect.size.width;
    scrollView.contentSize = CGSizeMake(scrollWidth, self.view.frame.size.height);

    // Adding Images to UIScrollView
    float xOrigin = 0;
    for (int i = 0; i < [imageStore count]; i++)
    {
        CGRect imgRect = CGRectMake(xOrigin + 5, 0, screenRect.size.width - 10, screenRect.size.height - 100);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgRect];
        imgView.image = [imageStore objectAtIndex:i];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        [scrollView addSubview:imgView];
        xOrigin = xOrigin + screenRect.size.width;
    }
    
    // Move the view to the selected image
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * self.row;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    [self.view addSubview:scrollView];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
//    // Initialize UIScrollView
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    NSArray *imageStore = [[STDImageStore sharedStore] allImages];
//    
//    CGRect scrollRect = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
//    scrollView.pagingEnabled = YES;
//    scrollView.backgroundColor = [UIColor blackColor];
//    
//    float scrollHeight = 0;
//    for (int i = 0; i < [imageStore count]; i++)
//        scrollHeight += screenRect.size.height;
//    scrollView.contentSize = CGSizeMake(scrollRect.size.width, scrollHeight);
//    
//    // Adding Images to UIScrollView
//    float yOrigin = 0;
//    for (int i = 0; i < [imageStore count]; i++)
//    {
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, yOrigin, screenRect.size.width, screenRect.size.height)];
//        imgView.image = [imageStore objectAtIndex:i];
//        imgView.contentMode = UIViewContentModeScaleAspectFit;
//        imgView.translatesAutoresizingMaskIntoConstraints = NO;
//        [scrollView addSubview:imgView];
//        
//        yOrigin = yOrigin + screenRect.size.height;
//    }
//    [self.view addSubview:scrollView];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
