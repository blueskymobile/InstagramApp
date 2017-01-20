//
//  SettingViewController.h
//  InstagramTest
//
//  Created by 1 on 9/3/14.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITextFieldDelegate>
- (IBAction)onMainScreen:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *lblTagFirst;
@property (strong, nonatomic) IBOutlet UITextField *lblTagSecond;
@property (strong, nonatomic) IBOutlet UITextField *lblTagThird;
- (IBAction)onConnectInstagram:(id)sender;

@end
