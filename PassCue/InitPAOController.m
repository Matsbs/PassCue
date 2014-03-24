//
//  InitPAOController.m
//  PassCue
//
//  Created by Mats Sandvoll on 19.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import "InitPAOController.h"

@interface InitPAOController ()

@end

@implementation InitPAOController


- (void)viewDidLoad{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.titleString = [[NSString alloc]initWithFormat:@"%@%d", @"Cue ", self.paoNr];
    self.title = self.titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dbManager = [[DBManager alloc]init];
    [self.dbManager setDbPath];
   
    self.account = [self.dbManager getAccountByID:self.accountID];
    if (self.paoNr == 1) {
        self.cue = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue1ID];
    }else if (self.paoNr == 2){
        self.cue = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue2ID];
    }else if (self.paoNr == 3){
        self.cue = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue3ID];
    }else{
        self.cue = [self.dbManager getCueByID:[self.dbManager getSharingSetByID:self.account.sharingSetID].cue4ID];
    }
    
    self.association = [self.dbManager getAssociationByID:self.cue.associationID];
    self.action = [self.dbManager getActionByName:self.association.action];
    self.object = [self.dbManager getObjectByName:self.association.object];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.cue.image_path]];
    self.imageView.frame = CGRectMake(35, 100, 120, 120);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.cue.person]];
    self.imageView.frame = CGRectMake(160, 100, 120, 120);
    [self.view addSubview:self.imageView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.action.image_path]];
    self.imageView.frame = CGRectMake(35, 240, 120, 120);
    [self.view addSubview:self.imageView];
    
    self.actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 385, 80, 20)];
    self.actionLabel.textColor = [UIColor blueColor];
    self.actionLabel.text = self.action.name;
    [self.view addSubview:self.actionLabel];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.object.image_path]];
    self.imageView.frame = CGRectMake(160, 240, 120, 120);
    [self.view addSubview:self.imageView];
    
    self.objectLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 385, 80, 20)];
    self.objectLabel.textColor = [UIColor blueColor];
    self.objectLabel.text = self.object.name;
    [self.view addSubview:self.objectLabel];
    
//    if (self.paoNr == 1) {
//        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)] ;
//        self.navigationItem.leftBarButtonItem = cancelButton;
//    }else{
//        self.navigationItem.leftBarButtonItem = nil;
//    }
    //Remove cancel button?
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextClicked:)];
    if (self.paoNr == 4) {
        nextButton.title = @"Done";
    }
    self.navigationItem.rightBarButtonItem = nextButton;
    
}
- (IBAction)nextClicked:(id)sender {
    if (self.paoNr <=3) {
        InitPAOController *paoView = [[InitPAOController alloc]init];
        paoView.accountID = self.accountID;
        paoView.paoNr = self.paoNr+1;
        [self.navigationController pushViewController:paoView animated:YES];
    }else{
        NSString *alertTitle = [[NSString alloc] init];
        alertTitle = [NSString stringWithFormat:@"Once pressed done you cannot retrieve the associations. Make sure that you have fully learned the associations."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [alert show];
        //remove associations
        
    }
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex{
    if (buttonIndex == 1){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
