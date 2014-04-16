//
//  Settings.h
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Settings  ;
@protocol SettingsDelegate <NSObject>
@required
-(void)SettingsViewControllerDidPressedOnDoneButton:(Settings *)controller;
-(void)SettingsViewControllerDidPressedOnCancelButton:(Settings *)controller;
@end


@interface Settings : UIViewController <UIPickerViewDelegate>
@property (nonatomic,weak) id<SettingsDelegate> delegate;
@property (strong,nonatomic) NSString *currentUserUni;
@property (strong,nonatomic) NSString *currentUserMajor;
@property (strong,nonatomic) NSString *currentUserYear;

@end


