//
//  ViewNoteController.m
//  To-Do
//
//  Created by Mats Sandvoll on 11.10.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
//

#import "ViewAccountController.h"

@interface ViewAccountController ()

@end

@implementation ViewAccountController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dbManager = [[DBManager alloc]init];
    [self.dbManager setDbPath];
    self.account = [self.dbManager getAccountByID:self.accountID];
    self.sharingSet = [self.dbManager getSharingSetByID:self.account.sharingSetID];
    self.title = self.account.name;
    
    self.cue1= [self.dbManager getCueByID:self.sharingSet.cue1ID];
    self.cue2= [self.dbManager getCueByID:self.sharingSet.cue2ID];
    self.cue3= [self.dbManager getCueByID:self.sharingSet.cue3ID];
    self.cue4= [self.dbManager getCueByID:self.sharingSet.cue4ID];
    
    CGFloat cueHeight = (screenHeight-65)/4;
    
    //retrieve saved pictures
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imagePath = [standardUserDefaults stringForKey:@"image1"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    //
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue1.image_path]];
    self.imageView.frame = CGRectMake(0, 65, screenWidth/2,cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue1.person]];
    self.imageView.frame = CGRectMake(screenWidth/2, 65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue2.image_path]];
    self.imageView.frame = CGRectMake(0, cueHeight+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue2.person]];
    self.imageView.frame = CGRectMake(screenWidth/2, cueHeight+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue3.image_path]];
    self.imageView.frame = CGRectMake(0, (cueHeight*2)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue3.person]];
    self.imageView.frame = CGRectMake(screenWidth/2, (cueHeight*2)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue4.image_path]];
    self.imageView.frame = CGRectMake(0, (cueHeight*3)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:self.cue4.person]];
    self.imageView.frame = CGRectMake(screenWidth/2, (cueHeight*3)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)] ;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"LogIn" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClicked:)] ;
    self.navigationItem.rightBarButtonItem = loginButton;
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
