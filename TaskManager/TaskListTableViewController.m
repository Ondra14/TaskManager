//
//  TaskListTableViewController.m
//  TaskManager
//
//  Created by Ondřej Veselý on 30.04.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import "TaskListTableViewController.h"
#import "TaskCategory+Color.h"

@interface TaskListTableViewController ()

@end

#define SEGUE_ADD_TASK @"add Task"
#define SEGUE_EDIT_TASK @"edit Task"
#define SEGUE_SETTINGS @"settings"

#define TASK_CELL @"TaskCell"

#define NSLS_COMMON_EDIT NSLocalizedString(@"Edit", nil)
#define NSLS_COMMON_DONE NSLocalizedString(@"Done", nil)
#define NSLS_COMMON_DELETE NSLocalizedString(@"Delete", nil)

@implementation TaskListTableViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addTask)];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"⚙" style:UIBarButtonItemStylePlain  target:self action:@selector(settings)];
    
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];

    [buttons addObject:addButton];
    [buttons addObject:settingsButton];

    self.navigationItem.rightBarButtonItems = buttons;

    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setManagedObjectContext: [myApplication managedObjectContext]];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [[self tableView] reloadData];
}

#pragma mark - Actions

- (void) addTask {
    [self performSegueWithIdentifier:SEGUE_ADD_TASK sender:self];
}

- (void) settings {
    [self performSegueWithIdentifier:SEGUE_SETTINGS sender:self];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TASK_CELL forIndexPath:indexPath];

    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [task name];
    
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];

    if (task.done.boolValue) {
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [attributeString length])];
    }
    
    cell.textLabel.attributedText = attributeString;

    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:task.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    
    UIColor *backgroundColor;
    
    if (task.category != nil) {
        backgroundColor = [task.category categoryColor];
    }
    else {
        backgroundColor = [UIColor whiteColor];
    }
    cell.contentView.backgroundColor = backgroundColor;
    cell.textLabel.backgroundColor = backgroundColor;
    cell.detailTextLabel.backgroundColor = backgroundColor;
    
    if (task.done.boolValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    id destinationViewController = [segue destinationViewController] ;
    
    if ([[segue identifier] isEqualToString:SEGUE_ADD_TASK]) {
    }
    
    if ([[segue identifier] isEqualToString:SEGUE_EDIT_TASK]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Task *task = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        TaskEditViewController *taskEditViewController = destinationViewController;
        [taskEditViewController setTask: task];
        [taskEditViewController setTaskCategory:task.category];
        [taskEditViewController setPerformUpdateUI: YES];
    }
}

#pragma mark - Edit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *actions = [NSMutableArray array];
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if (!task.done.boolValue) {
        UITableViewRowAction *doneAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLS_COMMON_DONE handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            [self setTaskAsDone: task];
        }];
        doneAction.backgroundColor = [UIColor greenColor];
        [actions addObject: doneAction];
        
    }
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLS_COMMON_EDIT handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [self.tableView setEditing:NO];
        [self.tableView selectRowAtIndexPath: indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
        [self performSegueWithIdentifier: SEGUE_EDIT_TASK sender: indexPath];
    }];
    
    editAction.backgroundColor = [UIColor lightGrayColor];
    [actions addObject: editAction];

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLS_COMMON_DELETE  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }];

    [actions addObject: deleteAction];
    
    return actions;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext ];
    
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

#pragma mark - Actions

- (void)setTaskAsDone:(Task *)task {
    
    task.done = [NSNumber numberWithBool:true];
    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApplication saveContext];
    [myApplication scheduleNotification];
}

@end
