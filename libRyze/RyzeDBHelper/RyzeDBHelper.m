//
//  RyzeDBHelper.m
//  libRyze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "RyzeDBHelper.h"

@implementation RyzeDBHelper

static NSString *dbName = @"";

+ (void)ryze_setDataBaseName:(NSString *)name {
    NSAssert(name, @"name cannot be nil!");
    
    dbName = name;
    
    NSString *dbPath = [self ryze_dbPath];

    if(![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        // bundle
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:dbName ofType:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
            [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:[self ryze_dbPath] error:nil];
        } else {
           // create
           BOOL success = [[NSFileManager defaultManager] createFileAtPath:dbPath contents:nil attributes:@{NSFileProtectionKey:NSFileProtectionNone}];
            if (success) {
                NSLog( @"%@ does exist!", dbName);
            }
        }
    }
}

+ (BOOL)ryze_createTable:(NSString *)sql{
    return [self ryze_executeUpdate:sql args:nil];
}

+ (BOOL)ryze_createTableName:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@", tableName];
    
    return [self ryze_executeUpdate:sql args:nil];
}

+ (BOOL)ryze_dropTable:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    
    return [self ryze_executeUpdate:sql args:nil];
}

#pragma mark - insert

+ (BOOL)ryze_insert:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self ryze_executeUpdate:sql args:nil];
}

+ (BOOL)ryze_insertObject:(NSObject *)obj {
    NSAssert(obj, @"obj cannot be nil!");
    
    return [self ryze_insert:[[obj class] ryze_tableName] keyValues:[obj keyValues]];
}

+ (BOOL)ryze_insert:(NSString *)table keyValues:(NSDictionary *)keyValues {
    NSAssert(table && keyValues, @"table or keyValues cannot be nil!");
    
    return [self ryze_insert:table keyValues:keyValues replace:YES];
}

+ (BOOL)ryze_insert:(NSString *)table keyValues:(NSDictionary *)keyValues replace:(BOOL)replace {
    NSAssert(table && keyValues, @"table or keyValues cannot be nil!");
    
    NSMutableArray *columns = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *placeholder = [NSMutableArray array];
    
    [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj && ![obj isEqual:[NSNull null]]) {
            [columns addObject:key];
            [values addObject:obj];
            [placeholder addObject:@"?"];
        }
    }];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"INSERT%@ INTO %@ (%@) VALUES (%@)", replace ? @" OR REPLACE" : @"", table, [columns componentsJoinedByString:@","], [placeholder componentsJoinedByString:@","]];
    
    return [self ryze_executeUpdate:sql args:values];
}

+ (void)ryze_insertObjects:(NSArray *)objects {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self ryze_dbPath]];
    
    if ([db open]) {
        // 改造 一次打开 多次插入
        BOOL replace = YES;
        
        for (NSObject *object in objects) {
            
            NSString *table = [[object class] ryze_tableName];
            NSDictionary *keyValues = [object keyValues];
            
            NSMutableArray *columns = [NSMutableArray array];
            NSMutableArray *values = [NSMutableArray array];
            NSMutableArray *placeholder = [NSMutableArray array];
            
            [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (obj && ![obj isEqual:[NSNull null]]) {
                    [columns addObject:key];
                    [values addObject:obj];
                    [placeholder addObject:@"?"];
                }
            }];
            
            NSString *sql = [[NSString alloc] initWithFormat:@"INSERT%@ INTO %@ (%@) VALUES (%@)", replace ? @" OR REPLACE" : @"", table, [columns componentsJoinedByString:@","], [placeholder componentsJoinedByString:@","]];
            BOOL success = [db executeUpdate:sql withArgumentsInArray:values];
            if (success) {
                NSLog(@"sql %@",sql);
            }
        }
        
        [db close];
    }
    
    db = nil;
}

#pragma mark - update

+ (BOOL)ryze_update:(NSString *)sql {
    NSAssert(sql, @"sql cannot be nil!");
    
    return [self ryze_executeUpdate:sql args:nil];
}

+ (BOOL)ryze_updateObject:(NSObject *)obj {
    NSAssert(obj, @"obj cannot be nil!");
    
    return [self ryze_update:[[obj class] ryze_tableName] keyValues:[obj keyValues]];
}

+ (BOOL)ryze_update:(NSString *)table keyValues:(NSDictionary *)keyValues {
    NSAssert(table && keyValues, @"table or keyValues cannot be nil!");
    NSAssert(keyValues[identifier], @"keyValues[@\"%@\"] cannot be nil!", identifier);
    
    return [self ryze_update:table keyValues:keyValues where:[NSString stringWithFormat:@"%@='%@'", identifier, keyValues[identifier]]];
}

