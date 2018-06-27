//
//  RyzeCacheManager.m
//  libRyze
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 Fission. All rights reserved.
//

#import "RyzeCacheManager.h"
#import "RyzeActionInfo.h"
#import <objc/objc.h>
#import "RyzeConfinger.h"
#import "RyzeGzipUtil.h"

#import <MJExtension/MJExtension.h>
#import <LKDBHelper/LKDBHelper.h>

@interface RyzeActionInfoCounter : NSObject

@property(nonatomic,assign)NSInteger count;
@end
@implementation RyzeActionInfoCounter

@end


@interface RyzeCacheManager()
{
    dispatch_queue_t _cacheInfoQueue;
    NSInteger _currentItemsCount;
    BOOL _haveNextUpload;
    __block BOOL _inUpload;
}
@property(nonatomic,strong)NSMutableArray *cacheInfos;
@property(nonatomic,strong)RyzeActionInfoCounter *counter;
@end
@implementation RyzeCacheManager
static RyzeCacheManager *sharedCacheManager;
- (NSMutableArray *)cacheInfos {
    if (!_cacheInfos) {
        _cacheInfos = [NSMutableArray array];
    }
    return _cacheInfos;
}
+ (instancetype)sharedRyzeCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedCacheManager == nil) {
            sharedCacheManager = [[RyzeCacheManager alloc] init];
        }
    });
    
    return sharedCacheManager;
}
- (instancetype)init {
    if (self = [super init]) {
        _cacheInfoQueue = dispatch_queue_create("com.Ryze.CacheInfo", 0);
        self.counter = [[RyzeActionInfoCounter alloc] init];
        [self.counter addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        dispatch_async(_cacheInfoQueue, ^{
            NSArray *allSavedInfo = [RyzeActionInfo searchWithWhere:nil];
            [self.cacheInfos addObjectsFromArray:allSavedInfo];
            self.counter.count = [self.cacheInfos count];
        });
    }
    return self;
}

+ (void)setDBName:(NSString *)name {
    
//    [RyzeDBHelper ryze_setDataBaseName:name];
//    [RyzeDBHelper ryze_createTableName:NSStringFromClass([RyzeActionInfo class])];
//    LKDBHelper * dbHelper = [LKDBHelper getUsingLKDBHelper];
//    [dbHelper createTableWithModelClass:<#(nonnull Class)#>]
}

- (void)saveActionInfo:(NSDictionary *)info {
    
    dispatch_async(_cacheInfoQueue, ^{
        RyzeActionInfo *actionInfo = [RyzeActionInfo mj_objectWithKeyValues:info];
        [actionInfo saveToDB];
        [self.cacheInfos addObject:actionInfo];
         self.counter.count = [self.cacheInfos count];
    });
}
- (void)saveAllActions {
//    dispatch_async(_cacheInfoQueue, ^{
    
    // 数据库不会重复存储同一对象
        [RyzeActionInfo insertToDBWithArray:self.cacheInfos filter:nil];
//        NSLog(@"insertToDBWithArray");
//    });
}
- (void)setUploader:(id<RyzeUploadProtocol>)uploader {
    _uploader = uploader;
}
- (void)setUploaderClass:(Class<RyzeUploadProtocol>)className {
    Class uploadClass = (Class)className;
    self.uploader = [[uploadClass alloc] init];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"count"]) {
        NSNumber *newValue = [change valueForKey:NSKeyValueChangeNewKey];
        NSInteger max = [RyzeConfinger defaultConfinger].max;
        NSLog(@"newValue %@",newValue);

        if (newValue.integerValue >= max) {
            
            if (_inUpload) {
                _haveNextUpload = YES;
                NSLog(@"正在上传 请等待上传");
                return;
            }
            
            _inUpload = YES;
            
            if (!self.uploader) {
                // 未配置上传工具
                return;
            }
            
            __block NSInteger count = [RyzeActionInfo rowCountWithWhere:nil];
            NSLog(@"上传开始 ========================= start");
            NSLog(@"delete 前 还剩: %ld",count);
            // 移除
            NSArray *subArray = [self.cacheInfos subarrayWithRange:NSMakeRange(0, max)];
            
            NSMutableArray *uploadInfos = [NSMutableArray array];
            for (RyzeActionInfo *action in subArray) {
                NSDictionary *dict = [action mj_keyValues];
                [uploadInfos addObject:dict];
            }
            NSData *data = [uploadInfos mj_JSONData];
            
            BOOL needGzip = [RyzeConfinger defaultConfinger].enableGizp;
            
            if (needGzip) {
                data = [RyzeGzipUtil ryze_gzipData:data];
            }

            [self.uploader ryze_uploadData:data enableGizp:needGzip successBlock:^{
                dispatch_async(self->_cacheInfoQueue, ^{
                    // 删除数据
                    NSString *sqlLimit = [NSString stringWithFormat:@"delete from RyzeActionInfo where rowid in (select rowid from RyzeActionInfo limit 0,%ld)",max];
                    // 删除
                    [RyzeActionInfo searchWithSQL:sqlLimit];
                    [self.cacheInfos removeObjectsInArray:subArray];
                    
                    count = [RyzeActionInfo rowCountWithWhere:nil];
                    NSLog(@"delete 后 还剩: %ld",count);
                    NSLog(@"上传完成 ========================= end");

                    self -> _inUpload = NO;
                    
                    if (self->_haveNextUpload) {
                        // 触发下次
                        // 超过了max 重新触发
                        self.counter.count = [self.cacheInfos count];
                    }
                });
            } faildBlock:^{
                dispatch_async(self->_cacheInfoQueue, ^{
                    self -> _inUpload = NO;
                });
            }];
        }else{
            _haveNextUpload = NO;
        }
    }
}
@end
