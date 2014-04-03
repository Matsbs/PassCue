//
//  CueViewController.h
//  PassCue
//
//  Created by Mats Sandvoll on 03.04.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UILabel *cue1Label;
@property (nonatomic, retain) UITableView *cue1Table;

@end
