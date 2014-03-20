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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.imageNr <= 9) {
        self.titleString = [[NSString alloc]initWithFormat:@"%@%d", @"Background Image ", self.imageNr];
    }else{
        self.titleString = [[NSString alloc]initWithFormat:@"%@%d", @"Person Image ", (self.imageNr-9)];
    }
    self.title = self.titleString;
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    [selectButton setTitle:@"Select Picture" forState:UIControlStateNormal];
    [selectButton setFrame:CGRectMake(80.0, 80.0, 162.0, 42.0)];
    [self.view addSubview:selectButton];

    self.selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 140, screenWidth-40, screenHeight-160)];
    [self.selectedImage.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.selectedImage.layer setBorderWidth: 2.0];
    [self.view addSubview:self.selectedImage];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextClicked:)] ;
    if (self.imageNr == 18) {
        nextButton.title = @"Done";
    }
    self.navigationItem.rightBarButtonItem = nextButton;
    
    [self.navigationItem setHidesBackButton:YES];
}

- (IBAction)selectImage:(id)sender {
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

- (IBAction)nextClicked:(id)sender {
    NSData *imageData = UIImagePNGRepresentation(self.selectedImage.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",@"image",self.imageNr]];
    if (![imageData writeToFile:imagePath atomically:NO]){
        NSLog((@"Failed to save image data to disk"));
    }else{
        NSLog(@"Image saved successfylly:%@",imagePath);
    }
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [[NSString alloc]initWithFormat:@"%@%d", @"image", self.imageNr];
    [standardUserDefaults setObject:imagePath forKey:key];
    NSLog(@"Image path saved with key %@", key);
    
    ImagePickerViewController *imagePicker = [[ImagePickerViewController alloc]init];
    if (self.imageNr < 18) {
        imagePicker.imageNr = self.imageNr+1;
        [self.navigationController pushViewController:imagePicker animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.selectedImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end