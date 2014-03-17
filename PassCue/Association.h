//
//  Association.h
//  PassCue
//
//  Created by Mats Sandvoll on 17.03.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Association : NSObject

@property (nonatomic, retain) NSString *action;
@property (nonatomic, retain) NSString *object;
@property int associationID;

@end
