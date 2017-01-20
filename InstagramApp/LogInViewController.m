//
//  LogInViewController.m
//  InstagramTest
//
//  Created by 1 on 9/3/14.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import "LogInViewController.h"
#import "SettingViewController.h"
#import "Constant.h"
@interface LogInViewController ()

@end

@implementation LogInViewController

@synthesize activityIndicatorView;
@synthesize responseData;

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
    // Do any additional setup after loading the view from its nib.
    
    self.mWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mWebView.scrollView.bounces = NO;
    self.mWebView.contentMode = UIViewContentModeScaleAspectFit;
    self.mWebView.delegate = self;
    
    self.scope = IKLoginScopeRelationships | IKLoginScopeComments | IKLoginScopeLikes;
    
    NSDictionary *configuration = [InstagramEngine sharedEngineConfiguration];
    NSString *scopeString = [InstagramEngine stringForScope:self.scope];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@", configuration[kInstagramKitAuthorizationUrlConfigurationKey], configuration[kInstagramKitAppClientIdConfigurationKey], configuration[kInstagramKitAppRedirectUrlConfigurationKey], scopeString]];
    NSLog(@"%@", url);
    [self.mWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    self.activityIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    self.responseData = [NSMutableData data];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *URLString = [request.URL absoluteString];
    NSLog(@"%@", URLString);
    NSLog(@"%@", [[InstagramEngine sharedEngine] appRedirectURL]);
    
    if ([URLString hasPrefix:[[InstagramEngine sharedEngine] appRedirectURL]]) {
        
        NSString *delimiter = @"access_token=";
        NSArray *components = [URLString componentsSeparatedByString:delimiter];
        if (components.count > 1) {
            NSString *strAccessToken = [components lastObject];
            NSArray* arrayString = [strAccessToken componentsSeparatedByString:@"."];
            NSString* strUserId = [arrayString objectAtIndex:0];
            
            
            [[InstagramEngine sharedEngine] setAccessToken:strAccessToken];
            [[InstagramEngine sharedEngine] setUserId:strUserId];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:LOGININSTAGRAM];
            [defaults synchronize];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:
                                     [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@", strUserId, strAccessToken]]];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            NSLog(@"%@", conn);
            
        }
        return NO;
    }
    return YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSDictionary* userData = [res objectForKey:@"data"];
    
    NSString* strLink;
    NSString* strDescription;
    int nCount = 0;
    
    appDelegate = [AppDelegate sharedApplication];
    
    for(id key in userData) {
        NSDictionary* dictImage = [key objectForKey:@"images"];
        id item = [dictImage objectForKey:@"thumbnail"];
        strLink = [item objectForKey:@"url"];
        
        NSDictionary* dict = [key objectForKey:@"caption"];
        strDescription = [dict objectForKey:@"text"];
        
        [appDelegate.arrayImageUrl addObject:strLink];
        [appDelegate.arrayImageDescription addObject:strDescription];
        nCount ++;
    }
    
    for (int i = 0; i < [appDelegate.arrayImageUrl count]; i++) {        
        NSLog(@"image Url = %@ image Description = %@", [appDelegate.arrayImageUrl objectAtIndex:i], [appDelegate.arrayImageDescription objectAtIndex:i]);
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:ACCESSUSERDATA];
    
    SettingViewController* settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController* nav = self.navigationController;
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:settingViewController animated:YES];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
