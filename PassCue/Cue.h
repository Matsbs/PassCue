//
//  Cue.h
//  PassCue
//
//  Created by Mats Sandvoll on 17.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cue : NSObject

@property (nonatomic, retain) NSString *person;
@property (nonatomic, retain) NSString *image_path;
@property int associationID;
@property int cueID;
@property int rehearsalScheduleID;

@end
