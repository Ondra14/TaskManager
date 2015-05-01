//
//  SettingsTableViewController.m
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"

@implementation SettingsTableViewController

    
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

#pragma mark - Update UI

-(void) updateUI {
    
    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    _enabledNotificationSwitch.on = myApplication.enabledNotification;
    
}

#pragma mark - Actions

- (IBAction)enableNotificationsChanged:(UISwitch *)sender {
    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApplication setEnabledNotification: sender.on];
}



@end
