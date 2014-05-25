//
//  DBManager.m
//  PassCue
//
//  Created by Mats Sandvoll on 01.02.14.
//  Copyright (c) 2014 Mats Sandvoll. All rights reserved.
//
//  Database manager object
#import "DBManager.h"

@implementation DBManager

//  Open database
- (void)openDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"PassCueDB.db"]];
    //NSFileManager *filemgr = [NSFileManager defaultManager];
    //if ([filemgr fileExistsAtPath: _databasePath ] == NO){
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSLog(@"DB open");
    }else{
        NSLog(@"Failed to open DB");
    }
}

//  Close database
- (void)closeDB{
    sqlite3_close(_PassCueDB);
    NSLog(@"DB closed");
}

//  Initialize database and create tables
- (void)initDatabase{
    [self openDB];
    char *errMsg;
    const char *sql_stmt ="CREATE TABLE IF NOT EXISTS ACTIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, IMAGE TEXT)";
    if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sql_stmt ="CREATE TABLE IF NOT EXISTS OBJECTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, IMAGE TEXT)";
    if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sql_stmt ="CREATE TABLE IF NOT EXISTS REHEARSAL_SCHEDULES (ID INTEGER PRIMARY KEY AUTOINCREMENT, I INTEGER, REHEARSE_TIME DOUBLE, TIME TEXT)";
    if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sql_stmt ="CREATE TABLE IF NOT EXISTS SHARING_SETS (ID INTEGER PRIMARY KEY AUTOINCREMENT, CUE1 INTEGER, CUE2 INTEGER, CUE3 INTEGER, CUE4 INTEGER, AVAILABLE BOOL, FOREIGN KEY (CUE1) REFERENCES CUES(ID), FOREIGN KEY (CUE2) REFERENCES CUES(ID), FOREIGN KEY (CUE3) REFERENCES CUES(ID), FOREIGN KEY (CUE4) REFERENCES CUES(ID) )";
    if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sql_stmt ="CREATE TABLE IF NOT EXISTS ASSOCIATIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ACTION TEXT, OBJECT TEXT, FOREIGN KEY (ACTION) REFERENCES ACTIONS(NAME), FOREIGN KEY (OBJECT) REFERENCES OBJECTS(NAME) )";
    if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sql_stmt ="CREATE TABLE IF NOT EXISTS CUES (ID INTEGER PRIMARY KEY AUTOINCREMENT, PERSON TEXT, IMAGE TEXT, ASSOCIATION INTEGER, REHEARSAL_SCHEDULE INTEGER , FOREIGN KEY (ASSOCIATION) REFERENCES ASSOCIATIONS(ID), FOREIGN KEY (REHEARSAL_SCHEDULE) REFERENCES REHEARSAL_SCHEDULES(ID) )";
    if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sql_stmt ="CREATE TABLE IF NOT EXISTS ACCOUNTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT,  SHARING_SET INTEGER, NOTES TEXT, FOREIGN KEY (SHARING_SET) REFERENCES SHARING_SETSS(ID) )";
    if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
}

//  Set database file path
- (void)setDbPath{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    self.databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"PassCueDB.db"]];
}

