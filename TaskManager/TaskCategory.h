//
//  TaskCategory.h
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface TaskCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * color;
@property (nonatomic, retain) NSNumber * system;
@property (nonatomic, retain) Task *tasks;

@end
