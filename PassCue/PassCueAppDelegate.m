//
//  PassCueAppDelegate.m
//  PassCue
//
//  Created by Mats Sandvoll on 13.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import "PassCueAppDelegate.h"
#import "MainViewController.h"

@implementation PassCueAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.dbManager = [[DBManager alloc]init];
    [self.dbManager setDbPath];
    
    
    MainViewController *mainScreen = [[MainViewController alloc] init];
    mainScreen.dbManager = self.dbManager;
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:mainScreen];
    [self.window setRootViewController:self.navigationController];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        // Set icon badge number to zero
                application.applicationIconBadgeNumber = 0;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FROM DIDFINISH"
                                                               message:localNotif.description
                                                               delegate:self cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
    }
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    //
    //    //application.applicationIconBadgeNumber = 1;
    //
    //
    
    
//    if (locationNotification) {
//        // Set icon badge number to zero
//        application.applicationIconBadgeNumber = 1;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
//                                                        message:locationNotification.description
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        
//    }
//    
//    application.applicationIconBadgeNumber = 0;
//    
//    //Get notifications from memory and check date, fire the ones that wasn't fired because the app was terminated
//    for (int i = 0; i<self.notificationsFired.count; i++) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test"
//                                                        message:[[self.notificationsFired objectAtIndex:i]description]
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if (self.isAppResumingFromBackground) {
        NSLog(@"from background");
        // Show Alert Here
        application.applicationIconBadgeNumber = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FROM didreceive and background"
                                                        message:nil
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    NSLog(@"YO!");
    
    application.applicationIconBadgeNumber = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FROM DIDFINISH"
                                                    message:nil
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
//    UIApplicationState state = [application applicationState];
//    NSMutableArray *alertArray =[[NSMutableArray alloc]init];
//    if (state == UIApplicationStateActive) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Active"
//                                                        message:notification.alertBody
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alertArray addObject:alert];
//        NSLog(@"active");
//    } else if (state == UIApplicationStateBackground){
//        NSLog(@"background");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Background"
//                                                        message:notification.alertBody
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    } else if (state == UIApplicationStateInactive){
//        NSLog(@"inactive");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Inactive"
//                                                        message:notification.alertBody
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    } else{
//        NSLog(@"terminated");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"terminated"
//                                                        message:notification.alertBody
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//    
//    //NSLog(@"alert!");
//    // Request to reload table view data
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
//    
//    // Set icon badge number to zero
//    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    self.notificationsFired = [[UIApplication sharedApplication] scheduledLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Save the unlauched notifications
    self.notificationsFired = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"size %d",self.notificationsFired.count);
    NSLog(@"hello");
    [self.dbManager closeDB];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
        
        self.isAppResumingFromBackground = YES;
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.dbManager openDB];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    for (int i = 0; i<self.notificationsFired.count; i++) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test"
//                                                        message:[[self.notificationsFired objectAtIndex:i]alertBody]
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1;
//    }
    NSLog(@"size of scheduled not %d", self.notificationsFired.count);
//    sjekk dato
    application.applicationIconBadgeNumber = 0;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FROM Didbecomeactive"
                                                    message:nil
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //Save the unlaunched notifications
    self.notificationsFired = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"size %d",self.notificationsFired.count);
    [self.dbManager closeDB];
}



@end

