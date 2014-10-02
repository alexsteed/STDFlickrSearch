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
    NSLog(@"will display image %li", self.row);

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *imageToDisplay = [[[STDImageStore sharedStore] allImages] objectAtIndex:self.row];
    self.imageView.image = imageToDisplay;
}

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
