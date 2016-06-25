//
//  TemplateSelectionViewController.m
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-24.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//

#import "TemplateSelectionViewController.h"

@interface TemplateSelectionViewController ()

@end

@implementation TemplateSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Collection View
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    templateCollectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [templateCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [templateCollectionView setBackgroundColor:[UIColor whiteColor]];
    [templateCollectionView setDelegate:self];
    [templateCollectionView setDataSource:self];
    [templateCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"templateCell"];
    [self.view addSubview:templateCollectionView];
    [templateCollectionView reloadData];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"templateCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

@end
