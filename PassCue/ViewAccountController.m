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
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    self.imageView.frame = CGRectMake(40, 100, 100, 100);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mats.png"]];
    self.imageView.frame = CGRectMake(160, 100, 100, 100);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    self.imageView.frame = CGRectMake(40, 220, 100, 100);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mats.png"]];
    self.imageView.frame = CGRectMake(160, 220, 100, 100);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    self.imageView.frame = CGRectMake(40, 340, 100, 100);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mats.png"]];
    self.imageView.frame = CGRectMake(160, 340, 100, 100);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    self.imageView.frame = CGRectMake(40, 460, 100, 100);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mats.png"]];
    self.imageView.frame = CGRectMake(160, 660, 100, 100);
    [self.view addSubview:self.imageView];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)] ;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
