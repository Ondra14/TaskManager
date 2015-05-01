//
//  SettingsTableViewController.h
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *enabledNotificationSwitch;

@end
