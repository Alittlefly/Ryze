//
//  RyzeUploadProtocol.h
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RyzeSuccessBlock)(void);
typedef void (^RyzeFaildBlock)(void);

@protocol RyzeUploadProtocol <NSObject>
// data 为数组结构的打点数据
// enableGzip 是否经过Gzip压缩的
// succss 提交到服务器成功后请调用这个回调 否者可能导致数据重复提交
// faild 提交到服务器成功后请调用这个回调 否者可能导致数据重复提交
- (void)ryze_uploadData:(NSData *)data
             enableGizp:(BOOL)enableGzip
           successBlock:(RyzeSuccessBlock)success
             faildBlock:(RyzeFaildBlock)faild;
@end
