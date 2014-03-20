//
//  ImagePickerViewController.h
//  PassCue
//
//  Created by Mats Sandvoll on 19.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ImagePickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) IBOutlet UIImageView *selectedImage;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) DBManager *dbManager;
@property int imageNr;

@end
