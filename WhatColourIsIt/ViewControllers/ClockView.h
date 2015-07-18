//
//  ClockView.h
//  WhatColourIsIt
//
//  Created by Ian Keen on 18/07/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ClockView : UIView
IBInspectable @property (nonatomic, assign) NSInteger hours; //value in 24 hour time
IBInspectable @property (nonatomic, assign) NSInteger minutes;
@end
