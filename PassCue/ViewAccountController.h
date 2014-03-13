//
//  ViewNoteController.h
//  To-Do
//
//  Created by Mats Sandvoll on 11.10.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "DBManager.h"

@interface ViewAccountController : UIViewController 

@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) DBManager *dbManager;
@property (nonatomic, retain) UIImageView *imageView;

@end
