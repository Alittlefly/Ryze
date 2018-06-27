//
//  NSObject+RyzeAdditionsORM.h
//  libRyze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const identifier;

@interface NSObject (RyzeAdditionsORM)
/**
 *  For the corresponding database table primary key id
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  Properties and corresponding values
 */
@property (nonatomic, readonly) NSMutableDictionary *keyValues;

/**
 *  The key is the best as the property name，if not. @see mapping
 */
- (instancetype)initWithDictionary_Ryze:(NSDictionary *)keyValues;

/**
 *  If the property type is a custom class, you need to overwrite this method.
 *
 *  @return key is property name, value is model class, default return @{};
 */
- (NSDictionary *)ryze_objectPropertys;

/*
 *  If the property type is a NSArray<...>, and property type is a custom class, you need to overwrite this method.
 *
 *  @return key is property name, value is generic, default return @{};
 */
- (NSDictionary *)ryze_genericForArray;

/**
 *  If the property name and the JSON keys is not the same key, you need to overwrite this method.
 *
 *  @return key is datasource's key, value is property name, default return @{}.
 */
- (NSDictionary *)ryze_mapping;

/**
 *  If the model class name and the table name is different, you need to overwrite this method.
 *
 *  @return default return the class name.
 */
+ (NSString *)ryze_tableName;
@end
