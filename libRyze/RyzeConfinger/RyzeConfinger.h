//
//  RyzeConfinger.h
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RyzeConfinger : NSObject
// default YES
@property(nonatomic,assign,readonly)BOOL enableGizp;
// default 50
@property(nonatomic,assign,readonly)NSInteger max;
+ (instancetype)defaultConfinger;
// 是否启用gzip压缩
- (void)enableGizp:(BOOL)enable;
// 设置单次上传条数
- (void)setMaxToUpLoad:(NSInteger)max;
@end
