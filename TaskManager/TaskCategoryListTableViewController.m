//
//  CategoryListTableViewController.m
//  TaskManager
//
//  Created by Ondřej Veselý on 30.04.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import "TaskCategoryListTableViewController.h"
#import "AppDelegate.h"
#import "TaskCategoryEditViewController.h"

#define TASK_CATEGORY_CELL @"TaskCategoryCell"
#define SEGUE_ADD_TASK_CATEGORY @"add TaskCategory"
#define SEGUE_EDIT_TASK_CATEGORY @"edit TaskCategory"

@interface TaskCategoryListTableViewController ()


@end

NSArray *colors;

@implementation TaskCategoryListTableViewController

@synthesize delegate;
@synthesize selectMode;

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setManagedObjectContext: [myApplication managedObjectContext]];
    
    
    if ([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] == 0) {
        [self insertDefaultCategory];
    }
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addTaskCategory)];

    self.navigationItem.rightBarButtonItem = addButton;
    
    
    colors = @[[UIColor yellowColor],
                        [UIColor magentaColor],
                        [UIColor brownColor],
                        [UIColor darkGrayColor]];

}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) insertDefaultCategory {

    NSArray *colors = @[[UIColor redColor],
                        [UIColor greenColor],
                        [UIColor orangeColor],
                        [UIColor lightGrayColor]];

    NSArray *names = @[NSLocalizedString(@"Work", nil),
                       NSLocalizedString(@"Home", nil),
                       NSLocalizedString(@"Family", nil),
                       NSLocalizedString(@"Other", nil)];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TaskCategory" inManagedObjectContext:self.managedObjectContext];
    
    
    
    for (int categoryIndex = 0; categoryIndex < 4; categoryIndex++) {
        
        TaskCategory* taskCategory = [[TaskCategory alloc] initWithEntity:entityDescription insertIntoManagedObjectContext: self.managedObjectContext];
        
        taskCategory.name = names[categoryIndex];
        taskCategory.color = [NSKeyedArchiver archivedDataWithRootObject:colors[categoryIndex]];
        taskCategory.system = [NSNumber numberWithBool:true];
        
    }
    
    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApplication saveContext];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: TASK_CATEGORY_CELL forIndexPath:indexPath];
    
    
    TaskCategory *taskCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [taskCategory name];
    

    cell.contentView.backgroundColor = [taskCategory categoryColor];
    cell.textLabel.backgroundColor = [taskCategory categoryColor];
    
    
    if (taskCategory == [self selectedTaskCategory]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    return cell;

}

#pragma mark - Actions

- (void) addTaskCategory {
    [self performSegueWithIdentifier:SEGUE_ADD_TASK_CATEGORY sender:self];
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectMode) {
        TaskCategory *taskCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [delegate taskCategoryDidSelected: taskCategory];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self performSegueWithIdentifier:SEGUE_EDIT_TASK_CATEGORY sender:self];
    
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destinationViewController = [segue destinationViewController] ;
    
    if ([[segue identifier] isEqualToString:SEGUE_ADD_TASK_CATEGORY]) {

        
        
        TaskCategoryEditViewController *taskCategoryEditViewController = destinationViewController;
        [taskCategoryEditViewController setColors: colors];
        UIPopoverPresentationController *popoverPresentationController = taskCategoryEditViewController.popoverPresentationController;
        popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        popoverPresentationController.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:SEGUE_EDIT_TASK_CATEGORY]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TaskCategory *taskCategory = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        TaskCategoryEditViewController *taskCategoryEditViewController = destinationViewController;
        [taskCategoryEditViewController setColors: colors];
        
        [taskCategoryEditViewController setTaskCategory: taskCategory];
        UIPopoverPresentationController *popoverPresentationController = taskCategoryEditViewController.popoverPresentationController;

        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];

        popoverPresentationController.barButtonItem = nil;
        popoverPresentationController.sourceRect = cell.frame;
        popoverPresentationController.sourceView = self.view;
        popoverPresentationController.delegate = self;
    }
}



#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskCategory" inManagedObjectContext:self.managedObjectContext ];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    
    NSArray *sortDescriptors = @[sortDescriptor1];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - controllerDidChangeContent

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] reloadData];
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
