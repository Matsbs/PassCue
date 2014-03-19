//
//  InitAccountController.h
//  PassCue
//
//  Created by Mats Sandvoll on 13.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "DBManager.h"
#import "InitPAOController.h"

@class InitAccountController;

@protocol InitAccountControllerDelegate <NSObject>
- (void)reloadTableData:(InitAccountController *)controller;
@end

@interface InitAccountController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <InitAccountControllerDelegate> delegate;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *accountNameTextField;

@end
