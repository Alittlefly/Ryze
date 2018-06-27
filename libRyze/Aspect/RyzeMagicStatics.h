//
//  RyzeMagicStatics.h
//  libRyze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RyzeMagicStatics : NSObject

+(void)ryze_addEventName:(NSString *)evetString withParams:(NSDictionary*)params;

-(void)ryze_actEvent:(NSString *)eventName Params:(NSDictionary *)params;

@end
