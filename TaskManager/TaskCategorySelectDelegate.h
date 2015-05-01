//
//  TaskCategorySelectDelegate.h
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskCategory.h"

@protocol TaskCategorySelectDelegate <NSObject>

@required

- (void)taskCategoryDidSelected: (TaskCategory*) taskCategory;

@end
