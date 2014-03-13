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


@interface DBManager : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *TASKDB;

- (void)initDatabase;
- (void)setDbPath;
- (int)insertTask:(Task *)task;
- (void)deleteTask:(Task *)task;
- (NSMutableArray*)getAllTasks;
- (void)updateTaskByID:(Task *)task :(int)ID;
- (Task*)getTaskByID:(int)ID;


@end
