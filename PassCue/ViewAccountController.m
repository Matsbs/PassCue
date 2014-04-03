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

    self.account = [self.dbManager getAccountByID:self.accountID];
    self.sharingSet = [self.dbManager getSharingSetByID:self.account.sharingSetID];
    self.title = self.account.name;
    
    self.cue1 = [self.dbManager getCueByID:self.sharingSet.cue1ID];
    self.cue2 = [self.dbManager getCueByID:self.sharingSet.cue2ID];
    self.cue3 = [self.dbManager getCueByID:self.sharingSet.cue3ID];
    self.cue4 = [self.dbManager getCueByID:self.sharingSet.cue4ID];
    
    CGFloat cueHeight = (screenHeight-65)/4;
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
    
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"LogedIn" style:UIBarButtonItemStyleDone target:self action:@selector(loginClicked:)] ;
    self.navigationItem.rightBarButtonItem = loginButton;
    
    //For testing notifications
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithObject:@"value" forKey:@"fireTime"];
    [infoDict setValue:@"new value" forKey:@"fireTime"];
    localNotification.userInfo = infoDict;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow: 10];
    localNotification.alertBody = @"You must practise cue 1";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSLog(@"number %ld", (long)localNotification.applicationIconBadgeNumber);
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    //
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)loginClicked:(id)sender{
    for (int i = 1; i <= 4; i++) {
        if (i == 1) {
            self.rehearsalSchedule = [self.dbManager getRehearsalScheduleByID:self.cue1.rehearsalScheduleID];
            self.tempCue = self.cue1;
        }else if (i == 2){
            self.rehearsalSchedule = [self.dbManager getRehearsalScheduleByID:self.cue2.rehearsalScheduleID];
            self.tempCue = self.cue2;
        }else if (i == 3){
            self.rehearsalSchedule = [self.dbManager getRehearsalScheduleByID:self.cue3.rehearsalScheduleID];
            self.tempCue = self.cue3;
        }else{
            self.rehearsalSchedule = [self.dbManager getRehearsalScheduleByID:self.cue4.rehearsalScheduleID];
            self.tempCue = self.cue4;
        }
        NSDate *now = [NSDate date];
        self.rehearsalSchedule.i = self.rehearsalSchedule.i + 1;
        self.rehearsalSchedule.rehearseTime = ([now timeIntervalSince1970] + (pow(2,(self.rehearsalSchedule.i))*(24*60*60)));
        [self.dbManager updateRehearsalSchedule:self.rehearsalSchedule];
        [self scheduleNotification:self.tempCue];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)scheduleNotification:(Cue *)cue{
    NSArray *allScheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSString *notificationCueKey = [[NSString alloc]initWithFormat:@"cue%d",cue.cueID];
    for (UILocalNotification *notification in allScheduledNotifications) {
        if ([notification.userInfo objectForKey:notificationCueKey]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    self.notification = [[UILocalNotification alloc] init];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:notificationCueKey forKey:notificationCueKey];
    self.notification.userInfo = userInfo;
    self.notification.fireDate = [NSDate dateWithTimeIntervalSince1970:self.rehearsalSchedule.rehearseTime];
    NSString *alertText = [[NSString alloc] initWithFormat:@"You must practise cue %d!",cue.cueID];
    self.notification.alertBody = alertText;
    self.notification.timeZone = [NSTimeZone defaultTimeZone];
    self.notification.soundName = UILocalNotificationDefaultSoundName;
    self.notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
}

@end
