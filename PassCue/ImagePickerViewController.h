//
//  ImagePickerViewController.h
//  PassCue
//
//  Created by Mats Sandvoll on 19.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Cue.h"
@interface ImagePickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *personImagePicker;
@property (nonatomic, retain) UIImagePickerController *backgroundImagePicker;
@property (nonatomic, retain) IBOutlet UIImageView *selectedPersonImage;
@property (nonatomic, retain) IBOutlet UIImageView *selectedBackgroundImage;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) DBManager *dbManager;
@property int cueNr;
@property bool isPerson;
@property bool isBackground;

@end
