//
//  ViewController.m
//  InstagramApp
//
//  Created by 1 on 9/4/14.
//  Copyright (c) 2014 individual. All rights reserved.
//

#import "ViewController.h"
#import "LogInViewController.h"
#import "Constant.h"
#import "InstagramEngine.h"
#import "SettingViewController.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize responseData;
@synthesize activityIndicatorView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
    
    arrayResultDescription = [[NSMutableArray alloc] init];
    arrayResultImageUrl = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    CGRect rectCollectionView = CGRectMake(0, 150, 480, 250);
    _collectionView=[[UICollectionView alloc] initWithFrame:rectCollectionView collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
//    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:_collectionView];
    
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .5; //seconds
    lpgr.delegate = self;
    [_collectionView addGestureRecognizer:lpgr];
    
    tapImageView = [[UIImageView alloc] init];
    [tapImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [tapImageView.layer setBorderWidth:20.0];
    
    tapImageView.frame = CGRectMake(50, 100, 250, 250);
    tapImageView.contentMode = UIViewContentModeScaleToFill;
    tapImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:tapImageView];
    tapImageView.hidden = YES;
    
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    self.activityIndicatorView.color = [UIColor blueColor];    
    [self.view addSubview:self.activityIndicatorView];
    
    appDelegate = [AppDelegate sharedApplication];
    
    NSString* strUserId = [InstagramEngine sharedEngine].userId;
    NSString* strAccessToken = [InstagramEngine sharedEngine].accessToken;
    if (strUserId == nil || strAccessToken == nil) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:LOGININSTAGRAM];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGPoint p = [gestureRecognizer locationInView:_collectionView];
    
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        NSLog(@"%d", indexPath.row);
        NSString* strImageURL = [arrayResultImageUrl objectAtIndex:indexPath.row];
        NSURL *imageURL = [NSURL URLWithString:strImageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        tapImageView.image = [UIImage imageWithData:imageData];
        tapImageView.hidden = NO;
        UILabel* lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 200, 100)];
        lblDescription.text = [arrayResultDescription objectAtIndex:indexPath.row];
        lblDescription.backgroundColor = [UIColor clearColor];
        [lblDescription setFont:[UIFont systemFontOfSize:20]];
        lblDescription.textColor = [UIColor redColor];
        lblDescription.textAlignment = NSTextAlignmentLeft;
        lblDescription.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
        lblDescription.numberOfLines = 0;
        [tapImageView addSubview:lblDescription];
        // get the cell at indexPath (the one you long pressed)
        // do stuff with the cell
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (tapImageView.hidden == NO) {
        tapImageView.hidden = YES;
        for (UILabel* label in [tapImageView subviews]) {
            [label removeFromSuperview];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayResultImageUrl count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if ([arrayResultImageUrl count] > indexPath.row) {
        NSString* strImageURL = [arrayResultImageUrl objectAtIndex:indexPath.row];
        NSURL *imageURL = [NSURL URLWithString:strImageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSetting:(id)sender {
    
    
    SettingViewController* viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    BOOL bLogIn = [defaults boolForKey:LOGININSTAGRAM];
//    if (bLogIn == NO) {
//        LogInViewController* viewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
//    else
//    {
//        SettingViewController* viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
}

- (IBAction)onRefresh:(id)sender {
    
    [arrayResultDescription removeAllObjects];
    [arrayResultImageUrl removeAllObjects];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    strFirstTag = [defaults stringForKey:FIRSTTAG];
    strSecondTag = [defaults stringForKey:SECONDTAG];
    strThirdTag = [defaults stringForKey:THIRDTAG];
    
    if (strFirstTag == nil) {
        strFirstTag = @"";
    }
    if (strSecondTag == nil) {
        strSecondTag = @"";
    }
    if (strThirdTag == nil) {
        strThirdTag = @"";
    }
    
    if ([strFirstTag isEqualToString:@""] != YES || [strSecondTag isEqualToString:@""] != YES || [strThirdTag isEqualToString:@""] != YES) {
        
        self.responseData = [NSMutableData data];
        NSString* strUserId = [InstagramEngine sharedEngine].userId;
        NSString* strAccessToken = [InstagramEngine sharedEngine].accessToken;
        if (strUserId == nil || strAccessToken == nil) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You must be connected to Instagram." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        if (![strFirstTag isEqualToString:@""]) {
            for (int i = 0; i < [appDelegate.arrayImageDescription count]; i++) {
                NSString* strImageTag = [appDelegate.arrayImageDescription objectAtIndex:i];
                if ([strImageTag rangeOfString:strFirstTag].location != NSNotFound) {
                    [arrayResultDescription addObject:strImageTag];
                    [arrayResultImageUrl addObject:[appDelegate.arrayImageUrl objectAtIndex:i]];
                }
            }
        }
        
        if (![strSecondTag isEqualToString:@""]) {
            for (int i = 0; i < [appDelegate.arrayImageDescription count]; i++) {
                NSString* strImageTag = [appDelegate.arrayImageDescription objectAtIndex:i];
                if ([strImageTag rangeOfString:strSecondTag].location != NSNotFound) {
                    [arrayResultDescription addObject:strImageTag];
                    [arrayResultImageUrl addObject:[appDelegate.arrayImageUrl objectAtIndex:i]];
                }
            }
        }
        
        if (![strThirdTag isEqualToString:@""]) {
            for (int i = 0; i < [appDelegate.arrayImageDescription count]; i++) {
                NSString* strImageTag = [appDelegate.arrayImageDescription objectAtIndex:i];
                if ([strImageTag rangeOfString:strThirdTag].location != NSNotFound) {
                    [arrayResultDescription addObject:strImageTag];
                    [arrayResultImageUrl addObject:[appDelegate.arrayImageUrl objectAtIndex:i]];
                }
            }
        }
        if ([arrayResultDescription count] != 0) {
            [_collectionView reloadData];
        }
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input the hash tag in Setting" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (IBAction)onInstagramLogIn:(id)sender {
    LogInViewController* viewController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    strFirstTag = [defaults stringForKey:FIRSTTAG];
    strSecondTag = [defaults stringForKey:SECONDTAG];
    strThirdTag = [defaults stringForKey:THIRDTAG];
    
    BOOL bLogIn = [defaults boolForKey:LOGININSTAGRAM];
    [defaults synchronize];
    if (bLogIn == NO) {
        self.btnLogOut.hidden = YES;
    }
    else
        self.btnLogOut.hidden = NO;
}

- (IBAction)onLogOut:(id)sender {

    InstagramEngine* sharedEngine = [[InstagramEngine alloc] init];
    NSLog(@"%@", sharedEngine.accessToken);
    [sharedEngine logout];
    NSUserDefaults* deafults = [NSUserDefaults standardUserDefaults];
    [deafults setValue:NO forKey:LOGININSTAGRAM];
    [deafults synchronize];
    
    self.btnLogOut.hidden = YES;
}
@end
