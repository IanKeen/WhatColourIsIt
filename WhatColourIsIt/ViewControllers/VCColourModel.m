//
//  VCColourModel.m
//  WhatColourIsIt
//
//  Created by Ian Keen on 17/07/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "VCColourModel.h"

@interface VCColourModel ()
@property (nonatomic, strong) NSTimer *timer;
@end

//Credit:
//http://stackoverflow.com/a/3532264
#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
        green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
        blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
        alpha:1.0]

@implementation VCColourModel
#pragma mark - Public
-(void)startUpdates {
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:1.0
                  target:self selector:@selector(sendData)
                  userInfo:nil repeats:YES
                  ];
    [self sendData];
}
-(void)stopUpdates {
    [self.timer invalidate];
}
-(void)timeTravelWithOffset:(NSTimeInterval)interval {
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:interval];
    [self sendData:date];
}

#pragma mark - Private
-(void)sendData {
    NSDate *date = [NSDate date];
    [self sendData:date];
}
-(void)sendData:(NSDate *)date {
    if (self.didUpdate == nil) { return; }
    
    NSString *dateString = [self stringForDate:date];
    NSString *hexString = [self hexStringFromDateString:dateString];
    UIColor *color = [self colourFromHexString:hexString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    
    self.didUpdate(dateString, hexString, color, components.hour, components.minute);
}
-(NSString *)stringForDate:(NSDate *)date {
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter = nil;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"HH : mm : ss";
    });
    return [formatter stringFromDate:date];
}
-(NSString *)hexStringFromDateString:(NSString *)dateString {
    return [@"#" stringByAppendingString:[dateString stringByReplacingOccurrencesOfString:@" : " withString:@""]];
}
-(UIColor *)colourFromHexString:(NSString *)hex {
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    return UIColorFromRGB(result);
}
@end
