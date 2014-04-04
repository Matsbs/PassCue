//
//  DBManager.h
//  PassCue
//
//  Created by Mats Sandvoll on 01.02.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Task.h"
#import "Action.h"
#import "Object.h"
#import "Association.h"
#import "Cue.h"
#import "Account.h"
#import "SharingSet.h"
#import "RehearsalSchedule.h"

@interface DBManager : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (atomic) sqlite3 *PassCueDB;

- (void)initDatabase;
- (void)setDbPath;
- (int)insertAction:(Action *)action;
- (int)insertObject:(Object *)object;
- (int)insertAssociation:(Association *)association;
- (int)insertCue:(Cue *)cue;
- (int)insertAccount:(Account *)account;
- (int)insertSharingSet:(SharingSet *)sharingSet;
- (int)insertRehearsalSchedule:(RehearsalSchedule *)rehearsalSchedule;
- (void)updateRehearsalSchedule:(RehearsalSchedule *)rehearsalSchedule;
- (Action*)getActionByName:(NSString *)actionName;
- (Action*)getActionByID:(int)actionID;
- (Object*)getObjectByName:(NSString *)objectName;
- (Object*)getObjectByID:(int)objectID;
- (RehearsalSchedule*)getRehearsalScheduleByID:(int)rsID;
- (NSMutableArray*)getAllActions;
- (NSMutableArray*)getAllObjects;
- (Association*)getAssociationByID:(int)associationID;
- (NSMutableArray*)getAllAssociations;
- (Cue*)getCueByID:(int)cueID;
- (NSMutableArray*)getAllCues;
- (SharingSet*)getSharingSetByID:(int)sharingSetID;
- (Account*)getAccountByID:(int)accountID;
- (NSMutableArray*)getAllAccounts;
- (void)deleteAccount:(Account *)account;
- (void)deleteAssociationFromCue:(Cue *)cue;
- (void)setSharingIDByAccountID:(int)accountID : (int)sharingID;
- (void)removeAssociationByCueAndCueID:(Cue *)cue : (int)cueID;
- (void)openDB;
- (void)closeDB;
- (NSMutableArray *)getAccountsByCueID:(int)cueID;

@end
