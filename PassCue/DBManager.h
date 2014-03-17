//
//  DBManager.h
//  To-Do
//
//  Created by Mats Sandvoll on 02.12.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
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

@interface DBManager : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *PassCueDB;

- (void)initDatabase;
- (void)setDbPath;
- (int)insertAction:(Action *)action;
- (int)insertObject:(Object *)object;
- (int)insertAssociation:(Association *)association;
- (int)insertCue:(Cue *)cue;
- (int)insertAccount:(Account *)account;
- (int)insertSharingSet:(SharingSet *)sharingSet;
- (Action*)getActionByID:(int)actionID;
- (Object*)getObjectByID:(int)objectID;
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

//- (void)deleteTask:(Task *)task;
//- (NSMutableArray*)getAllTasks;
//- (void)updateTaskByID:(Task *)task :(int)ID;
//- (Task*)getTaskByID:(int)ID;

@end
