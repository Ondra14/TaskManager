//
//  SettingsTableViewController.m
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"

#define SECTION_SORT 2


@implementation SettingsTableViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.sortBy = myApplication.sortBy;
    self.enabledNotification = myApplication.enabledNotification;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView: tableView cellForRowAtIndexPath: indexPath];

    if (indexPath.section == SECTION_SORT) {
        if (indexPath.row == self.sortBy) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - Update UI

-(void) updateUI {
    _enabledNotificationSwitch.on = self.enabledNotification;
}

#pragma mark - Actions

- (IBAction)enableNotificationsChanged:(UISwitch *)sender {
    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApplication setEnabledNotification: sender.on];
    self.enabledNotification =  sender.on;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SECTION_SORT) {
        self.sortBy = indexPath.row;
        AppDelegate *myApplication;
        myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [myApplication setSortBy: indexPath.row];

        [tableView reloadData];
    }
}


@end
