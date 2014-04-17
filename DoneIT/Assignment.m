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
#define ID @"_id"
- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self)
    {
        self.course = [dic objectForKey:COURSE];
        [self.course capitalizedString];
        self.numberOfExe = [dic objectForKey:NUMBER];
        self.assignmentID = [dic objectForKey:ID];
        
        NSString *dateString = [dic objectForKey:DUE_DATE];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        
        NSDate *date = [dateFormat dateFromString:dateString];
        NSLog(@"%@",dateString);
        
        self.dueDate = date ;
    }
    return self;
}
@end
