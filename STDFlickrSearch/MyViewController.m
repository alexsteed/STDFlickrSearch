//
//  MyViewController.m
//  STDFlickrSearch
//
//  Created by Alexis Bastide on 01/10/14.
//  Copyright (c) 2014 Steed. All rights reserved.
//

#import "MyViewController.h"
#import "STDImageStore.h"

@interface MyViewController ()


@end

@implementation MyViewController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Setting delegates
    
    UIImage *daft = [UIImage imageNamed:@"icecrema.png"];
    UIImage *pink = [UIImage imageNamed:@"check.png"];
    
    [[STDImageStore sharedStore] addImage:daft];
    [[STDImageStore sharedStore] addImage:pink];
    
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

@end
