//
//  ViewNoteController.h
//  To-Do
//
//  Created by Mats Sandvoll on 11.10.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
//
//  View controller header responsible for the displaying the cue pictures for each account 

#import <UIKit/UIKit.h>
#import "Account.h"
#import "DBManager.h"
#import "Cue.h"
#import "SharingSet.h"
#import "RehearsalSchedule.h"

@interface ViewAccountController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) UIImageView *imageView1;
@property (nonatomic, retain) UIImageView *imageView2;
@property (nonatomic, retain) UIImageView *imageView3;
@property (nonatomic, retain) UIImageView *imageView4;
@property (nonatomic, retain) UIImageView *imageView5;
@property (nonatomic, retain) UIImageView *imageView6;
@property (nonatomic, retain) UIImageView *imageView7;
@property (nonatomic, retain) UIImageView *imageView8;
@property (nonatomic, retain) SharingSet *sharingSet;
@property (nonatomic, retain) Cue *tempCue;
@property (nonatomic, retain) Cue *cue1;
@property (nonatomic, retain) Cue *cue2;
@property (nonatomic, retain) Cue *cue3;
@property (nonatomic, retain) Cue *cue4;
@property int accountID;
@property (nonatomic, retain) UILocalNotification *notification;
@property (nonatomic, retain) RehearsalSchedule *rehearsalSchedule;
@property bool fromCueView;
@property (nonatomic, retain) UILabel *cueLabel;
@property (nonatomic, retain) UITableView *tableView;

@end
