//
//  AppDelegate.h
//  TaskManager
//
//  Created by Ondřej Veselý on 30.04.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "Task.h"
#import "SettingsTableViewController.h"



#define NSLS_COMMON_EDIT NSLocalizedString(@"Edit", nil)
#define NSLS_COMMON_DONE NSLocalizedString(@"Done", nil)
#define NSLS_COMMON_ADD NSLocalizedString(@"Add", nil)
#define NSLS_COMMON_SAVE NSLocalizedString(@"Save", nil)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) BOOL enabledNotification;
@property (nonatomic) SortByRowIndex sortBy;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void) scheduleNotification;

-(void) setEnabledNotification: (BOOL) enabled;
-(BOOL) enabledNotification;

@end

