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
// 创建埋点监控  step last
+(void)ryze_createFuntionHook;
// 创建上传工具 step2
+(void)ryze_configUploader:(id<RyzeUploadProtocol>)uploader;
// 设置最大同时上传条数 默认 50
+(void)ryze_setMaxUpload:(NSInteger)max;
// 是否启用Gzip压缩
+(void)ryze_enableGzip:(BOOL)enable;
// 存储未上传的数据
+(void)ryze_saveAllUnUploadInfo;
// crash & Terminate
+(void)ryze_UploadAllInfo;

@end
