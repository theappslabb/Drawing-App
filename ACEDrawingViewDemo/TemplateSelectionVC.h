//
//  TemplateSelectionViewController.h
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-24.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//

#import <UIKit/UIKit.h>

<<<<<<< Updated upstream:ACEDrawingViewDemo/TemplateSelectionViewController.h
@interface TemplateSelectionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource> {
    NSArray *templates;
=======
@interface TemplateSelectionVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *templateCollectionView;
>>>>>>> Stashed changes:ACEDrawingViewDemo/TemplateSelectionVC.h
}
@property (weak, nonatomic) IBOutlet UICollectionView *templateCollectionView;

@end
