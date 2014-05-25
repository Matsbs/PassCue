//
//  ImagePickerViewController.m
//  PassCue
//
//  Created by Mats Sandvoll on 19.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//
//  Image picker view controller responsible for enable photo access to the photo library
//  Enables the user to select pictures from the photo libraray to be used as cues

#import "ImagePickerViewController.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController

//  Load and display the image picker
- (void)viewDidLoad{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"screenwidth %f", screenWidth);
    self.titleString = [[NSString alloc]initWithFormat:@"%@%d", @"Select Cue ", self.cueNr];
    self.title = self.titleString;

    self.selectedBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, screenWidth-100, 182)];
    [self.selectedBackgroundImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [self.selectedBackgroundImage.layer setBorderWidth: 2.0];
    [self.view addSubview:self.selectedBackgroundImage];
    
    UIButton *selectBackgroundButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectBackgroundButton addTarget:self action:@selector(selectBackgroundImage:) forControlEvents:UIControlEventTouchUpInside];
    [selectBackgroundButton setTitle:@"Select Background Image" forState:UIControlStateNormal];
    [selectBackgroundButton setFrame:CGRectMake(80.0, 282, 180, 42.0)];
    [self.view addSubview:selectBackgroundButton];
    
    self.selectedPersonImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 332, screenWidth-100, 182)];
    [self.selectedPersonImage.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [self.selectedPersonImage.layer setBorderWidth: 2.0];
    [self.view addSubview:self.selectedPersonImage];
    
    UIButton *selectPersonButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectPersonButton addTarget:self action:@selector(selectPersonImage:) forControlEvents:UIControlEventTouchUpInside];
    [selectPersonButton setTitle:@"Select Person Image" forState:UIControlStateNormal];
    [selectPersonButton setFrame:CGRectMake(80.0, 514, 170, 42.0)];
    [self.view addSubview:selectPersonButton];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextClicked:)] ;
    if (self.cueNr == 9) {
        nextButton.title = @"Done";
    }
    self.navigationItem.rightBarButtonItem = nextButton;
    
    [self.navigationItem setHidesBackButton:YES];
}

//  Add the selected picture to the associated object
- (IBAction)selectPersonImage:(id)sender {
    self.personImagePicker = [[UIImagePickerController alloc] init];
    self.personImagePicker.delegate = self;
    self.isPerson = YES;
    self.personImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:self.personImagePicker animated:YES completion:nil];
}
- (IBAction)selectBackgroundImage:(id)sender {
    self.backgroundImagePicker = [[UIImagePickerController alloc] init];
    self.backgroundImagePicker.delegate = self;
    self.isBackground = YES;
    self.backgroundImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:self.backgroundImagePicker animated:YES completion:nil];
}

//  Copy all pictures to the application document folder and save path
- (IBAction)nextClicked:(id)sender {
    NSData *imagePersonData = UIImagePNGRepresentation(self.selectedPersonImage.image);
    NSData *imageBackgroundData = UIImagePNGRepresentation(self.selectedBackgroundImage.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePersonPath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",@"person",self.cueNr]];
    NSString *imageBackgroundPath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",@"background",self.cueNr]];
    //Saving pictures to documents folder and save the path in nsuserdefaults
    if (![imagePersonData writeToFile:imagePersonPath atomically:NO]){
        NSLog((@"Failed to save person image data to disk"));
    }else{
        NSLog(@"Person image saved successfylly:%@",imagePersonPath);
    }
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [[NSString alloc]initWithFormat:@"%@%d.png", @"person", self.cueNr];
    [standardUserDefaults setObject:imagePersonPath forKey:key];
    NSLog(@"Person image path saved with key %@", key);
    
    if (![imageBackgroundData writeToFile:imageBackgroundPath atomically:NO]){
        NSLog((@"Failed to save background image data to disk"));
    }else{
        NSLog(@"Background image saved successfylly:%@",imageBackgroundPath);
    }
    key = [[NSString alloc]initWithFormat:@"%@%d.png", @"background", self.cueNr];
    [standardUserDefaults setObject:imageBackgroundPath forKey:key];
    NSLog(@"Background image path saved with key %@", key);

    ImagePickerViewController *imagePicker = [[ImagePickerViewController alloc]init];
    imagePicker.dbManager = self.dbManager;

    if (self.cueNr < 9) {
        imagePicker.cueNr = self.cueNr+1;
        [self.navigationController pushViewController:imagePicker animated:YES];
    }else{
        [self createCues];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//  Image picker functions
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.isPerson) {
        self.selectedPersonImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.isPerson = NO;
    }else if (self.isBackground){
        self.selectedBackgroundImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.isBackground = NO;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//  Create cues using the selected pictures and random numbers
- (void)createCues{
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
    for (int i = 1; i < 10; i++) {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString *personKey = [[NSString alloc] initWithFormat:@"%@%d.png",@"person",i];
        NSString *imagePersonPath = [standardUserDefaults stringForKey:personKey];
        NSString *backgroundKey = [[NSString alloc] initWithFormat:@"%@%d.png",@"background",i];
        NSString *imageBackgroundPath = [standardUserDefaults stringForKey:backgroundKey];
        Cue *newCue = [[Cue alloc]init];
        newCue.person = imagePersonPath;
        newCue.image_path = imageBackgroundPath;
        newCue.rehearsalScheduleID = i;
        
        UInt32 randNumber = 0;
        int result = SecRandomCopyBytes(kSecRandomDefault, sizeof(int), (uint8_t*)&randNumber);
        if (result != 0) {
            randNumber = arc4random();
            NSLog(@"Used arc4random");
        }
        randNumber = (randNumber % 10)+1;
        
        UInt32 randNumber2 = 0;
        int result2 = SecRandomCopyBytes(kSecRandomDefault, sizeof(int), (uint8_t*)&randNumber2);
        if (result2 != 0) {
            randNumber2 = arc4random();
            NSLog(@"Used arc4random");
        }
        randNumber2 = (randNumber2 % 10)+1;

        Action *newAction = [self.dbManager getActionByID:randNumber];
        Object *newObject = [self.dbManager getObjectByID:randNumber2];
        Association *newAssociation = [[Association alloc]init];
        newAssociation.action = newAction.name;
        newAssociation.object = newObject.name;
        newCue.associationID = [self.dbManager insertAssociation:newAssociation];

        [self.dbManager insertCue:newCue];
    }
}

@end