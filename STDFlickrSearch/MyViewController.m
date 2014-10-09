//
//  MyViewController.m
//  STDFlickrSearch
//
//  Created by Alexis Bastide on 01/10/14.
//  Copyright (c) 2014 Steed. All rights reserved.
//

#import "MyViewController.h"
#import "STDImageStore.h"
#import "STDDetailViewController.h"
#import "FlickrKit.h"

@interface MyViewController ()

@end

@implementation MyViewController

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"FlickrSearch";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(searchButtonShouldBeEnabled:) name:UITextFieldTextDidChangeNotification object:nil];
    return self;
}

#pragma mark - View events

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Setting delegates

    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    self.searchTextField.delegate = self;
    
    NSLog(@"Navframe Height=%f",
          self.navigationController.navigationBar.frame.size.height);
    
    // Dismiss keyboard when background is tapped
    myCollectionView.backgroundView = [[UIImageView alloc] initWithImage:[self collectionViewBackgroundImage]];
    myCollectionView.backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    myCollectionView.backgroundView.gestureRecognizers = @[tapRecognizer];
    
    // Setting cell
    UINib *cellNib = [UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil];
    [myCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"CELL"];
    
    // Layout init
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [myCollectionView setCollectionViewLayout:layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UICollectionView Delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    STDDetailViewController *dvc = [[STDDetailViewController alloc] init];
    dvc.row = indexPath.row;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - UICollectionViewDataSource Delegate methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELL";
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *cellImageView = (UIImageView *)[cell.contentView viewWithTag:100];
    cellImageView.image = [[[STDImageStore sharedStore] allImages] objectAtIndex:indexPath.row];
    cellImageView.contentMode = UIViewContentModeScaleAspectFit;
//    cellImageView.translatesAutoresizingMaskIntoConstraints = NO;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger imageCount = [[[STDImageStore sharedStore] allImages] count];
    return imageCount;
}

#pragma mark - Layout management

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark - UICollectionViewLayout Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(120.0, 80.0);
    return size;
}

#pragma mark - Search

- (IBAction)searchButtonPressed:(id)sender
{
    [activityViewer startAnimating];
    [myCollectionView reloadData];
    
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = self.searchTextField.text;
    search.per_page = @"21";
    [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response)
            {
                [[STDImageStore sharedStore] clearData];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"])
                {
                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                    NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
                    [[STDImageStore sharedStore] addImage:[UIImage imageWithData:imageData]];
                }
                [myCollectionView reloadData];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            [activityViewer stopAnimating];
        });
    }];
}

#pragma mark - TextField methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Enable or disable searchButton

- (void)searchButtonShouldBeEnabled:(NSNotification *)note
{
    if ([self.searchTextField.text length] > 0)
        self->searchButton.enabled = YES;
    else
        self->searchButton.enabled = NO;
}

#pragma mark - dismiss keyboard

// Create a background image to handle a touch event
- (UIImage *)collectionViewBackgroundImage
{
    CGSize cvs = myCollectionView.bounds.size;
    CGRect rect = CGRectMake(0.0f, 0.0f, cvs.width, cvs.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)dismissKeyboard
{
    [self.searchTextField resignFirstResponder];
}

@end
