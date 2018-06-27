//
//  NSObject+RyzeAdditionsORM.m
//  libRyze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "NSObject+RyzeAdditionsORM.h"
#import <objc/runtime.h>

NSString * const identifier = @"id";

@implementation NSObject (RyzeAdditionsORM)

static const void *IDKey;

- (instancetype)initWithDictionary_Ryze:(NSDictionary *)keyValues {
    
    if (self = [self init]) {
        NSAssert(keyValues, @"keyValues cannot be nil!");
        NSAssert([keyValues isKindOfClass:[NSDictionary class]], @"keyValues must be kind of NSDictionary!");
        
        NSDictionary *objectPropertys = [self allObjectPropertys];
        NSDictionary *genericForArray = [self ryze_genericForArray];
        NSDictionary *mapping = [self ryze_mapping];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:keyValues.count];
        [keyValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            NSString *useKey = mapping[key] ? : key;
            
            if ([useKey isEqualToString:identifier]) {
                useKey = NSStringFromSelector(@selector(ID));
            }
            
            if ([value ryze_isValid]) {
                // for sqlite
                if ([value isKindOfClass:[NSString class]] && [NSJSONSerialization isValidJSONObject:value]) {
                    NSError *error = nil;
                    
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                    
                    if (!error) {
                        value = jsonObject;
                    }
                }
                
                if ([value isKindOfClass:[NSNumber class]] && [self ryze_isStringProperty:key]) {
                    value = [value stringValue];
                }
                
                if (objectPropertys[useKey] && [value isKindOfClass:[NSDictionary class]]) {
                    value = [[objectPropertys[useKey] alloc] initWithDictionary_Ryze:value];
                }
                
                if (genericForArray[useKey] && [value isKindOfClass:[NSArray class]]) {
                    NSMutableArray *ary = [NSMutableArray array];
                    
                    [value enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [ary addObject:[[genericForArray[useKey] alloc] initWithDictionary_Ryze:obj]];
                    }];
                    
                    value = ary;
                }
                
                [dict setObject:value forKey:useKey];
            } else {
                [dict setObject:[self ryze_defaultValueForKey:useKey] forKey:key];
            }
        }];
        
        @try { [self setValuesForKeysWithDictionary:dict]; } @catch (NSException *exception) {}
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //NSLog(@"%@, %@", key, value);
}

- (NSString *)ID {
    return objc_getAssociatedObject(self, &IDKey);
}

- (void)setID:(NSString *)ID {
    NSAssert(ID, @"ID cannot be nil!");
    
    objc_setAssociatedObject(self, &IDKey, ID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableDictionary *)keyValues {
    NSDictionary *objectPropertys = [self allObjectPropertys];
    NSDictionary *genericForArray = [self ryze_genericForArray];
    
    NSDictionary *keyValues = [self dictionaryWithValuesForKeys:self.ryze_propertys];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:keyValues.count];
    
    [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([value ryze_isValid]) {
            if (objectPropertys[key]) {
                value = [value keyValues];
            }
            
            if (genericForArray[key]) {
                NSMutableArray *ary = [NSMutableArray array];
                
                [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [ary addObject:[obj keyValues]];
                }];
                
                value = ary;
            }
            
            if ([key isEqualToString:NSStringFromSelector(@selector(ID))]) {
                key = identifier;
            }
            
            [dict setObject:value forKey:key];
        } else {
            if (![key isEqualToString:NSStringFromSelector(@selector(ID))]) {
                [dict setObject:[self ryze_defaultValueForKey:key] forKey:key];
            }
        }
    }];
    
    return dict;
}

- (NSDictionary *)ryze_objectPropertys {
    return @{};
}

- (NSDictionary *)ryze_genericForArray {
    return @{};
}

- (NSDictionary *)ryze_mapping {
    return @{};
}

+ (NSString *)ryze_tableName {
    return NSStringFromClass([self class]);
}

- (NSDictionary *)allObjectPropertys {
    NSMutableDictionary *objectPropertys = [[NSMutableDictionary alloc] init];
    
    id temp = self;
    
    do {
        [objectPropertys addEntriesFromDictionary:[temp ryze_objectPropertys]];
    } while ((temp = [temp superclass]));
    
    return objectPropertys;
}

#pragma mark -

- (id)ryze_defaultValueForKey:(NSString *)key {
    id defaultValue = [NSNull null];
    
    objc_property_t property = class_getProperty([self class], key.UTF8String);
    
    if (property != NULL) {
        NSString *propertyType = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        if ([propertyType hasPrefix:@"T@\"NSString\""]) {
            defaultValue = @"";
        } else if ([propertyType hasPrefix:@"T@\"NSMutableString\""]) {
            defaultValue = [NSMutableString string];
        } else if ([propertyType hasPrefix:@"T@\"NSDictionary\""]) {
            defaultValue = @{};
        } else if ([propertyType hasPrefix:@"T@\"NSMutableDictionary\""]) {
            defaultValue = [NSMutableDictionary dictionary];
        } else if ([propertyType hasPrefix:@"T@\"NSArray\""]) {
            defaultValue = @[];
        } else if ([propertyType hasPrefix:@"T@\"NSMutableArray\""]) {
            defaultValue = [NSMutableArray array];
        } else if ([propertyType hasPrefix:@"T@\"NSNumber\""]) {
            defaultValue = @0;
        } else if ([propertyType hasPrefix:@"TB"]) { // BOOL
            defaultValue = @0;
        } else if ([propertyType hasPrefix:@"Tc"]) { // char
            defaultValue = @0;
        } else if ([propertyType hasPrefix:@"Tq"] || [propertyType hasPrefix:@"Ti"]) { // NSInteger int long
            defaultValue = @0;
        } else if ([propertyType hasPrefix:@"Td"] || [propertyType hasPrefix:@"Tf"]) { // float double CGFloat
            defaultValue = @0;
        }
    }
    
    return defaultValue;
}

- (BOOL)ryze_isStringProperty:(NSString *)key {
    objc_property_t property = class_getProperty(self.class, key.UTF8String);
    
    if (property != NULL) {
        NSString *propertyType = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        return [propertyType containsString:@"String"];
    }
    
    return NO;
}


- (NSMutableArray *)ryze_propertys{
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithCapacity:10];
    [allKeys addObject:NSStringFromSelector(@selector(ID))];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++){
        [allKeys addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
    }
    
    free(properties);
    
    return allKeys;
}

- (BOOL)ryze_isValid {
    return !(self == nil || [self isKindOfClass:[NSNull class]]);
}

@end
