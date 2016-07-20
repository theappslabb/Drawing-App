//
//  ACEAppDelegate.m
//  ACEDrawingViewDemo
//
//  Created by Stefano Acerbetti on 1/6/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "TemplateSelectionViewController.h"

#import "ACEAppDelegate.h"

#import "ACEViewController.h"

@implementation ACEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    ACEViewController *controller = (ACEViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"EstimateCanvasViewControllerID"];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//    self.window.rootViewController = navigationController;
////    [self.window addSubview:navigationController.view];
//    [self.window makeKeyAndVisible];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"themeColor"]) {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"themeColor"]  isEqual: @"normal"]) {
//            [[navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1]];
        } else {
//            [[navigationController navigationBar] setBarTintColor:[UIColor darkGrayColor]];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"normal"forKey:@"themeColor"];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
