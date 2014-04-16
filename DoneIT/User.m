//
//  User.m
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import "User.h"

#define USER_KEY @"userKey"
#define USER_NAME_KEY @"userNameKey"
#define USER_PHONE_KEY @"userPhoneKey"
#define USER_TOKEN_KEY @"userTokenKey"
#define USER_BIRTHDAY_KEY @"userBirthdayKey"
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
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
