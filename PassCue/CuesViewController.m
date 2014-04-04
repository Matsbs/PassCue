//
//  CuesViewController.m
//  PassCue
//
//  Created by Mats Sandvoll on 03.04.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import "CuesViewController.h"

@interface CuesViewController ()

@end

@implementation CuesViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"Cues";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    self.tableView.rowHeight = 55;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.cues = [self.dbManager getAllCues];
    NSLog(@"size %d", self.cues.count);
    
}

//Table functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    self.cue = [self.cues objectAtIndex:indexPath.row];
    NSString *cueName = [[NSString alloc]initWithFormat:@"Cue %d",self.cue.cueID];
    cell.textLabel.text = cueName;
    UIImage *background = [[UIImage alloc]initWithContentsOfFile:self.cue.image_path];
    UIImage *person       = [[UIImage alloc]initWithContentsOfFile:self.cue.person];
    CGSize newSize = CGSizeMake(120, 50);
    UIGraphicsBeginImageContext( newSize );
    [background drawInRect:CGRectMake(0,5,55,40)];
    [person drawInRect:CGRectMake(60,5,55,40)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.image = newImage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.cue = [self.cues objectAtIndex:indexPath.row];
    CueViewController *viewCue = [[CueViewController alloc] init];
    viewCue.cueID = self.cue.cueID;
    viewCue.dbManager = self.dbManager;
//    viewCue.accountID = [[self.accounts objectAtIndex:indexPath.row] accountID];
//    viewCue.dbManager = self.dbManager;
    [self.navigationController pushViewController:viewCue animated:YES];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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