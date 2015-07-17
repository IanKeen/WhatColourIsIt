//
//  AppDelegate.m
//  WhatColourIsIt
//
//  Created by Ian Keen on 17/07/2015.
//  Copyright (c) 2015 Mustard. All rights reserved.
//

#import "AppDelegate.h"
#import "VCColour+Factory.h"

@interface AppDelegate ()
@end

@implementation AppDelegate
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [VCColour factoryInstance];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
