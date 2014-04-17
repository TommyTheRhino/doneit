//
//  User.m
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import "User.h"
#define USER_TOKEN_KEY @"userTokenKey"
#define USER_UNI_KEY @"userUni"
#define USER_MAJOR_KEY @"userMajor"
#define USER_YEAR @"userYear"
#define USER_EMAIL @"Email"




#define USER_KEY @"userKey"
#define USER_THUMBNAIL_KEY @"userThumbnailKey"
#define USER_GENDER_KEY @"userGenderKey"
#define USER_HEIGHT_KEY @"userHeightKey"
#define USER_CURRENT_WEIGHT_KEY @"userCurrentWeightKey"
@implementation User


+ (User*)localUser {
    static User *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY];
        sharedInstance = [[User alloc] init];
        if (dict) {
            if (dict[USER_TOKEN_KEY]) sharedInstance.token = dict[USER_TOKEN_KEY];
            if (dict[USER_UNI_KEY]) sharedInstance.uni = dict[USER_UNI_KEY];
            if (dict[USER_MAJOR_KEY ]) sharedInstance.majorSubject = dict[USER_MAJOR_KEY];
            if (dict[USER_YEAR]) sharedInstance.year = dict[USER_YEAR];
            if (dict[USER_EMAIL]) sharedInstance.email = dict[USER_EMAIL];

        }
    });
    return sharedInstance;
}

/*
 * Save the this instance object to NSUserDefaults
 */
- (void)save {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.token) dict[USER_TOKEN_KEY] = self.token;
    if (self.uni) dict[USER_UNI_KEY] = self.uni;
    if (self.majorSubject) dict[USER_MAJOR_KEY] = self.majorSubject;
    if (self.year) dict[USER_YEAR] = self.year;
    if (self.year) dict[USER_EMAIL] = self.email;


    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)Kill{
    User *local = [User localUser];
    if (local) {
        local.uni = nil;
        local.email = nil;
        local.year = nil;
        local.majorSubject = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_KEY];

    }
}

@end
