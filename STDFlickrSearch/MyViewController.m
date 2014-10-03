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

- (instancetype)init
{
    self = [super init];
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"FlickrSearch";
    
    return self;
}

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Setting delegates
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    
    myCollectionView.backgroundColor = [UIColor whiteColor];
    
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
    NSLog(@"Select Cell %li", (long)indexPath.row);

    STDDetailViewController *dvc = [[STDDetailViewController alloc] init];
    dvc.row = indexPath.row;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - UICollectionViewDataSource Delegate methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELL";
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSLog(@"path %li",(long)indexPath.row);
    UIImageView *cellImageView = (UIImageView *)[cell.contentView viewWithTag:100];
    cellImageView.image = [[[STDImageStore sharedStore] allImages] objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor greenColor];
    
    NSLog(@"cell nb de photos = %li", [[[STDImageStore sharedStore] allImages] count]);

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger imageCount = [[[STDImageStore sharedStore] allImages] count];
    NSLog(@"objects in the array %ld", (long)imageCount);
    return imageCount;
}

#pragma mark - UICollectionViewLayout Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(100.0, 100.0);
    
    return size;
}

#pragma mark - search

- (IBAction)searchButtonPressed:(id)sender
{
    if (self.searchTextField.text == nil)
        return;
    
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = self.searchTextField.text;
    search.per_page = @"25";
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
                    NSLog(@"search nb de photos = %li", [[[STDImageStore sharedStore] allImages] count]);
                }
                [myCollectionView reloadData];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}


@end
