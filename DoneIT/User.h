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
@property (strong,nonatomic) NSString *majorSubject;
@property (strong,nonatomic) NSString *year;
@property (strong,nonatomic) NSString *email;

+ (User*)localUser ;
- (void)save ;
+(void)Kill;
@end
