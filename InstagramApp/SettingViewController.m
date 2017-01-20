//
//  SettingViewController.m
//  InstagramTest
//
//  Created by 1 on 9/3/14.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import "SettingViewController.h"
#import "Constant.h"
#import "InstagramEngine.h"
#import "LogInViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view endEditing:YES];
    self.navigationController.navigationBar.hidden = YES;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@", [defaults valueForKey:FIRSTTAG]);
    self.lblTagFirst.text = [defaults valueForKey:FIRSTTAG];
    self.lblTagSecond.text = [defaults valueForKey:SECONDTAG];
    self.lblTagThird.text = [defaults valueForKey:THIRDTAG];
    [defaults synchronize];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)keyboardWillAppear {
    // Move current view up / down with Animation
    if (self.view.frame.origin.y >= 0)
    {
        [self moveViewUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self moveViewUp:NO];
    }
}

-(void)keyboardWillDisappear {
    if (self.view.frame.origin.y >= 0)
    {
        [self moveViewUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self moveViewUp:NO];
    }
}

//Custom method to move the view up/down whenever the keyboard is appeared / disappeared
-(void)moveViewUp:(BOOL)bMovedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
    
    CGRect rect = self.view.frame;
    if (bMovedUp) {
        // 1. move the origin of view up so that the text field will come above the keyboard
        rect.origin.y -= k_KEYBOARD_OFFSET;
        
        // 2. increase the height of the view to cover up the area behind the keyboard
        rect.size.height += k_KEYBOARD_OFFSET;
    } else {
        // revert to normal state of the view.
        rect.origin.y += k_KEYBOARD_OFFSET;
        rect.size.height -= k_KEYBOARD_OFFSET;
    }
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    // register keyboard notifications to appear / disappear the keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while moving to the other screen.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)onMainScreen:(id)sender {
    NSLog(@"%@", self.lblTagFirst.text);
    NSLog(@"%@", self.lblTagSecond.text);
    NSLog(@"%@", self.lblTagThird.text);
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![self.lblTagFirst.text  isEqual:@""]) {
        [defaults setValue:self.lblTagFirst.text forKey:FIRSTTAG];
    }
    if (![self.lblTagSecond.text  isEqual:@""]) {
        [defaults setValue:self.lblTagSecond.text forKey:SECONDTAG];
    }
    if (![self.lblTagThird.text  isEqual:@""]) {
        [defaults setValue:self.lblTagThird.text forKey:THIRDTAG];
    }
    
    [defaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.lblTagFirst isFirstResponder] && [touch view] != self.lblTagFirst) {
        [self.lblTagFirst resignFirstResponder];
    }
    if ([self.lblTagSecond isFirstResponder] && [touch view] != self.lblTagSecond) {
        [self.lblTagSecond resignFirstResponder];
    }
    if ([self.lblTagThird isFirstResponder] && [touch view] != self.lblTagThird) {
        [self.lblTagThird resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onConnectInstagram:(id)sender {
    LogInViewController* viewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
