//
//  VCColourModel.h
//  WhatColourIsIt
//
//  Created by Ian Keen on 17/07/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didUpdateBlock)(NSString *timeString, NSString *hex, UIColor *color, NSInteger hours, NSInteger minutes);

@interface VCColourModel : NSObject
-(void)startUpdates;
-(void)stopUpdates;
-(void)timeTravelWithOffset:(NSTimeInterval)interval;
@property (nonatomic, copy) didUpdateBlock didUpdate;
@end
