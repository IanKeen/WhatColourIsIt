//
//  VCColour.m
//  WhatColourIsIt
//
//  Created by Ian Keen on 17/07/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "VCColour.h"
#import "VCColourModel.h"

@interface VCColour ()
@property (nonatomic, strong) VCColourModel *model;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *hexLabel;
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

#pragma mark - Model
-(void)bindToModel {
    self.model.didUpdate = [self modelDidUpdate];
}
-(didUpdateBlock)modelDidUpdate {
    return ^(NSString *dateString, NSString *hexString, UIColor *color) {
        self.timeLabel.text = dateString;
        self.hexLabel.text = hexString;
        self.view.backgroundColor = color;
    };
}
@end
