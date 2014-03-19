//
//  ImagePickerViewController.m
//  PassCue
//
//  Created by Mats Sandvoll on 19.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import "ImagePickerViewController.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleDone target:self action:@selector(nextClicked:)] ;
    self.navigationItem.rightBarButtonItem = nextButton;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, 300, 300)];
    [self.view addSubview:self.selectedImage];
    
}

- (IBAction)nextClicked:(id)sender {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }else{
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.selectedImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end