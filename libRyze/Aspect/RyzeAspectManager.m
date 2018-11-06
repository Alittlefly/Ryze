//
//  RyzeAspectManager.m
//  libRyze
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "RyzeAspectManager.h"
#import "RyzeMagicStatics.h"
#import "RyzeCacheManager.h"
#import "RyzeConfinger.h"
#import <Aspects/Aspects.h>

@implementation RyzeAspectManager

+ (void)ryze_trackEventWithClass:(Class)klass selector:(SEL)selector event:(NSString *)event {
    SEL mSelector =selector;
    [klass aspect_hookSelector:mSelector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [RyzeAspectManager dealHookedEvent:event aspectInfos:aspectInfo];
    } error:NULL];
}

+(void)ryze_createFuntionHook {
    
    [RyzeCacheManager setDBName:@"Ryze_Track.db"];
    
    [self ryze_trackEventWithClass:[RyzeMagicStatics class] selector:@selector(ryze_actEvent:Params:) event:@""];
}

+(void)ryze_configUploader:(id<RyzeUploadProtocol>)uploader {
    [[RyzeCacheManager sharedRyzeCache] setUploader:uploader];
}

+(void)ryze_setMaxUpload:(NSInteger)max{
    [[RyzeConfinger defaultConfinger] setMaxToUpLoad:max];;
}

+(void)ryze_enableGzip:(BOOL)enable {
    [[RyzeConfinger defaultConfinger] enableGizp:enable];;
}
// save
+(void)ryze_saveAllUnUploadInfo {
    [[RyzeCacheManager sharedRyzeCache] saveAllActions];
}

// crash & Terminate
+(void)ryze_UploadAllInfo {
    //
    [[RyzeCacheManager sharedRyzeCache] uploadAllActionInfo];
}

+(void)dealHookedEvent:(NSString *)event aspectInfos:(id<AspectInfo>)aspectInfo
{
    //
    /*
     {
     "user_id": 0
     "app_version": "2.3.2”,
     "country": "iq",
     "dev": "SM-G800H",
     "imei": "355320060143891",
     "os_name": "android",
     "os_version": "4.4.2",
     
     "promotion_id": channel,
     "time":"long "
     "action_type": 4,//事件ID
     }
     */
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    long long time = [[NSDate date] timeIntervalSince1970];
    [dict setValue:[NSString stringWithFormat:@"%lld",time] forKey:@"time"];
    NSString *action_type = event;
    
    NSArray *args = [aspectInfo arguments];
    if ([args count] != 0) {
        action_type = [action_type stringByAppendingString:[RyzeAspectManager appendedString:aspectInfo]];
    }
    
    if(action_type != nil){
        [dict setValue:action_type forKey:@"type"];
    }
    
    [dict setValue:@"iOS_Null" forKey:@"content"];
    
    for (id contentParam in args) {
        if ([contentParam isKindOfClass:[NSDictionary class]]) {
            NSString *content = [contentParam valueForKey:@"content"];
            [dict setValue:content forKey:@"content"];
        }
    }
    
    // 存储
    [[RyzeCacheManager sharedRyzeCache] saveActionInfo:dict];
}

+(NSString *)appendedString:(id<AspectInfo>)aspectInfo
{
    NSString *returnString = @"";
    NSArray *args = [aspectInfo arguments];
    id curObject = [aspectInfo instance];
    for (id object in args) {
        if ([object isKindOfClass:[NSString class]]) {
            returnString = [returnString stringByAppendingString:(NSString *)object];
        }else if([object isKindOfClass:[NSDictionary class]]){
            
        }
    }
    return returnString;
}
@end
