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
    
    self.dbManager = [[DBManager alloc]init];
    [self.dbManager setDbPath];
    
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
    //[self.navigationItem setHidesBackButton:YES];

}

- (IBAction)cancelClicked:(id)sender {
    //[self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)nextClicked:(id)sender {
    Account *newAccount = [[Account alloc]init];
    newAccount.name = self.accountNameTextField.text;
    //Get sharingID
    newAccount.sharingSetID = 1;
    //
    newAccount.isInitialized = NO;
    newAccount.accountID = [self.dbManager insertAccount:newAccount];
    [self.delegate reloadTableData:self];
    InitPAOController *paoView = [[InitPAOController alloc]init];
    paoView.paoNr = 1;
    paoView.accountID = newAccount.accountID;
    [self.navigationController pushViewController:paoView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    self.accountNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, cellWidth,cellHeight)];
    self.accountNameTextField.delegate = self;
    self.accountNameTextField.placeholder = @"Enter Account Name";
    [cell.contentView addSubview:self.accountNameTextField];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Account Name";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"You entered %@",self.accountNameTextField.text);
    [self.accountNameTextField resignFirstResponder];
    return YES;
}


@end
