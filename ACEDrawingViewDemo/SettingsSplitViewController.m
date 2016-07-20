//
//  SettingsSplitViewController.m
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-27.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//

#import "SettingsSplitViewController.h"
#import "AboutViewController.h"
#import "SplitSettingsTable.h"


@interface SettingsSplitViewController ()

@end

@implementation SettingsSplitViewController
@synthesize storyboardIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
//    storyboardIdentifier = @"AboutViewController";
//    [self ShowViewController];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) ShowViewController {
    
//    [self showViewController:aboutViewController sender:self];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
