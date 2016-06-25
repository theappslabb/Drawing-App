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
    //Collection View initializing
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    colectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    colectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [colectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    colectionView.delegate = self;
    colectionView.dataSource = self;
    [self.view addSubview:colectionView];
    [colectionView reloadData];
    
    // Do any additional setup after loading the view.
}

#pragma Collection View

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width/3, self.view.frame.size.height/3);
    cell.backgroundColor = UIColor.redColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
