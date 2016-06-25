//
//  TemplateSelectionViewController.h
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-24.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateSelectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView *colectionView;
}

@end
