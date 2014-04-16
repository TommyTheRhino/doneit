//
//  PickerDS.m
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import "PickerDS.h"

@implementation PickerDS

- (id)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self)
    {
        self.dataArr = arr;
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArr count];
}


@end
