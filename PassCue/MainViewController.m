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
    self.account = [[Account alloc] init];
    self.account.name = @"Paypal";
    [self.accounts addObject:self.account];
    self.account = [[Account alloc] init];
    self.account.name = @"Gmail";
    [self.accounts addObject:self.account];
    
    self.title = @"Accounts";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
        
    if (self.accounts.count > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
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
    if (!self.editing) {
        ViewAccountController *viewAccount = [[ViewAccountController alloc] init];
        //viewTask.delegate = self;
        //viewTask.taskID = [[self.tasks objectAtIndex:indexPath.row] taskID];
        
        [self.navigationController pushViewController:viewAccount animated:YES];
        
//        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:viewAccount];
//        [self.navigationController presentViewController:navigationController animated:YES completion:NULL];
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
//        [self.dbManager deleteTask:[self.tasks objectAtIndex:indexPath.row]];
//        [self.tasks removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        if (self.tasks.count == 0) {
//            self.navigationItem.leftBarButtonItem = NULL;
//        }
    }
}

@end
