//
//  MainViewController.h
//  MobileApps4Tourism
//
//  Created by Mats Sandvoll on 18.09.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
//
//  View controller header responsible for the main screen - displaying all accounts

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
#import "PassCueAppDelegate.h"
#import "CuesViewController.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InitAccountControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *accounts;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) Account *account;

@end
