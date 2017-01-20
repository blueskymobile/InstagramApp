//
//  AppDelegate.h
//  InstagramApp
//
//  Created by 1 on 9/4/14.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray* arrayImageUrl;
@property (strong, nonatomic) NSMutableArray* arrayImageDescription;

+(AppDelegate*) sharedApplication;
@end
