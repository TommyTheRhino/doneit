//
//  PickerDS.h
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerDS : NSObject <UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong,nonatomic) NSArray* dataArr;
- (id)initWithArr:(NSArray *)arr;

@end
