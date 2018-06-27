//
//  RyzeActionInfo.h
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RyzeActionInfo : NSObject<NSCoding>
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *type;

@end
