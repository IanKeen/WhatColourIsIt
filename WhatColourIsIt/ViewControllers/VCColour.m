//
//  VCColour.m
//  WhatColourIsIt
//
//  Created by Ian Keen on 17/07/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "VCColour.h"
#import "VCColourModel.h"
#import "ClockView.h"

@interface VCColour ()
@property (nonatomic, strong) VCColourModel *model;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *hexLabel;
@property (nonatomic, weak) IBOutlet ClockView *timeView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *timeViewConstraint;
@end

@implementation VCColour
#pragma mark - Lifecycle
-(instancetype)initWithModel:(VCColourModel *)model {
    if (!(self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil])) { return nil; }
    self.model = model;
    return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeView.hours = 1;
    self.timeView.minutes = 15;
    
    [self setupTimeTravel];
    [self bindToModel];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.model startUpdates];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.model stopUpdates];
}
-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - TimeTravel
-(void)setupTimeTravel {
    self.timeView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.timeView addGestureRecognizer:pan];
}
-(void)resetTimeTravel {
    self.timeViewConstraint.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.75f animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)panGestureRecognizerAction:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.model stopUpdates];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handleGestureMovement:gesture];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self resetTimeTravel];
            [self.model startUpdates];
            
        default: break;
    }
}
-(void)handleGestureMovement:(UIPanGestureRecognizer *)gesture {
    CGFloat maxDelta = (CGRectGetWidth(self.view.bounds) / 2.0) - CGRectGetWidth(self.timeView.bounds) - 20.0f;
    
    CGPoint point = [gesture translationInView:self.view];
    CGFloat delta = (point.x * -1);
    
    if (abs((int)delta) < (int)maxDelta) {
        CGFloat percentage = (delta / maxDelta) * 100.0;
        
        NSTimeInterval windowRange = (60 * 60 * 13); //13 hour window to allow some overlap on the edges
        NSTimeInterval timeOffset = windowRange * (percentage / 100.0);
        
        self.timeViewConstraint.constant = delta;
        [self.model timeTravelWithOffset:timeOffset];
    }
}

#pragma mark - Model
-(void)bindToModel {
    self.model.didUpdate = [self modelDidUpdate];
}
-(didUpdateBlock)modelDidUpdate {
    return ^(NSString *dateString, NSString *hexString, UIColor *color, NSInteger hour, NSInteger minutes) {
        self.timeLabel.text = dateString;
        self.hexLabel.text = hexString;
        self.view.backgroundColor = color;
        self.timeView.hours = hour;
        self.timeView.minutes = minutes;
    };
}
@end
