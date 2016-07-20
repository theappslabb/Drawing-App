//
//  SplitSettingsTable.m
//  ACEDrawingViewDemo
//
//  Created by Gurjit Singh Ghangura on 2016-06-27.
//  Copyright © 2016 Stefano Acerbetti. All rights reserved.
//

#import "SplitSettingsTable.h"
#import "AboutViewController.h"

@interface SplitSettingsTable ()

@end

@implementation SplitSettingsTable

UIColor *defaultColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Close"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(Close)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    defaultColor = self.navigationController.navigationBar.barTintColor;
    
    settingsArray = [[NSArray alloc] initWithObjects:@"Night Theme",@"About",@"Contact Us",@"Share App",@"App Version", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settingsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    cell.textLabel.text = settingsArray[indexPath.row];
    if ([settingsArray[indexPath.row]  isEqual: @"Night Theme"]) {
        UISwitch *nightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width - 60, cell.frame.size.height - 40, 50, 40)];
        [nightSwitch addTarget:self action:@selector(ReverseTheme) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"themeColor"]  isEqual: @"normal"]) {
            [[self.navigationController navigationBar] setBarTintColor:[UIColor lightGrayColor]];
            [nightSwitch setOn:false];
        } else {
            [[self.navigationController navigationBar] setBarTintColor:[UIColor darkGrayColor]];
            [nightSwitch setOn:true];
        }
        [cell addSubview:nightSwitch];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 1) {
        AboutViewController *aboutViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.navigationController pushViewController:aboutViewController animated:true];
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        
    } else if (indexPath.row == 5) {
        
    } else {
        
    }
    
}

-(void) ReverseTheme {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"themeColor"]  isEqual: @"normal"]) {
        [[self.navigationController navigationBar] setBarTintColor:[UIColor darkGrayColor]];
        [[NSUserDefaults standardUserDefaults] setObject:@"dark"forKey:@"themeColor"];
    } else {
        [[self.navigationController navigationBar] setBarTintColor:[UIColor lightGrayColor]];
        [[NSUserDefaults standardUserDefaults] setObject:@"normal"forKey:@"themeColor"];
    }
    
    NSNotification *myNotification = [NSNotification notificationWithName:@"ThemeChanged"
                                                                   object:self
                                                                 userInfo:nil];
    
    
    [[NSNotificationCenter defaultCenter] postNotification:myNotification];
}

-(void) Close {
    [self dismissViewControllerAnimated:true completion:^(void){
        
    }];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
