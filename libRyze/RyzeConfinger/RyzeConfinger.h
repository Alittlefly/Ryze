//
//  RyzeConfinger.h
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RyzeUploadType){
    RyzeUploadTypeByAmount, // 数量 default
    RyzeUploadTypeByTime, // 时间
};

@interface RyzeConfinger : NSObject
// default RyzeUploadTypeByAmount
@property(nonatomic,assign,readonly)RyzeUploadType uploadType;
// default YES
@property(nonatomic,assign,readonly)BOOL enableGizp;
// default 50
@property(nonatomic,assign,readonly)NSInteger max;
// 按时间上传间隔 单位/秒   只在 uploadType 为 RyzeUploadTypeByTime 下生效
@property(nonatomic,assign,readonly)NSTimeInterval interval;

+ (instancetype)defaultConfinger;
//
- (void)setUploadType:(RyzeUploadType)uploadType;
// 是否启用gzip压缩
- (void)enableGizp:(BOOL)enable;
// 设置单次上传条数
- (void)setMaxToUpLoad:(NSInteger)max;
// 修改时间间隔
- (void)setTimeInterval:(NSTimeInterval)interval;
@end
