//
//  RyzeMagicStatics.m
//  libRyze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "RyzeMagicStatics.h"

@implementation RyzeMagicStatics
+(void)ryze_addEventName:(NSString *)evetString withParams:(NSDictionary*)params {
    [[RyzeMagicStatics alloc] ryze_actEvent:evetString Params:params];
}
-(void)ryze_actEvent:(NSString *)eventName Params:(NSDictionary *)params {}
@end
