//
//  RyzeAspectManager.h
//  libRyze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RyzeUploadProtocol.h"

@interface RyzeAspectManager : NSObject

+(void)ryze_createFuntionHook;

+(void)ryze_configUploader:(id<RyzeUploadProtocol>)uploader;

+(void)ryze_setMaxUpload:(NSInteger)max;

+(void)ryze_enableGzip:(BOOL)enable;
// save
+(void)ryze_saveAllUnUploadInfo;

// crash & Terminate
+(void)ryze_UploadAllInfo;

@end
