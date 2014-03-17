//
//  MainViewController.m
//  MobileApps4Tourism
//
//  Created by Mats Sandvoll on 18.09.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.accounts = [[NSMutableArray alloc] init];
    
    self.dbManager = [[DBManager alloc]init];
    [self.dbManager initDatabase];
    
    [self populateDB];
    self.accounts = [self.dbManager getAllAccounts];
    
    self.title = @"Accounts";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    NSLog(@"size %lo", [self.accounts count]);
    if (self.accounts.count > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    
    Action *newAction = [self.dbManager getActionByID:1];
    NSLog(@"Action id %d name %@ and image %@", newAction.actionID, newAction.name, newAction.image_path);
    
    Object *newObject = [self.dbManager getObjectByID:1];
    NSLog(@"Object id %d name %@ and image %@", newObject.objectID, newObject.name, newObject.image_path);
    
    NSLog(@"Size of actions %lu", [self.dbManager getAllActions].count);
    
    NSLog(@"Size of objects %lu", [self.dbManager getAllObjects].count);
    
    Association *newAssociation = [self.dbManager getAssociationByID:1];
    NSLog(@"Association id:%d action:%@ and object:%@", newAssociation.associationID, newAssociation.action, newAssociation.object);
    
    NSLog(@"Size of associations %lu", [self.dbManager getAllAssociations].count);
    
    Cue *newCue = [self.dbManager getCueByID:1];
    NSLog(@"Cue id:%d person:%@, image:%@ and associationID:%d", newCue.cueID, newCue.person, newCue.image_path, newCue.associationID);
    
    NSLog(@"Size of cues %lu", [self.dbManager getAllCues].count);
    
    Account *newAccount = [self.dbManager getAccountByID:1];
    NSLog(@"Account id:%d name:%@, sharing set:%d, rehearsal time:%@ and isInit:%d", newAccount.accountID, newAccount.name, newAccount.sharingSetID, newAccount.rehearsal_time, newAccount.isInitialized);
    
    NSLog(@"Size of account %lu", [self.dbManager getAllAccounts].count);
    
    SharingSet *newSharingSet = [self.dbManager getSharingSetByID:1];
    NSLog(@"Sharing set id:%d, cue1:%d, cue2:%d, cue3:%d, cue4:%d", newSharingSet.sharingSetID, newSharingSet.cue1ID, newSharingSet.cue2ID, newSharingSet.cue3ID, newSharingSet.cue4ID);
}

- (void)populateDB{
    Action *newAction = [[Action alloc]init];
    newAction.name = @"Kicking";
    newAction.image_path = @"image.png";
    [self.dbManager insertAction:newAction];
    Object *newObject = [[Object alloc]init];
    newObject.name = @"Banana";
    newObject.image_path = @"image.png";
    [self.dbManager insertObject:newObject];
    Association *newAssociation = [[Association alloc]init];
    newAssociation.action = @"Kicking";
    newAssociation.object = @"Banana";
    [self.dbManager insertAssociation:newAssociation];
    Cue *newCue = [[Cue alloc] init];
    newCue.person = @"person.png";
    newCue.image_path = @"image.png";
    newCue.associationID = 1;
    [self.dbManager insertCue:newCue];
    SharingSet *newSharingSet = [[SharingSet alloc]init];
    newSharingSet.cue1ID = 1;
    newSharingSet.cue2ID = 1;
    newSharingSet.cue3ID = 1;
    newSharingSet.cue4ID = 1;
    [self.dbManager insertSharingSet:newSharingSet];
    Account *newAccount = [[Account alloc] init];
    newAccount.name = @"Paypal";
    newAccount.sharingSetID = 0;
    newAccount.rehearsal_time = @"12:00 13:00 14:00";
    newAccount.isInitialized = NO;
    [self.dbManager insertAccount:newAccount];
}

//Table functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.accounts.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    self.account= [self.accounts objectAtIndex:indexPath.row];
    cell.textLabel.text = self.account.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.account= [self.accounts objectAtIndex:indexPath.row];
    if (!self.editing) {
        if (self.account.isInitialized) {
            ViewAccountController *viewAccount = [[ViewAccountController alloc] init];
            //viewTask.delegate = self;
            //viewTask.taskID = [[self.tasks objectAtIndex:indexPath.row] taskID];
            [self.navigationController pushViewController:viewAccount animated:YES];
        }else{
            InitAccountController *initAccount = [[InitAccountController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:initAccount];
            [self.navigationController presentViewController:navigationController animated:YES completion:NULL];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)setEditing:(BOOL)editing animated:(BOOL) animated {
    if (editing != self.editing) {
        [super setEditing:editing animated:animated];
        [self.tableView setEditing:editing animated:animated];
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editing
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editing == UITableViewCellEditingStyleDelete) {
        [self.dbManager deleteAccount:[self.accounts objectAtIndex:indexPath.row]];
        [self.accounts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if (self.accounts.count == 0) {
            self.navigationItem.leftBarButtonItem = NULL;
        }
    }
}

@end
