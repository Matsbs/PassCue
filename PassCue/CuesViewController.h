//
//  CuesViewController.h
//  PassCue
//
//  Created by Mats Sandvoll on 03.04.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Cue.h"
#import "CueViewController.h"

@interface CuesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *cues;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) Cue *cue;

@end
