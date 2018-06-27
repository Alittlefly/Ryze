//
//  RyzeUploader.m
//  libRyze
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "RyzeUploader.h"

@implementation RyzeUploader
// 上传
- (void)ryze_uploadData:(NSData *)data enableGizp:(BOOL)enableGzip successBlock:(RyzeSuccessBlock)success faildBlock:(RyzeFaildBlock)faild {

    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random_uniform(10) * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_global_queue(0, 0), ^{
        if (success) {
            success();
        }
    });
}
@end
