//
//  RyzeCacheManager.h
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RyzeUploadProtocol.h"

@interface RyzeCacheManager : NSObject

@property(nonatomic,strong)id<RyzeUploadProtocol> uploader;

+ (instancetype)sharedRyzeCache;

+ (void)setDBName:(NSString *)name;

- (void)saveActionInfo:(NSDictionary *)info;

- (void)setUploaderClass:(Class<RyzeUploadProtocol>)className;

- (void)saveAllActions;

- (void)uploadAllActionInfo;
@end
