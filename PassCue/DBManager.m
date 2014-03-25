 //
//  DBManager.m
//  To-Do
//
//  Created by Mats Sandvoll on 02.12.13.
//  Copyright (c) 2013 Mats Sandvoll. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

- (void)initDatabase{
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
            char *errMsg;
            const char *sql_stmt ="CREATE TABLE IF NOT EXISTS ACTIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, IMAGE TEXT)";
            if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
            }
            sql_stmt ="CREATE TABLE IF NOT EXISTS OBJECTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, IMAGE TEXT)";
            if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
            }
            sql_stmt ="CREATE TABLE IF NOT EXISTS SHARING_SETS (ID INTEGER PRIMARY KEY AUTOINCREMENT, CUE1 INTEGER, CUE2 INTEGER, CUE3 INTEGER, CUE4 INTEGER, FOREIGN KEY (CUE1) REFERENCES CUES(ID), FOREIGN KEY (CUE2) REFERENCES CUES(ID), FOREIGN KEY (CUE3) REFERENCES CUES(ID), FOREIGN KEY (CUE4) REFERENCES CUES(ID) )";
            if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
            }
            sql_stmt ="CREATE TABLE IF NOT EXISTS ASSOCIATIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ACTION TEXT, OBJECT TEXT, FOREIGN KEY (ACTION) REFERENCES ACTIONS(NAME), FOREIGN KEY (OBJECT) REFERENCES OBJECTS(NAME) )";
            if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
            }
            sql_stmt ="CREATE TABLE IF NOT EXISTS CUES (ID INTEGER PRIMARY KEY AUTOINCREMENT, PERSON TEXT, IMAGE TEXT, ASSOCIATION INTEGER, FOREIGN KEY (ASSOCIATION) REFERENCES ASSOCIATIONS(ID) )";
            if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
            }
            sql_stmt ="CREATE TABLE IF NOT EXISTS ACCOUNTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT,  SHARING_SET INTEGER, REHEARSAL_TIME TEXT, INIT BOOL, FOREIGN KEY (SHARING_SET) REFERENCES SHARING_SETSS(ID) )";
            if (sqlite3_exec(_PassCueDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
            }
            sqlite3_close(_PassCueDB);
        }
        NSLog(@"Database created! Path: %@",_databasePath);
    //}
}

- (void)setDbPath{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    self.databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"PassCueDB.db"]];
}

- (int)insertObject:(Object *)object{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
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
        sqlite3_close(_PassCueDB);
    }
   return (int)sqlite3_last_insert_rowid(_PassCueDB);
}

- (int)insertAction:(Action *)action{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
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
        sqlite3_close(_PassCueDB);
    }
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}

- (int)insertAssociation:(Association *)association{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
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
        sqlite3_close(_PassCueDB);
    }
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}

- (int)insertCue:(Cue *)cue{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CUES (PERSON, IMAGE, ASSOCIATION) VALUES (\"%@\", \"%@\", \"%d\")", cue.person, cue.image_path, cue.associationID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Cue inserted.");
        }else{
            NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(_PassCueDB);
    }
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}

- (int)insertAccount:(Account *)account{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO ACCOUNTS (NAME, SHARING_SET, REHEARSAL_TIME, INIT) VALUES (\"%@\", \"%d\", \"%@\", \"%d\")", account.name, account.sharingSetID, account.rehearsal_time, account.isInitialized];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Account inserted.");
        }else{
            NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(_PassCueDB);
    }
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}

- (int)insertSharingSet:(SharingSet *)sharingSet{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO SHARING_SETS (CUE1, CUE2, CUE3, CUE4) VALUES (\"%d\", \"%d\", \"%d\", \"%d\")", sharingSet.cue1ID, sharingSet.cue2ID, sharingSet.cue3ID, sharingSet.cue4ID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Sharing Set inserted.");
        }else{
            NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(_PassCueDB);
    }
    return (int)sqlite3_last_insert_rowid(_PassCueDB);
}

