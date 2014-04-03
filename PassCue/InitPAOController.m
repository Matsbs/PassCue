//
//  InitPAOController.m
//  PassCue
//
//  Created by Mats Sandvoll on 19.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import "InitPAOController.h"

@interface InitPAOController ()

@end

@implementation InitPAOController


- (void)viewDidLoad{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.titleString = [[NSString alloc]initWithFormat:@"%@%d", @"Cue ", self.paoNr];
    self.title = self.titleString;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.account = [self.dbManager getAccountByID:self.accountID];
    if (self.paoNr == 1) {
        self.cue = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue1ID];
    }else if (self.paoNr == 2){
        self.cue = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue2ID];
    }else if (self.paoNr == 3){
        self.cue = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue3ID];
    }else{
        self.cue = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue4ID];
    }
 
    [self manageRehearsalSchedule];
    self.association = [self.dbManager getAssociationByID:self.cue.associationID];
    self.action = [self.dbManager getActionByName:self.association.action];
    self.object = [self.dbManager getObjectByName:self.association.object];

    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue.image_path]];
    self.imageView.frame = CGRectMake(10, 100, 145, 120);
    [self.view addSubview:self.imageView];
   
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue.person]];
    self.imageView.frame = CGRectMake(165, 100, 145, 120);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.action.image_path]];
    self.imageView.frame = CGRectMake(10, 255, 145, 120);
    [self.view addSubview:self.imageView];
    
    self.actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 385, 145, 20)];
    self.actionLabel.textColor = [UIColor darkGrayColor];
    self.actionLabel.text = self.action.name;
    self.actionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.actionLabel];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.object.image_path]];
    self.imageView.frame = CGRectMake(165, 255, 145, 120);
    [self.view addSubview:self.imageView];
    
    self.objectLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 385, 145, 20)];
    self.objectLabel.textColor = [UIColor darkGrayColor];
    self.objectLabel.text = self.object.name;
    self.objectLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.objectLabel];
    
    if (self.paoNr == 1) {
        [self.navigationItem setHidesBackButton:YES];
    }
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextClicked:)];
    if (self.paoNr == 4) {
        nextButton.title = @"Done";
    }
    self.navigationItem.rightBarButtonItem = nextButton;
    
}
- (IBAction)nextClicked:(id)sender {
    if (self.paoNr <=3) {
        InitPAOController *paoView = [[InitPAOController alloc]init];
        paoView.accountID = self.accountID;
        paoView.paoNr = self.paoNr+1;
        paoView.dbManager = self.dbManager;
        [self.navigationController pushViewController:paoView animated:YES];
    }else{
        NSString *alertTitle = [[NSString alloc] init];
        alertTitle = [NSString stringWithFormat:@"Once pressed done you cannot retrieve the associations. Make sure that you have fully learned the associations."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex{
    if (buttonIndex == 1){
        //remove associations
        //[self removeAssociations];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)removeAssociations{
    Cue *cue1 = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue1ID];
    int cue1ID = [self.dbManager getSharingSetByID:self.account.sharingSetID].cue1ID;
    [self.dbManager removeAssociationByCueAndCueID:cue1 :cue1ID];
    Cue *cue2 = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue2ID];
    int cue2ID = [self.dbManager getSharingSetByID:self.account.sharingSetID].cue2ID;
    [self.dbManager removeAssociationByCueAndCueID:cue2 :cue2ID];
    Cue *cue3 = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue3ID];
    int cue3ID = [self.dbManager getSharingSetByID:self.account.sharingSetID].cue3ID;
    [self.dbManager removeAssociationByCueAndCueID:cue3 :cue3ID];
    Cue *cue4 = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue4ID];
    int cue4ID = [self.dbManager getSharingSetByID:self.account.sharingSetID].cue4ID;
    [self.dbManager removeAssociationByCueAndCueID:cue4 :cue4ID];
}

- (BOOL)hasRehearsalSchedule:(Cue *)cue{
    if ([[self.dbManager getRehearsalScheduleByID:cue.rehearsalScheduleID]i] == 0) {
        return NO;
    }else{
        return YES;
    }
}

- (void)manageRehearsalSchedule{
    NSDate *now = [NSDate date];
    if ([self hasRehearsalSchedule:self.cue] == YES) {
        self.rehearsalSchedule = [self.dbManager getRehearsalScheduleByID:self.cue.rehearsalScheduleID];
        self.rehearsalSchedule.i = self.rehearsalSchedule.i + 1;
    }else{
        self.rehearsalSchedule = [[RehearsalSchedule alloc]init];
        self.rehearsalSchedule.i = 1;
        self.rehearsalSchedule.rehearsalScheduleID = self.cue.cueID;
    }
    self.rehearsalSchedule.rehearseTime = ([now timeIntervalSince1970] + (pow(2,(self.rehearsalSchedule.i))*(24*60*60)));
    [self.dbManager updateRehearsalSchedule:self.rehearsalSchedule];
    [self scheduleNotification];
}

- (void)scheduleNotification{
    NSArray *allScheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSString *notificationCueKey = [[NSString alloc]initWithFormat:@"cue%d",self.cue.cueID];
    for (UILocalNotification *notification in allScheduledNotifications) {
        if ([notification.userInfo objectForKey:notificationCueKey]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    self.notification = [[UILocalNotification alloc] init];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:notificationCueKey forKey:notificationCueKey];
    self.notification.userInfo = userInfo;
    self.notification.fireDate = [NSDate dateWithTimeIntervalSince1970:self.rehearsalSchedule.rehearseTime];
    NSString *alertText = [[NSString alloc] initWithFormat:@"You must practise cue %d. Check MyCues for which account you can log in to for rehearsal.",self.cue.cueID];
    self.notification.alertBody = alertText;
    self.notification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
    //Update RS and Not if notification fired outside this.!!
}

- (void)didReceiveMemoryWarning{
    //Include in all files?
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory full!");
}

@end
