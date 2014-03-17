//
//  Action.h
//  PassCue
//
//  Created by Mats Sandvoll on 17.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Action : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image_path;
@property int actionID;

@end