- (Action*)getActionByName:(NSString *)actionName{
    Action *action = [[Action alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACTIONS WHERE NAME = (\"%@\")",actionName];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                action.actionID = sqlite3_column_int(statement, 0);
                action.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                action.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_PassCueDB);
        }
    }
    return action;    
}

- (Action*)getActionByID:(int)actionID{
    Action *action = [[Action alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACTIONS WHERE ID = (\"%d\")",actionID];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                action.actionID = sqlite3_column_int(statement, 0);
                action.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                action.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_PassCueDB);
        }
    }
    return action;
}

- (Object*)getObjectByName:(NSString *)objectName{
    Object *object = [[Object alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM OBJECTS WHERE NAME = (\"%@\")",objectName];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                object.objectID = sqlite3_column_int(statement, 0);
                object.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                object.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_PassCueDB);
        }
    }
    return object;
}

- (Object*)getObjectByID:(int)objectID{
    Object *object = [[Object alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM OBJECTS WHERE ID = (\"%d\")",objectID];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                object.objectID = sqlite3_column_int(statement, 0);
                object.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                object.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_PassCueDB);
        }
    }
    return object;
}

- (NSMutableArray*)getAllActions{
    NSMutableArray *actions =[[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
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
            sqlite3_finalize(statement);
        }
        sqlite3_close(_PassCueDB);
    }
    return actions;
}

- (NSMutableArray*)getAllObjects{
    NSMutableArray *objects =[[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
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
            sqlite3_finalize(statement);
        }
        sqlite3_close(_PassCueDB);
    }
    return objects;
}

- (Association*)getAssociationByID:(int)associationID{
    Association *association = [[Association alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ASSOCIATIONS WHERE ID = (\"%d\")",associationID];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                association.associationID = sqlite3_column_int(statement, 0);
                association.action = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                association.object = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_PassCueDB);
        }
    }
    return association;
}

- (NSMutableArray*)getAllAssociations{
    NSMutableArray *associations =[[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
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
            sqlite3_finalize(statement);
        }
        sqlite3_close(_PassCueDB);
    }
    return associations;
}

- (Cue*)getCueByID:(int)cueID{
    Cue *cue = [[Cue alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CUES WHERE ID = (\"%d\")",cueID];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                cue.cueID = sqlite3_column_int(statement, 0);
                cue.person = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                cue.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                cue.associationID = sqlite3_column_int(statement, 3);
            }
            sqlite3_finalize(statement);
            sqlite3_close(_PassCueDB);
        }
    }
    return cue;
}

- (NSMutableArray*)getAllCues{
    NSMutableArray *cues =[[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CUES"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW){
                Cue *newCue = [[Cue alloc]init];
                newCue.cueID = sqlite3_column_int(statement, 0);
                newCue.person = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                newCue.image_path = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                newCue.associationID = sqlite3_column_int(statement, 3);
                [cues addObject:newCue];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_PassCueDB);
    }
    return cues;
}

- (SharingSet*)getSharingSetByID:(int)sharingSetID{
    SharingSet *sharingSet = [[SharingSet alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
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
            sqlite3_finalize(statement);
            sqlite3_close(_PassCueDB);
        }
    }
    return sharingSet;
}

- (Account*)getAccountByID:(int)accountID{
    Account *account = [[Account alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACCOUNTS WHERE ID = (\"%d\")",accountID];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, query_stmt,-1, &statement, NULL);
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                account.accountID = sqlite3_column_int(statement, 0);
                account.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                account.sharingSetID = sqlite3_column_int(statement, 2);
                account.rehearsal_time = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                account.isInitialized = sqlite3_column_int(statement, 4);
            }
            sqlite3_finalize(statement);
            sqlite3_close(_PassCueDB);
        }
    }
    return account;
}

