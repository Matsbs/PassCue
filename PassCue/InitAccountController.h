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

@interface InitAccountController : UIViewController

@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) UIImageView *imageView;

@end
