//
//  InitPAOController.h
//  PassCue
//
//  Created by Mats Sandvoll on 19.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//
//  View controller header responsible for initializing the PAO stories and display them to the user

#import <UIKit/UIKit.h>
#import "Cue.h"
#import "Account.h"
#import "DBManager.h"
#import "Association.h"
#import "Action.h"
#import "Object.h"
#import "RehearsalSchedule.h"

@interface InitPAOController : UIViewController

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) Cue *cue;
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) Association *association;
@property (nonatomic, strong) Action *action;
@property (nonatomic, strong) Object *object;
@property (nonatomic, strong) RehearsalSchedule *rehearsalSchedule;
@property (nonatomic, strong) UILabel *actionLabel;
@property (nonatomic, strong) UILabel *objectLabel;
@property (nonatomic, strong) UILocalNotification *notification;
@property (nonatomic, strong) UILabel *cueLabel;
@property int paoNr;
@property int accountID;

@end
