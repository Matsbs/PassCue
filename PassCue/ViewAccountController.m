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
    self.title = @"View Account";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat cueHeight = (screenHeight-65)/4;
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    self.imageView.frame = CGRectMake(0, 65, screenWidth/2,cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mats.png"]];
    self.imageView.frame = CGRectMake(screenWidth/2, 65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    self.imageView.frame = CGRectMake(0, cueHeight+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mats.png"]];
    self.imageView.frame = CGRectMake(screenWidth/2, cueHeight+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    self.imageView.frame = CGRectMake(0, (cueHeight*2)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mats.png"]];
    self.imageView.frame = CGRectMake(screenWidth/2, (cueHeight*2)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    self.imageView.frame = CGRectMake(0, (cueHeight*3)+65, screenWidth/2, cueHeight);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mats.png"]];
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
