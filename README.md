#LibRyze

### 依赖库
<pre>
   pod 'Aspects'
   pod 'MJExtension', '~> 3.0.13'
   pod 'LKDBHelper'
   pod 'AFNetworking'
</pre>

### 示例

##### 1.配置

Appdelegate.m

<pre>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [RyzeAspectManager ryze_createFuntionHook];
    [RyzeAspectManager ryze_enableGzip:YES];
    [RyzeAspectManager ryze_setMaxUpload:10];
    [RyzeAspectManager ryze_configUploader:[RyzeUploader new]];
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    return YES;
}

void UncaughtExceptionHandler(NSException *exception){
    //  Crash
    [RyzeAspectManager ryze_saveAllUnUploadInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 5s
    [RyzeAspectManager ryze_saveAllUnUploadInfo];
}
</pre>

2.埋点

<pre>
    [RyzeMagicStatics ryze_addEventName:@"tapView" withParams:nil];
</pre>

3.上传配置

<pre>
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
</pre>

appDelegate 中的配置的Uploader 可以自定义实现

实现RyzeUploadProtocol的方法的实例即可。

<pre>
+(void)ryze_configUploader:(id &ltRyzeUploadProtocol&gt)uploader;
</pre>