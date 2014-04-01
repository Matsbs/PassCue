//
//  ViewNoteController.m
//  To-Do
//
//  Created by Mats Sandvoll on 11.10.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
//

#import "ViewAccountController.h"

@interface ViewAccountController ()

@end

@implementation ViewAccountController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dbManager = [[DBManager alloc]init];
    [self.dbManager setDbPath];
    self.account = [self.dbManager getAccountByID:self.accountID];
    self.sharingSet = [self.dbManager getSharingSetByID:self.account.sharingSetID];
    self.title = self.account.name;
    
    self.cue1= [self.dbManager getCueByID:self.sharingSet.cue1ID];
    self.cue2= [self.dbManager getCueByID:self.sharingSet.cue2ID];
    self.cue3= [self.dbManager getCueByID:self.sharingSet.cue3ID];
    self.cue4= [self.dbManager getCueByID:self.sharingSet.cue4ID];
    
    CGFloat cueHeight = (screenHeight-65)/4;
    
    //retrieve saved pictures
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imagePath = [standardUserDefaults stringForKey:@"image1"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    //
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue1.image_path]];
    self.imageView.frame = CGRectMake(0, 65, screenWidth/2,cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue1.person]];
    self.imageView.frame = CGRectMake(screenWidth/2, 65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue2.image_path]];
    self.imageView.frame = CGRectMake(0, cueHeight+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue2.person]];
    self.imageView.frame = CGRectMake(screenWidth/2, cueHeight+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue3.image_path]];
    self.imageView.frame = CGRectMake(0, (cueHeight*2)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue3.person]];
    self.imageView.frame = CGRectMake(screenWidth/2, (cueHeight*2)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue4.image_path]];
    self.imageView.frame = CGRectMake(0, (cueHeight*3)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue4.person]];
    self.imageView.frame = CGRectMake(screenWidth/2, (cueHeight*3)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)] ;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"LogIn" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClicked:)] ;
    self.navigationItem.rightBarButtonItem = loginButton;
    
   
    //Schedule notifier
    NSString *year   = @"2013";
    NSString *month  = @"1";
    NSString *day    = @"22";
    NSString *hour   = @"9";
    NSString *minute = @"48";
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year   = [year intValue];
    dateComponents.month  = [month intValue];
    dateComponents.day    = [day intValue];
    dateComponents.hour   = [hour intValue];
    dateComponents.minute = [minute intValue];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSLog(@"date: %@", date);
    
    NSDate *pickerDate = date;
    
    // Schedule the notification
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //Put an account identifier "A1", "A2"
    //NSArray *fireTime = [[NSArray alloc]initWithObjects:@"12",@"13",@"14", nil];
   
    //Kun et object per key, evt put et array på en key?
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithObject:@"value" forKey:@"fireTime"];
    [infoDict setValue:@"new value" forKey:@"fireTime"];
    localNotification.userInfo = infoDict;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow: 20];
    localNotification.alertBody = @"Hello world!";
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //This must be set properly when scheduling all notifications. It gets the real time value of the badge.
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSLog(@"number %d", localNotification.applicationIconBadgeNumber);
    //[[self.view localNotification] setHidden:YES];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                         
    //Dictionaries
//    NSDictionary *eventLocation = [NSDictionary dictionaryWithObjectsAndKeys:@"43.93838383",@"latitude",@"-3.46",@"latitude" nil];
//    
//    NSMutableDictionary *eventData = [NSDictionary dictionaryWithObjectsAndKeys:eventLocation,@"eventLocation", nil];
//    [eventData setObject:@"Jun 13, 2012 12:00:00 AM" forKey:@"eventDate"];
//    [eventData setObject:@"hjhj" forKey:@"text"];
//  
//    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:eventData,@"eventData", nil];
//    [finalDictionary setObject:@"ELDIARIOMONTANES" forKey:@"type"];
//    [finalDictionary setObject:@"accIDENTE" forKey:@"title"];
    
}

- (IBAction)cancelClicked:(id)sender {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *not in notifications){
        //Separate the different account notifications
        if ([not.userInfo objectForKey:@"fireTime"]) {
        NSLog(@"Notification name %@ userinfo: %@", not.alertBody, [not.userInfo objectForKey:@"fireTime"]);
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)loginClicked:(id)sender{
    //Update RS and notifications
}




@end
