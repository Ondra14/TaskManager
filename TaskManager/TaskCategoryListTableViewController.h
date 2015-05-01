//
//  CategoryListTableViewController.h
//  TaskManager
//
//  Created by Ondřej Veselý on 30.04.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TaskCategory+Color.h"
#import "TaskCategorySelectDelegate.h"

@interface TaskCategoryListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) TaskCategory *selectedTaskCategory;

@property BOOL selectMode;


@property (weak) id <TaskCategorySelectDelegate> delegate;


- (NSFetchedResultsController *)fetchedResultsController;


@end
