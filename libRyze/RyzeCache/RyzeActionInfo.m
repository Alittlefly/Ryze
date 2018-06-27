//
//  RyzeActionInfo.m
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "RyzeActionInfo.h"

@implementation RyzeActionInfo
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.content forKey:@"content"];
}
@end