- (NSMutableArray*)getAllAccounts{
    NSMutableArray *accounts =[[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ACCOUNTS"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_PassCueDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW){
                Account *newAccount = [[Account alloc]init];
                newAccount.accountID = sqlite3_column_int(statement, 0);
                newAccount.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                newAccount.sharingSetID = sqlite3_column_int(statement, 2);
                newAccount.rehearsal_time = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                newAccount.isInitialized = sqlite3_column_int(statement, 4);
                [accounts addObject:newAccount];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_PassCueDB);
    }
    return accounts;
}

- (void)deleteAccount:(Account *)account{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM ACCOUNTS WHERE (NAME) = (\"%@\")", account.name];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Account deleted");
        }else{
            NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(_PassCueDB);
    }
}

- (void)deleteAssociationFromCue:(Cue *)cue{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
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
        sqlite3_close(_PassCueDB);
    }
}

- (void)setSharingIDByAccountID:(int)accountID : (int)sharingID{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_PassCueDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE ACCOUNTS SET SHARING_SET = \"%d\" WHERE ID = \"%d\"", sharingID, accountID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_PassCueDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Account updated with sharing set ID");
        }else{
            NSLog(@"%s",sqlite3_errmsg(_PassCueDB));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(_PassCueDB);
    }
}
//Remove associations that is no longer in use?


//- (void)updateTaskByID:(Task *)task : (int)ID{
//    sqlite3_stmt *statement;
//    const char *dbpath = [_databasePath UTF8String];
//    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
//        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE TASKS SET NAME = \"%@\", DESCRIPTION = \"%@\", DATE = \"%@\", NOTIFY = \"%d\" WHERE ID = \"%d\"", task.name, task.description, task.date, task.notify, ID];
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(_TASKDB, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE){
//            NSLog(@"Task updated");
//        }else{
//            NSLog(@"%s",sqlite3_errmsg(_TASKDB));
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        sqlite3_close(_TASKDB);
//    }
//}
//
//- (void)deleteTask:(Task *)task{
//    sqlite3_stmt *statement;
//    const char *dbpath = [_databasePath UTF8String];
//    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
//        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM TASKS WHERE (NAME) = (\"%@\")", task.name];
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(_TASKDB, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE){
//            NSLog(@"Task deleted");
//        }else{
//            NSLog(@"%s",sqlite3_errmsg(_TASKDB));
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        sqlite3_close(_TASKDB);
//    }
//}
//
//- (NSMutableArray*)getAllTasks{
//    NSMutableArray *Tasks =[[NSMutableArray alloc] init];
//    const char *dbpath = [_databasePath UTF8String];
//    sqlite3_stmt *statement;
//    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
//        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TASKS"];
//        const char *query_stmt = [querySQL UTF8String];
//        if (sqlite3_prepare_v2(_TASKDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
//            while (sqlite3_step(statement) == SQLITE_ROW){
//                Task *newTask = [[Task alloc]init];
//                newTask.taskID = sqlite3_column_int(statement, 0);
//                newTask.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
//                newTask.description = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
//                newTask.date = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
//                [Tasks addObject:newTask];
//            }
//            sqlite3_finalize(statement);
//        }
//        sqlite3_close(_TASKDB);
//    }
//    return Tasks;
//}
//
//- (Task *)getTaskByID:(int)ID{
//    Task *task = [[Task alloc] init];
//    sqlite3_stmt *statement;
//    const char *dbpath = [_databasePath UTF8String];
//    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
//        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TASKS WHERE ID = (\"%d\")", ID];
//        const char *query_stmt = [querySQL UTF8String];
//        sqlite3_prepare_v2(_TASKDB, query_stmt,-1, &statement, NULL);
//        if (sqlite3_prepare_v2(_TASKDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
//            if (sqlite3_step(statement) == SQLITE_ROW){
//                task.taskID = sqlite3_column_int(statement, 0);
//                task.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
//                task.description = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
//                task.date = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
//                task.notify = sqlite3_column_int(statement, 4);
//            }
//        sqlite3_finalize(statement);
//        sqlite3_close(_TASKDB);
//        }
//    }
//    return task;
//}
//
@end
