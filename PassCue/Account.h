//
//  Account.h
//  PassCue
//
//  Created by Mats Sandvoll on 13.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, retain) NSString *name;
@property int sharingSetID;
@property int accountID;

@end
