//
//  RyzeDBHelper.h
//  libRyze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "NSObject+RyzeAdditionsORM.h"


@interface RyzeDBHelper : NSObject

/**
 *  Setting up the database file
 */
+ (void)ryze_setDataBaseName:(NSString *)name;

/**
 *  Use @sql create
 */
+ (BOOL)ryze_createTable:(NSString *)sql;


/**
 *  Use name create
 */
+ (BOOL)ryze_createTableName:(NSString *)tableName;

/**
 *  Drop table use tableName
 */
+ (BOOL)ryze_dropTable:(NSString *)tableName;

/**
 *  Use @sql insert
 */
+ (BOOL)ryze_insert:(NSString *)sql;

/**
 *  Use @obj insert
 */
+ (BOOL)ryze_insertObject:(NSObject *)obj;

/**
 *  Insert or replace @keyValues into @table
 */
+ (BOOL)ryze_insert:(NSString *)table keyValues:(NSDictionary *)keyValues;

/**
 *  Insert @keyValues into @table
 *
 *  @param replace    if have is the same record, whether you need to replace
 */
+ (BOOL)ryze_insert:(NSString *)table keyValues:(NSDictionary *)keyValues replace:(BOOL)replace;

/**
 *  Use @sql Update
 */
+ (BOOL)ryze_update:(NSString *)sql;

/**
 *  Use @obj Update
 */
+ (BOOL)ryze_updateObject:(NSObject *)obj;

/**
 *  Use @keyValues updated @table
 *
 *  @warning the default where is "id=?", so @keyValues must include "id"
 */
+ (BOOL)ryze_update:(NSString *)table keyValues:(NSDictionary *)keyValues;

/**
 *  If the @where are met, use @keyValues updated @table
 */
+ (BOOL)ryze_update:(NSString *)table keyValues:(NSDictionary *)keyValues where:(NSString *)where;

/**
 *  Delete from @table
 */
+ (BOOL)ryze_remove:(NSString *)table;

/**
 *  Use @obj delete
 */
+ (BOOL)ryze_removeObject:(NSObject *)obj;

/**
 *  Delete from @table where id=@id_
 */
+ (BOOL)ryze_removeById:(NSString *)id_ from:(NSString *)table;

/**
 *  Delete from @table @where
 */
+ (BOOL)ryze_remove:(NSString *)table where:(NSString *)where;

/**
 *  Select * from @table
 */
+ (NSMutableArray *)ryze_query:(NSString *)table;

/**
 *  Select * from @table where id=@id_
 */
+ (NSDictionary *)ryze_queryById:(NSString *)id_ from:(NSString *)table;

/**
 *  Select * from @table @where
 */
+ (NSMutableArray *)ryze_query:(NSString *)table where:(NSString *)where, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  Select count(id) from @table
 */
+ (NSInteger)ryze_totalRowOfTable:(NSString *)table;

/**
 *  Select count(id) from @table @where
 */
+ (NSInteger)ryze_totalRowOfTable:(NSString *)table where:(NSString *)where;

/**
 *  batch execute @sqls
 *
 *  @param useTransaction    whether to use transaction
 */
+ (BOOL)ryze_executeBatch:(NSArray *)sqls useTransaction:(BOOL)useTransaction;
/**
 *   插入多条数据
 *
 *
 */
+ (void)ryze_insertObjects:(NSArray *)objects;
@end
