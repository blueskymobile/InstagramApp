//
//  LogInViewController.h
//  InstagramTest
//
//  Created by 1 on 9/3/14.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramKit.h"
#import "AppDelegate.h"
@interface LogInViewController : UIViewController<UIWebViewDelegate, NSURLConnectionDelegate>
{
    AppDelegate* appDelegate;
}
@property (strong, nonatomic) IBOutlet UIWebView *mWebView;
@property (nonatomic, assign) IKLoginScope scope;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableData *responseData;
@end
