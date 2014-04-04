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
    NSLog(@"Size %d", self.accounts.count);
    
    self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue.image_path]];
    self.backgroundImage.frame = CGRectMake(10, 100, 145, 120);
    [self.view addSubview:self.backgroundImage];
    
    self.personImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue.person]];
    self.personImage.frame = CGRectMake(165, 100, 145, 120);
    [self.view addSubview:self.personImage];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 55;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundView = nil;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    self.account = [self.accounts objectAtIndex:indexPath.row];
    CGRect cellRect = [cell bounds];
    CGFloat cellWidth = cellRect.size.width;
    CGFloat cellHeight = cellRect.size.height;
    cell.textLabel.text = self.account.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.account = [self.accounts objectAtIndex:indexPath.row];
    ViewAccountController *viewAccount = [[ViewAccountController alloc] init];
    viewAccount.accountID = [[self.accounts objectAtIndex:indexPath.row] accountID];
    viewAccount.dbManager = self.dbManager;
    viewAccount.fromCueView = YES;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:viewAccount];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Accounts";
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
