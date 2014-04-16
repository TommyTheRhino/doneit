//
//  User.h
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) NSString *uni;
@property (strong,nonatomic) NSString *major;
@property (strong,nonatomic) NSString *year;
+ (User*)localUser ;
- (void)save ;
@end
