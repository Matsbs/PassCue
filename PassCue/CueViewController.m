//
//  CueViewController.m
//  PassCue
//
//  Created by Mats Sandvoll on 03.04.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import "CueViewController.h"

@interface CueViewController ()

@end

@implementation CueViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    self.cue = [self.dbManager getCueByID:self.cueID];
    NSString *cueName = [[NSString alloc]initWithFormat:@"Cue %d", self.cue.cueID];
    self.title = cueName;
    
    self.accounts = [self.dbManager getAccountsByCueID:self.cue.cueID];
    self.rehearsalSchedule = [self.dbManager getRehearsalScheduleByID:self.cue.cueID];
    NSLog(@"Size %d", self.accounts.count);
    
    self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue.image_path]];
    self.backgroundImage.frame = CGRectMake(10, 100, 145, 120);
    [self.backgroundImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [self.backgroundImage.layer setBorderWidth: 2.0];
    [self.view addSubview:self.backgroundImage];
    
    self.personImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue.person]];
    self.personImage.frame = CGRectMake(165, 100, 145, 120);
    [self.personImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [self.personImage.layer setBorderWidth: 2.0];
    [self.view addSubview:self.personImage];
    
    if (self.accounts.count > 0) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, screenWidth, screenHeight-220) style:UITableViewStyleGrouped];
        self.tableView.rowHeight = 50;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.sectionHeaderHeight = 0.0;
        self.tableView.sectionFooterHeight = 0.0;
        self.tableView.scrollEnabled = YES;
        self.tableView.backgroundView = nil;
        [self.view addSubview:self.tableView];
    }else{
        self.notUsedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, screenWidth, 20)];
        self.notUsedLabel.textColor = [UIColor darkGrayColor];
        self.notUsedLabel.text = @"Cue is not used";
        self.notUsedLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.notUsedLabel];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.rehearsalSchedule = [self.dbManager getRehearsalScheduleByID:self.cue.cueID];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.accounts.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    CGRect cellRect = [cell bounds];
    CGFloat cellWidth = cellRect.size.width;
    CGFloat cellHeight = cellRect.size.height;
    if (indexPath.section == 0) {
        NSDate *dateToWrite = [NSDate dateWithTimeIntervalSince1970:self.rehearsalSchedule.rehearseTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE dd-MM-yyy 'AT' HH:mm:ss"];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"us_US"];
        NSString *stringToWrite = [[dateFormatter stringFromDate:dateToWrite] capitalizedString];
        cell.textLabel.text = stringToWrite;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellEditingStyleNone;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else if (indexPath.section == 1){
        self.account = [self.accounts objectAtIndex:indexPath.row];
        cell.textLabel.text = self.account.name;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Reset Cue";
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellEditingStyleNone;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        self.account = [self.accounts objectAtIndex:indexPath.row];
        ViewAccountController *viewAccount = [[ViewAccountController alloc] init];
        viewAccount.accountID = [[self.accounts objectAtIndex:indexPath.row] accountID];
        viewAccount.dbManager = self.dbManager;
        viewAccount.fromCueView = YES;
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:viewAccount];
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    }else if (indexPath.section == 2){
        NSString *alertTitle = [[NSString alloc] init];
        alertTitle = [NSString stringWithFormat:@"Are you sure you want to reset this cue? All accounts with this cue will be deleted."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex{
    if (buttonIndex == 1){
        //delete all notification for cueID
        //delete all accounts with cueID in the sharing set
        //set all sharing set with cueID available
        //generate association for cueID
        
        [self deleteNotificationByCueID:self.cue.cueID];
        [self deleteAccountsWithCueID:self.cue];
        [self.dbManager resetRehearsalScheduleByID:self.cue.cueID];
        
        //create new association, set association id in the cue.
        
        UInt32 randNumber = 0;
        int result = SecRandomCopyBytes(kSecRandomDefault, sizeof(int), (uint8_t*)&randNumber);
        if (result != 0) {
            randNumber = arc4random();
            NSLog(@"Used arc4random");
        }
        randNumber = (randNumber % 10)+1;
        
        UInt32 randNumber2 = 0;
        int result2 = SecRandomCopyBytes(kSecRandomDefault, sizeof(int), (uint8_t*)&randNumber2);
        if (result2 != 0) {
            randNumber2 = arc4random();
            NSLog(@"Used arc4random");
        }
        randNumber2 = (randNumber2 % 10)+1;
        
        Action *newAction = [self.dbManager getActionByID:randNumber];
        Object *newObject = [self.dbManager getObjectByID:randNumber2];
        Association *newAssociation = [[Association alloc]init];
        newAssociation.action = newAction.name;
        newAssociation.object = newObject.name;
        
        newAssociation.associationID = [self.dbManager insertAssociation:newAssociation];
        [self.dbManager setAssociationIDForCueID:self.cue.cueID :newAssociation.associationID];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Next Rehearsal";
    }else if (section == 1){
        return @"Accounts";
    }else{
        return @" ";
    }
}

- (void)deleteNotificationByCueID:(int)cueID{
    NSArray *allScheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSString *notificationCueKey = [[NSString alloc]initWithFormat:@"cue%d",cueID];
    for (UILocalNotification *notification in allScheduledNotifications) {
        if ([notification.userInfo objectForKey:notificationCueKey]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    NSLog(@"Deleted notification for cue %d", cueID);
}

- (void)deleteAccountsWithCueID:(Cue *)cue{
    for (Account *account in self.accounts){
        [self.dbManager setSharingSetAvailableByAccount:account];
        [self.dbManager deleteAccount:account];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
