//
//  TaskCategoryEditViewController.h
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCategory+Color.h"

@interface TaskCategoryEditViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSArray *colors;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *colorPickerView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;


- (IBAction)save:(id)sender;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) TaskCategory *taskCategory;

@end
