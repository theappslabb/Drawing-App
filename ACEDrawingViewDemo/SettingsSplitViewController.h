//
//  SettingsSplitViewController.h
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-27.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsSplitViewController : UISplitViewController<UISplitViewControllerDelegate>{

}
@property NSString *storyboardIdentifier;
-(void) ShowViewController ;

@end
