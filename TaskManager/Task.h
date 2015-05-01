//
//  Task.h
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskCategory;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSNumber * notify;
@property (nonatomic, retain) TaskCategory *category;

@end
