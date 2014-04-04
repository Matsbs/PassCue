//
//  CueViewController.h
//  PassCue
//
//  Created by Mats Sandvoll on 03.04.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Cue.h"
#import "ViewAccountController.h"

@interface CueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) Cue *cue;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) UIImageView *personImage;
@property int cueID;
@property (nonatomic, retain) NSMutableArray *accounts;
@property (nonatomic, retain) Account *account;

@end
