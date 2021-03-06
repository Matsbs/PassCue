//
//  PassCueAppDelegate.h
//  PassCue
//
//  Created by Mats Sandvoll on 13.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//
//  Application delegate header for PassCue 

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface PassCueAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) NSArray *scheduledNotifications;
@property (nonatomic, retain) DBManager *dbManager;
@property bool isAppActive;

@end
