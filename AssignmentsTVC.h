//
//  AssignmentsTVC.h
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DoIT,
    DoneIT
} TVCState;
@interface AssignmentsTVC : UITableViewController <UITableViewDelegate>
@property TVCState currentTVCState;

@end
