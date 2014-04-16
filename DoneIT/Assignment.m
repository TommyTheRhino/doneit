//
//  Assignment.m
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import "Assignment.h"

@implementation Assignment
#define COURSE @"course"
#define NUMBER @"number"
#define DUE_DATE @"due"
- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self)
    {
        self.course = [dic objectForKey:COURSE];
        self.numberOfExe = [dic objectForKey:NUMBER];
        self.dueDate = [dic objectForKey:DUE_DATE];
    }
    return self;
}
@end
