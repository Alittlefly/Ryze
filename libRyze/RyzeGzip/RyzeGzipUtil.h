//
//  RyzeGzipUtil.h
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RyzeGzipUtil : NSObject
+ (NSData*) ryze_gzipData:(NSData*)pUncompressedData;
@end
