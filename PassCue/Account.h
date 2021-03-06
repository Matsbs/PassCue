//
//  Account.h
//  PassCue
//
//  Created by Mats Sandvoll on 13.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//
//  Account object header

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *notes;
@property int sharingSetID;
@property int accountID;

@end
