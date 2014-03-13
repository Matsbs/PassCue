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
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"TASK.db"]];
    //NSFileManager *filemgr = [NSFileManager defaultManager];
    //if ([filemgr fileExistsAtPath: _databasePath ] == NO){
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
            char *errMsg;
            const char *sql_stmt ="CREATE TABLE IF NOT EXISTS TASKS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, DESCRIPTION TEXT, DATE TEXT, NOTIFY BOOL)";
            if (sqlite3_exec(_TASKDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK){
                NSLog(@"%s",sqlite3_errmsg(_TASKDB));
            }
            sqlite3_close(_TASKDB);
        } else {
        }
        NSLog(@"Database created! Path: %@",_databasePath);
        
    //}
}

- (void)setDbPath{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    self.databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"TASK.db"]];
}

- (int)insertTask:(Task *)task{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO TASKS (name, description, date) VALUES (\"%@\", \"%@\", \"%@\")", task.name, task.description, task.date];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_TASKDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Task inserted");
        }else{
            NSLog(@"%s",sqlite3_errmsg(_TASKDB));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(_TASKDB);
    }
   return (int)sqlite3_last_insert_rowid(_TASKDB);
}

- (void)updateTaskByID:(Task *)task : (int)ID{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE TASKS SET NAME = \"%@\", DESCRIPTION = \"%@\", DATE = \"%@\", NOTIFY = \"%d\" WHERE ID = \"%d\"", task.name, task.description, task.date, task.notify, ID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_TASKDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Task updated");
        }else{
            NSLog(@"%s",sqlite3_errmsg(_TASKDB));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(_TASKDB);
    }
}

- (void)deleteTask:(Task *)task{
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM TASKS WHERE (NAME) = (\"%@\")", task.name];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_TASKDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"Task deleted");
        }else{
            NSLog(@"%s",sqlite3_errmsg(_TASKDB));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(_TASKDB);
    }
}

- (NSMutableArray*)getAllTasks{
    NSMutableArray *Tasks =[[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TASKS"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_TASKDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW){
                Task *newTask = [[Task alloc]init];
                newTask.taskID = sqlite3_column_int(statement, 0);
                newTask.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                newTask.description = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                newTask.date = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                [Tasks addObject:newTask];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_TASKDB);
    }
    return Tasks;
}

- (Task *)getTaskByID:(int)ID{
    Task *task = [[Task alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_TASKDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TASKS WHERE ID = (\"%d\")", ID];
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(_TASKDB, query_stmt,-1, &statement, NULL);
        if (sqlite3_prepare_v2(_TASKDB,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                task.taskID = sqlite3_column_int(statement, 0);
                task.name = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                task.description = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                task.date = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                task.notify = sqlite3_column_int(statement, 4);
            }
        sqlite3_finalize(statement);
        sqlite3_close(_TASKDB);
        }
    }
    return task;
}

@end
