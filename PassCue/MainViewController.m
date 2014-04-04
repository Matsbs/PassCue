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
    //Check if first run of app
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( ![userDefaults valueForKey:@"version"] ){
        [self.dbManager initDatabase];
        [self generateSharingSet];
        [self initActionDB];
        [self initObjectDB];
        [self initRehearsalSchedule];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSLog(@"Cancelled all not!");
        NSString *alertTitle = [[NSString alloc] init];
        alertTitle = [NSString stringWithFormat:@"You must select 9 cues. Each of the cues must consist of one background image and one person image."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        ImagePickerViewController *imagePicker = [[ImagePickerViewController alloc] init];
        imagePicker.cueNr = 1;
        imagePicker.dbManager = self.dbManager;
        [self.navigationController pushViewController:imagePicker animated:YES];
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"version"] == [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] ){
        /// Same Version so dont run the function
    }else{
        // Call Your Function;
        // Update version number to NSUserDefaults for other versions:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.accounts = [self.dbManager getAllAccounts];
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
    
    self.title = @"Accounts";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    self.tableView.rowHeight = 55;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    NSMutableArray *navButtons = [[NSMutableArray alloc]init];
    UIBarButtonItem *cuesButton = [[UIBarButtonItem alloc] initWithTitle:@"Cues" style:UIBarButtonItemStylePlain target:self action:@selector(cuesClicked:)];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newClicked:)] ;
    [navButtons addObject:newButton];
    [navButtons addObject:cuesButton];
    self.navigationItem.rightBarButtonItems = navButtons;
    
    //UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newClicked:)] ;
    //self.navigationItem.rightBarButtonItem = newButton;
    if (self.accounts.count > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    //No need for delegates?
    [super viewDidAppear:animated];
    self.accounts = [self.dbManager getAllAccounts];
    if (self.accounts.count > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    [self.tableView reloadData];
}

- (IBAction)newClicked:(id)sender {
    InitAccountController *newAccount = [[InitAccountController alloc] init];
    newAccount.delegate = self;
    newAccount.dbManager = self.dbManager;
    self.editing = NO;
    [self.navigationController pushViewController:newAccount animated:YES];
}

- (IBAction)cuesClicked:(id)sender {
    CuesViewController *cuesView = [[CuesViewController alloc] init];
    cuesView.dbManager = self.dbManager;
    [self.navigationController pushViewController:cuesView animated:YES];
}

- (void)initAssociations{
    for (int i = 0; i < 10; i++) {
        UInt32 randNumber = 0;
        int result = SecRandomCopyBytes(kSecRandomDefault, sizeof(int), (uint8_t*)&randNumber);
        if (result != 0) {
            randNumber = arc4random();
            NSLog(@"Used arc4random");
        }
        randNumber = randNumber % 11;
        Action *newAction = [self.dbManager getActionByID:randNumber];
        Object *newObject = [self.dbManager getObjectByID:randNumber];
        Association *newAssociation = [[Association alloc]init];
        newAssociation.action = newAction.name;
        newAssociation.object = newObject.name;
        [self.dbManager insertAssociation:newAssociation];
    }
}

- (void)initActionDB{
    NSArray * imagePaths = [[[NSBundle mainBundle] pathsForResourcesOfType: @"jpg" inDirectory: @"actions"] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    for (NSString * imagePath in imagePaths) {
        Action *newAction = [[Action alloc] init];
        newAction.name = [[imagePath lastPathComponent]stringByDeletingPathExtension];
        newAction.image_path = imagePath;
        [self.dbManager insertAction:newAction];
    }
}

- (void)initObjectDB{
    NSArray * imagePaths = [[[NSBundle mainBundle] pathsForResourcesOfType: @"jpg" inDirectory: @"objects"] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    for (NSString * imagePath in imagePaths) {
        Object *newObject = [[Object alloc] init];
        newObject.name = [[imagePath lastPathComponent]stringByDeletingPathExtension];
        newObject.image_path = imagePath;
        [self.dbManager insertObject:newObject];
    }
}

- (void)generateSharingSet{
    int i,j,k,l;
    int length = 10;
    for (i = 1; i < length-3; i++) {
        for (j = i+1; j < length-2; j++) {
            for (k = j+1; k < length-1; k++) {
                for (l = k+1; l < length; l++) {
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

- (void)initRehearsalSchedule{
    for (int i = 1; i < 10; i++) {
        RehearsalSchedule *newRS = [[RehearsalSchedule alloc]init];
        newRS.i = 0;
        [self.dbManager insertRehearsalSchedule:newRS];
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
    self.account = [self.accounts objectAtIndex:indexPath.row];
    if (!self.editing){
        ViewAccountController *viewAccount = [[ViewAccountController alloc] init];
        viewAccount.accountID = [[self.accounts objectAtIndex:indexPath.row] accountID];
        viewAccount.dbManager = self.dbManager;
        [self.navigationController pushViewController:viewAccount animated:YES];
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
