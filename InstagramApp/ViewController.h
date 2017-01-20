//
//  ViewController.h
//  InstagramApp
//
//  Created by 1 on 9/4/14.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ViewController : UIViewController<NSURLConnectionDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray* arrayResultDescription;
    NSMutableArray* arrayResultImageUrl;
    
    NSString* strFirstTag;
    NSString* strSecondTag;
    NSString* strThirdTag;
    
    UICollectionView *_collectionView;
    UIImageView* tapImageView;
    
    AppDelegate* appDelegate;
}

- (IBAction)onSetting:(id)sender;
- (IBAction)onRefresh:(id)sender;
- (IBAction)onInstagramLogIn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
- (IBAction)onLogOut:(id)sender;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableData *responseData;
@end
