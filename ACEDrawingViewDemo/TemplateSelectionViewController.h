//
//  TemplateSelectionViewController.h
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-24.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//  Deepinder

#import "BaseViewController.h"
#import "SettingsSplitViewController.h"

#import <UIKit/UIKit.h>

@interface TemplateSelectionViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource> {
    NSArray *templates;
}
@property (weak, nonatomic) IBOutlet UICollectionView *templateCollectionView;

@end    