//  Insert objects to associated table in database
- (int)insertObject:(Object *)object{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO OBJECTS (NAME, IMAGE) VALUES (\"%@\", \"%@\")", object.name, object.image_path];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Object inserted.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}
- (int)insertAction:(Action *)action{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO ACTIONS (NAME, IMAGE) VALUES (\"%@\", \"%@\")", action.name, action.image_path];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Action inserted.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}
- (int)insertAssociation:(Association *)association{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO ASSOCIATIONS (ACTION, OBJECT) VALUES (\"%@\", \"%@\")", association.action, association.object];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Association inserted.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}
- (int)insertCue:(Cue *)cue{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CUES (PERSON, IMAGE, ASSOCIATION, REHEARSAL_SCHEDULE) VALUES (\"%@\", \"%@\", \"%d\", \"%d\")", cue.person, cue.image_path, cue.associationID, cue.rehearsalScheduleID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Cue inserted.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}
- (int)insertAccount:(Account *)account{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO ACCOUNTS (NAME, SHARING_SET, NOTES) VALUES (\"%@\", \"%d\", \"%@\")", account.name, account.sharingSetID, account.notes];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Account inserted.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}
- (int)insertSharingSet:(SharingSet *)sharingSet{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO SHARING_SETS (CUE1, CUE2, CUE3, CUE4, AVAILABLE) VALUES (\"%d\", \"%d\", \"%d\", \"%d\", \"%d\")", sharingSet.cue1ID, sharingSet.cue2ID, sharingSet.cue3ID, sharingSet.cue4ID, sharingSet.available];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Sharing Set inserted.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}
- (int)insertRehearsalSchedule:(RehearsalSchedule *)rehearsalSchedule{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO REHEARSAL_SCHEDULES (I, REHEARSE_TIME) VALUES (\"%d\", \"%f\")", rehearsalSchedule.i, rehearsalSchedule.rehearseTime];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Rehearsal Schedule inserted.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}

//  Get objects by ID or name from associated table in database
- (RehearsalSchedule*)getRehearsalScheduleByID:(int)rsID{
    RehearsalSchedule *rehearsalSchedule = [[RehearsalSchedule alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM REHEARSAL_SCHEDULES WHERE ID = (\"%d\")",rsID];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            rehearsalSchedule.rehearsalScheduleID = sqlite3_column_int(statement, 0);
            rehearsalSchedule.i = sqlite3_column_int(statement, 1);
            rehearsalSchedule.rehearseTime = sqlite3_column_double(statement, 2);
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return rehearsalSchedule;
}
- (Action*)getActionByName:(NSString *)actionName{
    Action *action = [[Action alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACTIONS WHERE NAME = (\"%@\")",actionName];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            action.actionID = sqlite3_column_int(statement, 0);
            action.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            action.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return action;
}
- (Action*)getActionByID:(int)actionID{
    Action *action = [[Action alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACTIONS WHERE ID = (\"%d\")",actionID];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            action.actionID = sqlite3_column_int(statement, 0);
            action.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            action.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return action;
}
- (Object*)getObjectByName:(NSString *)objectName{
    Object *object = [[Object alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM OBJECTS WHERE NAME = (\"%@\")",objectName];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            object.objectID = sqlite3_column_int(statement, 0);
            object.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            object.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return object;
}
- (Object*)getObjectByID:(int)objectID{
    Object *object = [[Object alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM OBJECTS WHERE ID = (\"%d\")",objectID];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            object.objectID = sqlite3_column_int(statement, 0);
            object.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            object.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return object;
}
- (NSMutableArray*)getAllActions{
    NSMutableArray *actions =[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACTIONS"];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            Action *newAction = [[Action alloc]init];
            newAction.actionID = sqlite3_column_int(statement, 0);
            newAction.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            newAction.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            [actions addObject:newAction];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return actions;
}
- (NSMutableArray*)getAllObjects{
    NSMutableArray *objects =[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM OBJECTS"];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            Object *newObject = [[Object alloc]init];
            newObject.objectID = sqlite3_column_int(statement, 0);
            newObject.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            newObject.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            [objects addObject:newObject];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return objects;
}
- (Association*)getAssociationByID:(int)associationID{
    Association *association = [[Association alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ASSOCIATIONS WHERE ID = (\"%d\")",associationID];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            association.associationID = sqlite3_column_int(statement, 0);
            association.action = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            association.object = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return association;
}
- (NSMutableArray*)getAllAssociations{
    NSMutableArray *associations =[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ASSOCIATIONS"];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            Association *newAssociation = [[Association alloc]init];
            newAssociation.associationID = sqlite3_column_int(statement, 0);
            newAssociation.action = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            newAssociation.object = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            [associations addObject:newAssociation];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return associations;
}
- (Cue*)getCueByID:(int)cueID{
    Cue *cue = [[Cue alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CUES WHERE ID = (\"%d\")",cueID];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            cue.cueID = sqlite3_column_int(statement, 0);
            cue.person = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            cue.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            cue.associationID = sqlite3_column_int(statement, 3);
            cue.rehearsalScheduleID = sqlite3_column_int(statement, 4);
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return cue;
}
- (NSMutableArray*)getAllCues{
    NSMutableArray *cues =[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CUES"];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            Cue *newCue = [[Cue alloc]init];
            newCue.cueID = sqlite3_column_int(statement, 0);
            newCue.person = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            newCue.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            newCue.associationID = sqlite3_column_int(statement, 3);
            newCue.rehearsalScheduleID = sqlite3_column_int(statement, 4);
            [cues addObject:newCue];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return cues;
}
- (SharingSet*)getSharingSetByID:(int)sharingSetID{
    SharingSet *sharingSet = [[SharingSet alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SHARING_SETS WHERE ID = (\"%d\")",sharingSetID];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            sharingSet.sharingSetID = sqlite3_column_int(statement, 0);
            sharingSet.cue1ID = sqlite3_column_int(statement, 1);
            sharingSet.cue2ID = sqlite3_column_int(statement, 2);
            sharingSet.cue3ID = sqlite3_column_int(statement, 3);
            sharingSet.cue4ID = sqlite3_column_int(statement, 4);
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return sharingSet;
}
- (Account*)getAccountByID:(int)accountID{
    Account *account = [[Account alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACCOUNTS WHERE ID = (\"%d\")",accountID];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            account.accountID = sqlite3_column_int(statement, 0);
            account.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            account.sharingSetID = sqlite3_column_int(statement, 2);
            account.notes = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return account;
}
- (NSMutableArray*)getAllAccounts{
    NSMutableArray *accounts =[[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACCOUNTS"];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            Account *newAccount = [[Account alloc]init];
            newAccount.accountID = sqlite3_column_int(statement, 0);
            newAccount.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            newAccount.sharingSetID = sqlite3_column_int(statement, 2);
            newAccount.notes = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            [accounts addObject:newAccount];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return accounts;
}
- (NSMutableArray *)getAccountsByCueID:(int)cueID{
    NSMutableArray *accounts = [[NSMutableArray alloc]init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT a.id, a.name,a.sharing_set,a.notes FROM Accounts A JOIN Sharing_sets ON A.sharing_set=sharing_sets.id where (sharing_sets.cue1 = \"%d\" OR sharing_sets.cue2 = \"%d\" OR sharing_sets.cue3 = \"%d\" OR sharing_sets.cue4 = \"%d\"  )",cueID ,cueID, cueID, cueID];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            Account *newAccount = [[Account alloc]init];
            newAccount.accountID = sqlite3_column_int(statement, 0);
            newAccount.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            newAccount.sharingSetID = sqlite3_column_int(statement, 2);
            newAccount.notes = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            [accounts addObject:newAccount];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return accounts;
}
- (NSMutableArray *)getAvailableSharingSetIDs{
    NSMutableArray *sharingSetIDs = [[NSMutableArray alloc]init];
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT ID FROM SHARING_SETS"];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            [sharingSetIDs addObject:[NSNumber numberWithInt:sqlite3_column_int(statement, 0)]];
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return sharingSetIDs;
}

//  Delete objects from the associated table in database
- (void)deleteAccount:(Account *)account{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM ACCOUNTS WHERE (ID) = (\"%d\")", account.accountID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Account deleted");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
}
- (void)deleteAssociationFromCue:(Cue *)cue{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE CUES SET ASSOCIATION = \"%d\" WHERE ID = \"%d\"", 0, cue.cueID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Association removed from cue");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
}
- (void)deleteCueAndRemoveFromSharingSets:(Cue *)cue{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM SHARING_SETS WHERE (CUE1 = (\"%d\") OR CUE2 = (\"%d\") OR CUE3 = (\"%d\") OR CUE4 = (\"%d\") )", cue.cueID, cue.cueID, cue.cueID, cue.cueID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Cue deleted from sharing set.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    insertSQL = [NSString stringWithFormat:@"DELETE FROM CUES WHERE ID = (\"%d\")", cue.cueID];
    insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Cue deleted.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_finalize(statement);
}
- (void)removeAssociationByCueAndCueID:(Cue *)cue : (int)cueID{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM ASSOCIATIONS WHERE (ID) = (\"%d\")", cue.associationID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Association deleted");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    NSLog(@"Resetting statement before creating new statement in remove asssociations from cue");
    insertSQL = [NSString stringWithFormat:@"UPDATE CUES SET ASSOCIATION = \"%d\" WHERE ID = \"%d\"", 0, cueID];
    insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Association removed from cue");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
}

//  Set/reset/update an object by object or objectID
- (void)setSharingIDByAccountID:(int)accountID : (int)sharingID{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE ACCOUNTS SET SHARING_SET = \"%d\" WHERE ID = \"%d\"", sharingID, accountID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Account updated with sharing set ID");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    insertSQL = [NSString stringWithFormat:@"UPDATE SHARING_SETS SET AVAILABLE = \"%d\" WHERE ID = \"%d\"", 0, sharingID];
    insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Sharing set is not available.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
}
- (void)setSharingSetAvailableByAccount:(Account *)account{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE SHARING_SETS SET AVAILABLE = \"%d\" WHERE ID = \"%d\"", 1, account.sharingSetID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Sharing set is available.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
}
- (void)resetRehearsalScheduleByID:(int)rehearsalScheduleID{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE REHEARSAL_SCHEDULES SET I = \"%d\"  WHERE ID = \"%d\"", 0, rehearsalScheduleID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Rehearsal Schedule reset.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
}
- (void)setAssociationIDForCueID:(int)cueID : (int)associationID{
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE CUES SET ASSOCIATION = \"%d\"  WHERE ID = \"%d\"", associationID, cueID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"AssociationID updated for cue.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
}
- (void)updateRehearsalSchedule:(RehearsalSchedule *)rehearsalSchedule{
    NSDate *dateToWrite = [NSDate dateWithTimeIntervalSince1970:rehearsalSchedule.rehearseTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss z"];
    NSString *stringToWrite = [dateFormatter stringFromDate:dateToWrite];
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE REHEARSAL_SCHEDULES SET I = \"%d\", REHEARSE_TIME = \"%f\", TIME = \"%@\" WHERE ID = \"%d\"", rehearsalSchedule.i, rehearsalSchedule.rehearseTime, stringToWrite, rehearsalSchedule.rehearsalScheduleID];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE){
        NSLog(@"Rehearsal schedule updated.");
    }else{
        NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
}

//  Return the number of active accounts
- (int)numberOfAccounts{
    int nrOfAccounts = 0;
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT ID FROM ACCOUNTS ORDER BY ID DESC LIMIT 1"];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            nrOfAccounts = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    NSLog(@"nr of accounts %d", nrOfAccounts);
    return nrOfAccounts;
}

//  Return the number of available sharing sets
- (int)numberOfSharingSets{
    int nrOfSharingSets;
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT (*) FROM SHARING_SETS"];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            nrOfSharingSets = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return nrOfSharingSets;
}

//  Check is a sharing set is available by sharingsetID
- (bool)sharingSetAvailable:(int)sharingSetID{
    bool isAvailable = NO;
    sqlite3_stmt *statement;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT AVAILABLE FROM SHARING_SETS WHERE ID = \"%d\"",sharingSetID];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            isAvailable = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    return isAvailable;
}

@end
