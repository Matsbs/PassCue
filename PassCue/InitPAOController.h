//
//  InitPAOController.h
//  PassCue
//
//  Created by Mats Sandvoll on 19.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cue.h"
#import "Account.h"
#import "DBManager.h"
#import "Association.h"
#import "Action.h"
#import "Object.h"

@interface InitPAOController : UIViewController

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) Cue *cue;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) Association *association;
@property (nonatomic, retain) Action *action;
@property (nonatomic, retain) Object *object;
@property (nonatomic, retain) UILabel *actionLabel;
@property (nonatomic, retain) UILabel *objectLabel;
@property int paoNr;
@property int accountID;

@end
