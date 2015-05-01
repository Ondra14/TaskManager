//
//  TaskCategory+Default.m
//  TaskManager
//
//  Created by Ondřej Veselý on 01.05.15.
//  Copyright (c) 2015 Ondřej Veselý. All rights reserved.
//

#import "TaskCategory+Color.h"




@implementation TaskCategory (Color)


- (UIColor*) categoryColor {
    return (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData: self.color];
}



@end
