//
//  TaskAddViewController.m
//  TaskManager
//
//  Created by Ondřej Veselý on 30.04.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import "TaskEditViewController.h"
#import "AppDelegate.h"
#import "TaskCategoryListTableViewController.h"

#define NSLS_COMMON_SELECT_CATEGORY NSLocalizedString(@"Category", nil)
#define NSLS_COMMON_TASK_ADD NSLocalizedString(@"Add New Task", nil)
#define NSLS_COMMON_TASK_EDIT NSLocalizedString(@"Edit Task", nil)


#define SEGUE_SELECT_TASK_CATEGORY @"select TaskCategory"

@interface TaskEditViewController ()


@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property IBOutlet UIDatePicker *dateDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *notifySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *doneSwitch;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
@property (weak, nonatomic) IBOutlet UIButton *taskCategoryButton;

@end


@implementation TaskEditViewController


@synthesize task;
@synthesize performUpdateUI;
@synthesize performUpdateCategoryUI;

- (void)viewDidLoad {
    [super viewDidLoad];

    
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setManagedObjectContext: [appDelegate managedObjectContext]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    [_dateDatePicker setTimeZone:[NSTimeZone defaultTimeZone]];


}


#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    if (performUpdateUI)
        [self updateUI];

    if (performUpdateCategoryUI)
        [self updateCategoryButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update UI

- (void) updateUI {
    performUpdateUI = NO;
    
    if (task != nil) {
        [_taskNameTextField setText: task.name];

        if (task.date != nil) {
            [_dateDatePicker setDate: task.date];
        }
        [[self navigationItem] setTitle:NSLS_COMMON_TASK_EDIT];
        
        if (task.notify != nil) {
            _notifySwitch.on = task.notify.boolValue;
        }
        if (task.done != nil) {
            _doneSwitch.on = task.done.boolValue;
        }
    }
    else {
        [[self navigationItem] setTitle:NSLS_COMMON_TASK_ADD];
        _doneSwitch.hidden = true;
        _doneSwitch.on = false;
        _doneLabel.hidden = true;
        
    }
    
    [self updateCategoryButton];
}

- (void)updateCategoryButton {
    performUpdateCategoryUI = NO;
    if (self.taskCategory != nil) {
        [_taskCategoryButton setTitle:self.taskCategory.name forState:UIControlStateNormal];
    }
    else {
        [_taskCategoryButton setTitle:NSLS_COMMON_SELECT_CATEGORY forState:UIControlStateNormal];
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destinationViewController = [segue destinationViewController] ;
    
    if ([[segue identifier] isEqualToString:SEGUE_SELECT_TASK_CATEGORY]) {
        TaskCategoryListTableViewController *taskCategoryListTableViewController = destinationViewController;
        [taskCategoryListTableViewController setSelectedTaskCategory: task.category];
        [taskCategoryListTableViewController setDelegate: self];
    }
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if (task == nil) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
        
        task = [[Task alloc] initWithEntity:entityDescription insertIntoManagedObjectContext: _managedObjectContext];
    }
    
    [task setName: [_taskNameTextField text]];
    [task setDate: [_dateDatePicker date]];
    [task setNotify: [NSNumber numberWithBool:_notifySwitch.on]];
    [task setDone: [NSNumber numberWithBool:_doneSwitch.on]];
    [task setCategory: self.taskCategory];
    
    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApplication saveContext];
    
    [myApplication scheduleNotification];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Callback

#pragma mark - TaskCategorySelectDelegate

- (void)taskCategoryDidSelected: (TaskCategory*) taskCategory {
    self.taskCategory = taskCategory;
    performUpdateCategoryUI = YES;
}

@end
