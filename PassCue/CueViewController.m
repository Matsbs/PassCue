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
    
    self.cue1Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, screenWidth, 20)];
    self.cue1Label.text = @"Cue 1";
    self.cue1Label.textColor = [UIColor blueColor];
    [self.view addSubview:self.cue1Label];
    
    self.cue1Table = [[UITableView alloc]initWithFrame:CGRectMake(20, 85, screenWidth-40, 200) style:UITableViewStyleGrouped];
    [self.view addSubview:self.cue1Table];
    
    self.cue1Table.rowHeight = 30;
    self.cue1Table.delegate = self;
    self.cue1Table.dataSource = self;
    self.cue1Table.sectionHeaderHeight = 0.0;
    self.cue1Table.sectionFooterHeight = 0.0;
    self.cue1Table.scrollEnabled = YES;
    self.cue1Table.backgroundView = nil;
    self.cue1Table.tag = 1;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.cue1Table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    CGRect cellRect = [cell bounds];
    CGFloat cellWidth = cellRect.size.width;
    CGFloat cellHeight = cellRect.size.height;
    if (tableView.tag == 1) {
        NSLog(@"JIPPPPI");
    }
    cell.textLabel.text = @"test";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.cue1Table deselectRowAtIndexPath:indexPath animated:YES];
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