+ (BOOL)ryze_update:(NSString *)table keyValues:(NSDictionary *)keyValues where:(NSString *)where {
    NSAssert(table && keyValues && where, @"table,keyValues,where can't be nil!");
    
    NSMutableArray *settings = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj && ![obj isEqual:[NSNull null]]) {
            [settings addObject:[NSString stringWithFormat:@"%@=?", key]];
            [values addObject:obj];
        }
    }];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE %@ SET %@ WHERE %@", table, [settings componentsJoinedByString:@","], where];
    
    return [self ryze_executeUpdate:sql args:values];
}

#pragma mark - remove

+ (BOOL)ryze_remove:(NSString *)table {
    NSAssert(table, @"table cannot be nil!");
    
    return [self ryze_remove:table where:@"1=1"];
}

+ (BOOL)ryze_removeObject:(NSObject *)obj {
    NSAssert(obj, @"obj cannot be nil!");
    
    return [self ryze_removeById:obj.ID from:[[obj class] ryze_tableName]];
}

+ (BOOL)ryze_removeById:(NSString *)id_ from:(NSString *)table {
    NSAssert(id_ && table, @"id_ or table cannot be nil!");
    
    return [self ryze_remove:table where:[NSString stringWithFormat:@"%@='%@'", identifier, id_]];
}

+ (BOOL)ryze_remove:(NSString *)table where:(NSString *)where {
    NSAssert(table && where, @"table or where cannot be nil!");
    
    NSString *sql = [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE %@", table, where];
    
    return [self ryze_executeUpdate:sql args:nil];
}


#pragma mark - query

+ (NSMutableArray *)ryze_query:(NSString *)table {
    NSAssert(table, @"table cannot be nil!");
    
    return [self ryze_query:table where:@"1=1", nil];
}

+ (NSDictionary *)ryze_queryById:(NSString *)id_ from:(NSString *)table {
    NSAssert(id_ && table, @"id_ or table cannot be nil!");
    
    NSMutableArray *result = [self ryze_query:table where:[NSString stringWithFormat:@"%@=?", identifier], id_, nil];
    
    return (result.count > 0) ? result.firstObject : nil;
}

+ (NSMutableArray *)ryze_query:(NSString *)table where:(NSString *)where, ... {
    NSAssert(table && where, @"table or where cannot be nil!");
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:10];
    
    va_list args;
    va_start(args, where);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self ryze_dbPath]];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", table, where] withVAList:args];
        while ([rs next]) {
            [result addObject:[rs resultDictionary]];
        }
        
        [db close];
    }
    
    db = nil;
    
    va_end(args);
    
    return result;
}

+ (NSInteger)ryze_totalRowOfTable:(NSString *)table {
    NSAssert(table, @"table cannot be nil!");
    
    return [self ryze_totalRowOfTable:table where:@"1=1"];
}

+ (NSInteger)ryze_totalRowOfTable:(NSString *)table where:(NSString *)where {
    NSAssert(table && where, @"table or where cannot be nil!");
    
    NSInteger totalRow = 0;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self ryze_dbPath]];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(%@) totalRow FROM %@ WHERE %@", identifier, table, where]];
        if ([rs next]) {
            totalRow = [[rs resultDictionary][@"totalRow"] integerValue];
        }
        
        [db close];
    }
    
    db = nil;
    
    return totalRow;
}

#pragma mark - batch

+ (BOOL)ryze_executeBatch:(NSArray *)sqls useTransaction:(BOOL)useTransaction {
    NSAssert(sqls, @"sqls cannot be nil!");
    
    __block BOOL success = YES;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self ryze_dbPath]];
    
    if (useTransaction) {
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (NSString *sql in sqls) {
                if (![db executeUpdate:sql]) {
                    *rollback = YES;
                    success = NO;
                    break;
                }
            }
        }];
    } else {
        [queue inDatabase:^(FMDatabase *db) {
            for (NSString *sql in sqls) {
                [db executeUpdate:sql];
            }
        }];
    }
    
    return success;
}

#pragma mark - private method

+ (BOOL)ryze_executeUpdate:(NSString *)sql args:(NSArray *)args {
    BOOL success = NO;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self ryze_dbPath]];
    
    if ([db open]) {
        success = [db executeUpdate:sql withArgumentsInArray:args];
        
        [db close];
    }
    
    db = nil;
    
    return success;
}
+ (NSString *)ryze_dbPath {
    NSAssert(dbName, @"dbName cannot be nil!");
    
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:dbName];
}

@end
