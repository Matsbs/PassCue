//
//  MainViewController.h
//  MobileApps4Tourism
//
//  Created by Mats Sandvoll on 18.09.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewAccountController.h"
#import "InitAccountController.h"
#import "DBManager.h"
#import "Object.h"
#import "Association.h"
#import "Cue.h"
#import "Account.h"
#import "SharingSet.h"
#import "ImagePickerViewController.h"
#import <Security/Security.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InitAccountControllerDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *accounts;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) Account *account;

@end
