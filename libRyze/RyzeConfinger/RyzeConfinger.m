//
//  RyzeConfinger.m
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "RyzeConfinger.h"

@implementation RyzeConfinger
static RyzeConfinger * confinger;
+ (instancetype)defaultConfinger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (confinger == nil) {
            confinger = [[RyzeConfinger alloc] init];
        }
    });
    return confinger;
}
- (instancetype)init {
    if (self = [super init]) {
        _max = 50;
        _enableGizp = YES;
        _uploadType = RyzeUploadTypeByAmount;
        // 2分钟传一次
        _interval = 120;
    }
    return self;
}
// 是否启用gzip压缩
- (void)enableGizp:(BOOL)enable {
    _enableGizp = enable;
}
// 设置单次上传条数
- (void)setMaxToUpLoad:(NSInteger)max {
    if (max<0) {
        // 非法参数
        return;
    }
    _max = max;
}

- (void)setUploadType:(RyzeUploadType)uploadType {
    _uploadType = uploadType;
}

- (void)setTimeInterval:(NSTimeInterval)interval {
    if (interval <= 0) {
        return;
    }
    _interval = interval;
}
@end
