//
//  Assignment.h
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Assignment : NSObject
@property (strong,nonatomic) NSString* course;
@property (strong,nonatomic) NSNumber* numberOfExe;
@property (strong,nonatomic) NSDate* dueDate;
@property (strong,nonatomic) NSString* assignmentID;
@property BOOL didSubmit;

- (id)initWithDic:(NSDictionary *)dic;

@end
