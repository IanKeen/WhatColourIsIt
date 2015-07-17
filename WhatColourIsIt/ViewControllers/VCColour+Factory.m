//
//  VCColour+Factory.m
//  WhatColourIsIt
//
//  Created by Ian Keen on 17/07/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "VCColour+Factory.h"
#import "VCColourModel.h"

@implementation VCColour (Factory)
+(instancetype)factoryInstance {
    VCColourModel *model = [VCColourModel new];
    return [[VCColour alloc] initWithModel:model];
}
@end
