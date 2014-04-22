//
//  InitAccountController.m
//  PassCue
//
//  Created by Mats Sandvoll on 13.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import "InitAccountController.h"

@interface InitAccountController ()

@end

@implementation InitAccountController

- (void)viewDidLoad{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.title = @"New Account";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextClicked:)] ;
    self.navigationItem.rightBarButtonItem = nextButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)] ;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,screenWidth,screenHeight) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundView = nil;
    //self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)nextClicked:(id)sender {
    Account *newAccount = [[Account alloc]init];
    newAccount.name = self.accountNameTextField.text;
    newAccount.notes = self.notesTextField.text;
    //int numberOfActiveAccounts = [[self.dbManager getAllAccounts]count];
    newAccount.accountID = [self.dbManager insertAccount:newAccount];
    //Find available sharing set id
    for (int i = 1; i < 127; i++) {
        if ([self.dbManager sharingSetAvailable:i]) {
            newAccount.sharingSetID = i;
            break;
        }
    }
    
    //NSMutableArray *availableSharingSetIDs = [self.dbManager getAvailableSharingSetIDs];
    //newAccount.sharingSetID =[[availableSharingSetIDs objectAtIndex:numberOfActiveAccounts]intValue];
    [self.dbManager setSharingIDByAccountID:newAccount.accountID :newAccount.sharingSetID];
    NSLog(@"Sharing Set id %d",newAccount.sharingSetID);
    //[self.dbManager setSharingIDByAccountID:newAccount.accountID :newAccount.accountID];
    InitPAOController *paoView = [[InitPAOController alloc]init];
    paoView.paoNr = 1;
    paoView.accountID = newAccount.accountID;
    paoView.dbManager = self.dbManager;
    [self.delegate reloadTableData:self];
    [self.navigationController pushViewController:paoView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
        self.accountNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, cellWidth,cellHeight)];
        self.accountNameTextField.delegate = self;
        self.accountNameTextField.placeholder = @"Enter Account Name";
        [cell.contentView addSubview:self.accountNameTextField];
    }else{
        self.notesTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, cellWidth,cellHeight)];
        self.notesTextField.delegate = self;
        self.notesTextField.placeholder = @"Enter Notes";
        [cell.contentView addSubview:self.notesTextField];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Account Name";
    }else{
        return @"Notes";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.accountNameTextField resignFirstResponder];
    [self.notesTextField resignFirstResponder];
    return YES;
}


@end
