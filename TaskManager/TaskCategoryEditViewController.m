//
//  TaskCategoryEditViewController.m
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import "TaskCategoryEditViewController.h"
#import "DBColorNames.h"
#import "AppDelegate.h"

@implementation TaskCategoryEditViewController



DBColorNames* colorNames;

@synthesize colors;
@synthesize taskCategory;

#pragma mark - View Life Cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    colorNames = [[DBColorNames alloc] init];
    
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setManagedObjectContext: [appDelegate managedObjectContext]];
    self.preferredContentSize = CGSizeMake(300, 350);
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self updateUI];
}

#pragma mark - Update UI

-(void) updateUI {
    if (taskCategory != nil) {
        _nameTextField.text = taskCategory.name;
    }

    [self updateSaveButtonTitle];
    [self updateColorPickerView];
}

-(void) updateColorPickerView {

    //colors
    if (taskCategory != nil) {
        
        NSUInteger index = [colors indexOfObject: [taskCategory categoryColor]];
        if (index != NSNotFound) {
            [_colorPickerView selectRow:index inComponent:0 animated:YES];
        }
    }


}

-(void) updateSaveButtonTitle {
    if (_saveButton != nil) {
        if (taskCategory == nil) {
            [_saveButton setTitle:NSLS_COMMON_ADD forState: UIControlStateNormal];
        }
        else {
            [_saveButton setTitle:NSLS_COMMON_SAVE forState: UIControlStateNormal];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDataSource

-(int) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


-(int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (colors == nil) return 0;

    return colors.count;

}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {

    // - (NSString *)nameForColor:(UIColor *)color;
    return [colorNames nameForColor: colors[row]];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
    
    UIColor *color = colors[row];
    NSString *title = [colorNames nameForColor: color];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:color}];
    return attString;
    
}

#pragma mark - Actions

- (IBAction)save:(id)sender {

    if (taskCategory == nil) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TaskCategory" inManagedObjectContext:self.managedObjectContext];
        
        taskCategory = [[TaskCategory alloc] initWithEntity:entityDescription insertIntoManagedObjectContext: _managedObjectContext];
    }
    
    [taskCategory setName: [_nameTextField text]];
    
    int colorIndex = [_colorPickerView selectedRowInComponent:0];

    taskCategory.color = [NSKeyedArchiver archivedDataWithRootObject:colors[colorIndex]];
    
    AppDelegate *myApplication;
    myApplication = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApplication saveContext];

    [self dismissViewControllerAnimated: true completion:nil];
    
}




@end
