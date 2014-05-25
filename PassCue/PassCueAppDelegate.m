//
//  PassCueAppDelegate.m
//  PassCue
//
//  Created by Mats Sandvoll on 13.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//
//  Application delegate for PassCue

#import "PassCueAppDelegate.h"
#import "MainViewController.h"

@implementation PassCueAppDelegate

//  Check if any notification was fired when app was terminated
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //  Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.dbManager = [[DBManager alloc]init];
    [self.dbManager setDbPath];
    
    MainViewController *mainScreen = [[MainViewController alloc] init];
    mainScreen.dbManager = self.dbManager;
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:mainScreen];
    [self.window setRootViewController:self.navigationController];
    
    //  Retreiving notifications as data from nsuserdefaults and converting back to localnotification
    NSMutableArray *dataOfNotifications = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notifications"]];
    NSMutableArray *notifications = [[NSMutableArray alloc] init];
    for (NSData *dataNotification in dataOfNotifications) {
        UILocalNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:dataNotification];
        [notifications addObject:notification];
    }
    
    //  Check if any notifications was fired when the app was terminated, if so, display alert message
    NSDate *now = [NSDate date];
    for (UILocalNotification *notification in notifications){
        application.applicationIconBadgeNumber = 0;
        if ([now compare:notification.fireDate] == NSOrderedDescending) {
            //  Notification has been fired, show alert
            application.applicationIconBadgeNumber = 0;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    return YES;
}

//  Display alert message if notifiaction is fired when application is active
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    application.applicationIconBadgeNumber = 0;
    if (self.isAppActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

//  Reset the application bagde icon
- (void)applicationWillResignActive:(UIApplication *)application{
    //  Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    //  Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    application.applicationIconBadgeNumber = 0;
}

//  Save the unfired notifications if application enter background
- (void)applicationDidEnterBackground:(UIApplication *)application{
    //  Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    //  If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //  Save the unlauched notifications
    application.applicationIconBadgeNumber = 0;
    self.isAppActive = NO;
    self.scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSMutableArray *arrayToSave = [[NSMutableArray alloc] init];
    for (UILocalNotification *not in self.scheduledNotifications) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:not];
        [arrayToSave addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrayToSave forKey:@"notifications"];
    [self.dbManager closeDB];
}

//  Show fired notifications when application becomes active
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [self.dbManager openDB];
    self.isAppActive = YES;
    NSDate *now = [NSDate date];
    for (UILocalNotification *notification in self.scheduledNotifications){
        application.applicationIconBadgeNumber = 0;
            if ([now compare:notification.fireDate] == NSOrderedDescending) {
                //  Notification has been fired, show alert
                application.applicationIconBadgeNumber = 0;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
    }
}

//  Save the unfired notifications if application is terminated
- (void)applicationWillTerminate:(UIApplication *)application{
    //  Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    application.applicationIconBadgeNumber = 0;
    self.isAppActive = NO;
    //  Save the unlaunched notifications
    self.scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSMutableArray *arrayToSave = [[NSMutableArray alloc] init];
    NSLog(@"Notification size before entering background: %d",self.scheduledNotifications.count);
    for (UILocalNotification *not in self.scheduledNotifications) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:not];
        [arrayToSave addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrayToSave forKey:@"notifications"];
    [self.dbManager closeDB];
}

@end

