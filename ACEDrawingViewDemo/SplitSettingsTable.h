//
//  SplitSettingsTable.h
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-27.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsSplitViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SplitSettingsTable : UITableViewController<MFMailComposeViewControllerDelegate>{
    NSArray *settingsArray;
}

@end


