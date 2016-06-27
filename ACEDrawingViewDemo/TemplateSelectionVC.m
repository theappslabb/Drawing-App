//
//  TemplateSelectionViewController.m
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-24.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//

#import "TemplateSelectionVC.h"

@interface TemplateSelectionVC ()

@end

<<<<<<< Updated upstream:ACEDrawingViewDemo/TemplateSelectionViewController.m
@implementation TemplateSelectionViewController
@synthesize templateCollectionView;
=======
@implementation TemplateSelectionVC
>>>>>>> Stashed changes:ACEDrawingViewDemo/TemplateSelectionVC.m

- (void)viewDidLoad {
    [super viewDidLoad];
    //Collection View
    [templateCollectionView setBackgroundColor:[UIColor blackColor]];
    [templateCollectionView setDelegate:self];
    [templateCollectionView setDataSource:self];
    [self.view addSubview:templateCollectionView];
    [templateCollectionView reloadData];
    
    //Templates Array
    templates = [[NSArray alloc] initWithObjects:@"Blank",@"Black Background",@"White Background", nil];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TemplateSelectionViewController *controller = (TemplateSelectionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"templateViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    [self.view removeFromSuperview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma-mark Collection View

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.1;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [templates count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = templates[indexPath.row];
    [cell addSubview:titleLabel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
