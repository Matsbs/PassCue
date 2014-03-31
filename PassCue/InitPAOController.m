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
    
    self.dbManager = [[DBManager alloc]init];
    [self.dbManager setDbPath];
   
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
    
    [self manageRehearsalSchedule:self.cue];
    //Check if cue has created RS, if not create, if so update.
    
    self.association = [self.dbManager getAssociationByID:self.cue.associationID];
    self.action = [self.dbManager getActionByName:self.association.action];
    self.object = [self.dbManager getObjectByName:self.association.object];
    
    NSLog(@"Screenwidth:%f screenheight:%f",screenWidth, screenHeight);
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue.image_path]];
    self.imageView.frame = CGRectMake(10, 100, 145, 120);
    [self.view addSubview:self.imageView];
   
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue.person]];
    self.imageView.frame = CGRectMake(165, 100, 145, 120);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.action.image_path]];
    self.imageView.frame = CGRectMake(10, 255, 145, 120);
    [self.view addSubview:self.imageView];
    NSLog(@"Action path %@", self.action.image_path);
    
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
    
//    if (self.paoNr == 1) {
//        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)] ;
//        self.navigationItem.leftBarButtonItem = cancelButton;
//    }else{
//        self.navigationItem.leftBarButtonItem = nil;
//    }
    //Remove cancel button?
    
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
        [self.navigationController pushViewController:paoView animated:YES];
        NSArray *currentNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *not in currentNotifications) {
            NSLog(@"Notification %@ at date:%@", [not.userInfo objectForKey:@"cue1"], not.fireDate);
        }
        
    }else{
        NSString *alertTitle = [[NSString alloc] init];
        alertTitle = [NSString stringWithFormat:@"Once pressed done you cannot retrieve the associations. Make sure that you have fully learned the associations."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex{
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

- (void)manageRehearsalSchedule:(Cue *)cue{
    NSDate *now = [NSDate date];
    if ([self hasRehearsalSchedule:cue] == YES) {
        self.rehearsalSchedule = [self.dbManager getRehearsalScheduleByID:cue.rehearsalScheduleID];
        self.rehearsalSchedule.rehearsalScheduleID = cue.cueID;
        self.rehearsalSchedule.i = self.rehearsalSchedule.i + 1;
        self.rehearsalSchedule.rehearseTime = ([now timeIntervalSince1970] + (pow(2,(self.rehearsalSchedule.i))*(24.0*60.0*60.0)));
        [self.dbManager updateRehearsalSchedule:self.rehearsalSchedule];
        [self scheduleNotification:cue :self.rehearsalSchedule.rehearseTime];
    }else{
        self.rehearsalSchedule = [[RehearsalSchedule alloc]init];
        self.rehearsalSchedule.rehearsalScheduleID = cue.cueID;
        self.rehearsalSchedule.i = 1;
        self.rehearsalSchedule.rehearseTime = [now timeIntervalSince1970] + (pow(2,(self.rehearsalSchedule.i))*(24*60*60));
        [self.dbManager updateRehearsalSchedule:self.rehearsalSchedule];
        [self scheduleNotification:cue :self.rehearsalSchedule.rehearseTime];
    }
    NSDate *dateTest = [NSDate dateWithTimeIntervalSince1970:self.rehearsalSchedule.rehearseTime];
    NSLog(@"Rehearsal schedule %f date %@", self.rehearsalSchedule.rehearseTime, dateTest);
    
}

- (void)scheduleNotification:(Cue *)cue : (float)rehearseTime{
    //Delete not for cueid - get all not, separate by cueid dic.
    //Schedule new not
    NSDate *dateToWrite = [NSDate date]; // current date
    //double valueToWrite = [date timeIntervalSince1970];
    //NSDate *dateFromDB = [NSDate dateWithTimeIntervalSince1970:valueFromDB];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //Put an account identifier "A1", "A2"
    //NSArray *fireTime = [[NSArray alloc]initWithObjects:@"12",@"13",@"14", nil];
    
    //Kun et object per key, evt put et array på en key?
    NSString *cueIDString = [[NSString alloc]initWithFormat:@"cue%d",cue.cueID ];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithObject:cueIDString forKey:cueIDString];
    //[infoDict setValue:@"new value" forKey:@"fireTime"];
    localNotification.userInfo = infoDict;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:rehearseTime];
    localNotification.alertBody = @"Hello world!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    NSLog(@"Notification scheduled");
    
    //Update RS and Not if notification fired outside this.!!

}

@end
