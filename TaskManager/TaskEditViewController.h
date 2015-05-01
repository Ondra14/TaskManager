//
//  TaskAddViewController.h
//  TaskManager
//
//  Created by Ondřej Veselý on 30.04.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import <CoreData/CoreData.h>
#import "TaskCategorySelectDelegate.h"

@interface TaskEditViewController : UIViewController <TaskCategorySelectDelegate, UITextFieldDelegate>

@property (nonatomic, retain) Task *task;
@property (nonatomic, retain) TaskCategory *taskCategory;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) BOOL performUpdateUI;
@property (nonatomic) BOOL performUpdateCategoryUI;


@end
