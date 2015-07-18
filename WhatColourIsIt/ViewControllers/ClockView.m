//
//  ClockView.m
//  WhatColourIsIt
//
//  Created by Ian Keen on 18/07/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "ClockView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation ClockView
-(void)drawRect:(CGRect)drawingRect {
    CGRect rect = self.bounds;
    CGRect innerRect = CGRectInset(rect, 1.0, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(ctx, innerRect);
    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokePath(ctx);
    
    [self addLineWithAngle:[self hourAngle] rect:rect context:ctx];
    [self addLineWithAngle:[self minutesAngle] rect:rect context:ctx];
    [self updateTransformForOrientation];
    
    CGContextStrokePath(ctx);
}
-(void)addLineWithAngle:(CGFloat)angle rect:(CGRect)rect context:(CGContextRef)ctx {
    CGPoint center = [self centerOfRect:rect];
    CGFloat lineLength = center.y - 4.0;
    
    CGFloat adjustedAngle = angle + M_PI;
    CGFloat x = cosf(adjustedAngle) * lineLength + center.x;
    CGFloat y = sinf(adjustedAngle) * lineLength + center.y;
    CGContextMoveToPoint(ctx, center.x, center.y);
    CGContextAddLineToPoint(ctx, x, y);
}
-(CGPoint)centerOfRect:(CGRect)rect {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

-(void)setHours:(NSInteger)hours {
    _hours = hours;
    [self setNeedsDisplay];
}
-(void)setMinutes:(NSInteger)minutes {
    _minutes = minutes;
    [self setNeedsDisplay];
}

-(CGFloat)hourAngle {
    NSInteger degreesPerHour   = 30;
    NSInteger degreesPerMinute = 0.5;
    NSInteger hours = self.hours;
    NSInteger hoursFor12HourClock = hours % 12;
    CGFloat rotationForHoursComponent  = hoursFor12HourClock * degreesPerHour;
    CGFloat rotationForMinuteComponent = degreesPerMinute * self.minutes;
    CGFloat totalRotation = rotationForHoursComponent + rotationForMinuteComponent;
    CGFloat hourAngle = DEGREES_TO_RADIANS(totalRotation);
    return hourAngle;
}
-(CGFloat)minutesAngle {
    NSInteger degreesPerMinute = 6;
    CGFloat minutesAngle = DEGREES_TO_RADIANS(self.minutes * degreesPerMinute);
    return minutesAngle;
}
-(void)updateTransformForOrientation {
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
}
@end


