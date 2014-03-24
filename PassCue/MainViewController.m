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
    self.dbManager = [[DBManager alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( ![userDefaults valueForKey:@"version"] ){
        // CALL your Function;
        
        
        [self.dbManager initDatabase];
        [self populateDB];
        [self generateSharingSet];
        
        NSString *alertTitle = [[NSString alloc] init];
        alertTitle = [NSString stringWithFormat:@"You must select 9 cues. Each of the cues must consist of one background image and one person image."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        ImagePickerViewController *imagePicker = [[ImagePickerViewController alloc] init];
        imagePicker.cueNr = 1;
        [self.navigationController pushViewController:imagePicker animated:YES];
        // Adding version number to NSUserDefaults for first version:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"version"] == [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] ){
        /// Same Version so dont run the function
    }else{
        // Call Your Function;
        // Update version number to NSUserDefaults for other versions:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
    
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.accounts = [[NSMutableArray alloc] init];

    [self.dbManager setDbPath];
    self.accounts = [self.dbManager getAllAccounts];
    
    self.title = @"Accounts";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
   UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newClicked:)] ;
    self.navigationItem.rightBarButtonItem = newButton;
    if (self.accounts.count > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    
//    Action *newAction = [self.dbManager getActionByID:1];
//    NSLog(@"Action id %d name %@ and image %@", newAction.actionID, newAction.name, newAction.image_path);
//    
//    Object *newObject = [self.dbManager getObjectByID:1];
//    NSLog(@"Object id %d name %@ and image %@", newObject.objectID, newObject.name, newObject.image_path);
//    
//    NSLog(@"Size of actions %d", [self.dbManager getAllActions].count);
//    
//    NSLog(@"Size of objects %d", [self.dbManager getAllObjects].count);
//    
//    Association *newAssociation = [self.dbManager getAssociationByID:1];
//    NSLog(@"Association id:%d action:%@ and object:%@", newAssociation.associationID, newAssociation.action, newAssociation.object);
//    
//    NSLog(@"Size of associations %d", [self.dbManager getAllAssociations].count);
//    
//    Cue *newCue = [self.dbManager getCueByID:1];
//    NSLog(@"Cue id:%d person:%@, image:%@ and associationID:%d", newCue.cueID, newCue.person, newCue.image_path, newCue.associationID);
//    
//    NSLog(@"Size of cues %d", [self.dbManager getAllCues].count);
//    
//    Account *newAccount = [self.dbManager getAccountByID:1];
//    NSLog(@"Account id:%d name:%@, sharing set:%d, rehearsal time:%@ and isInit:%d", newAccount.accountID, newAccount.name, newAccount.sharingSetID, newAccount.rehearsal_time, newAccount.isInitialized);
//    
//    NSLog(@"Size of account %d", [self.dbManager getAllAccounts].count);
//    
//    SharingSet *newSharingSet = [self.dbManager getSharingSetByID:1];
//    NSLog(@"Sharing set id:%d, cue1:%d, cue2:%d, cue3:%d, cue4:%d", newSharingSet.sharingSetID, newSharingSet.cue1ID, newSharingSet.cue2ID, newSharingSet.cue3ID, newSharingSet.cue4ID);
}

- (IBAction)newClicked:(id)sender {
    InitAccountController *newAccount = [[InitAccountController alloc] init];
    newAccount.delegate = self;
    self.editing = NO;
    [self.navigationController pushViewController:newAccount animated:YES];
//    ImagePickerViewController *test = [[ImagePickerViewController alloc] init];
//    [self.navigationController pushViewController:test animated:YES];   
}

- (void)populateDB{
    Action *newAction = [[Action alloc]init];
    newAction.name = @"Kicking";
    newAction.image_path = @"kick.png";
    [self.dbManager insertAction:newAction];
    Object *newObject = [[Object alloc]init];
    newObject.name = @"Banana";
    newObject.image_path = @"banana.png";
    [self.dbManager insertObject:newObject];
    Association *newAssociation = [[Association alloc]init];
    newAssociation.action = @"Kicking";
    newAssociation.object = @"Banana";
    [self.dbManager insertAssociation:newAssociation];
    Cue *newCue = [[Cue alloc] init];
    newCue.person = @"mats.png";
    newCue.image_path = @"1.png";
    newCue.associationID = 1;
    [self.dbManager insertCue:newCue];
}

- (void)generateSharingSet{
    int i,j,k,l;
    int length = 10;
    for (i = 1; i < length-3; i++) {
        for (j = i+1; j < length-2; j++) {
            for (k = j+1; k < length-1; k++) {
                for (l = k+1; l < length; l++) {
                    NSLog(@"%d %d %d %d",i,j,k,l);
                    SharingSet *newSharingSet = [[SharingSet alloc]init];
                    newSharingSet.cue1ID = i;
                    newSharingSet.cue2ID = j;
                    newSharingSet.cue3ID = k;
                    newSharingSet.cue4ID = l;
                    [self.dbManager insertSharingSet:newSharingSet];
                }
            }
        }
    }
}

- (void)reloadTableData:(InitAccountController *)controller{
    self.accounts = [self.dbManager getAllAccounts];
    if (self.accounts.count > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    [self.tableView reloadData];
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
        //if (self.account.isInitialized) {
            ViewAccountController *viewAccount = [[ViewAccountController alloc] init];
            viewAccount.accountID = [[self.accounts objectAtIndex:indexPath.row] accountID];
            //viewTask.delegate = self;
            //viewTask.taskID = [[self.tasks objectAtIndex:indexPath.row] taskID];
            [self.navigationController pushViewController:viewAccount animated:YES];
//        }else{
//            InitAccountController *initAccount = [[InitAccountController alloc] init];
//            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:initAccount];
//            [self.navigationController presentViewController:navigationController animated:YES completion:NULL];
//        }
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
