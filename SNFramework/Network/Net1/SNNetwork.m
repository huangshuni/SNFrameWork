//
//  SNNetwork.m
//  SNFramework
//
//  Created by huangshuni on 16/9/1.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "SNNetwork.h"
#import "NSObject+JsonAndDic.h"
#import "NSString+Tool.h"
#import "SNNetCache.h"

//error domain
#define kYHNetworkConnection @"SNNetwork.Connection"
//网络连接错误
#define kNetworkConnectionError [NSError errorWithDomain:kYHNetworkConnection code:NSURLErrorNotConnectedToInternet userInfo:@{NSLocalizedDescriptionKey:@"网络连接已断开，请检查网络"}]

//超时时间
static NSTimeInterval networkTimeout = 30.f;

#pragma mark - CacheObj
@implementation CacheObj

@end


#pragma mark - SNNetwork
@interface SNNetwork()

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic,assign) BOOL useCache;

@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,copy) requestSuccessBlock success;
@property (nonatomic,copy) requestFailureBlock failure;

@end

@implementation SNNetwork

- (instancetype)init
{
    self = [super init];
    if (self) {
        /**  请求格式
         *  AFHTTPRequestSerializer            二进制格式
         *  AFJSONRequestSerializer            JSON
         *  AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
         */
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        [self setValue:@"application/json" forHttpHeader:@"Content-Type"];
//        [self setResponseAcceptableContentType:@"text/html"];
        
        /** 返回格式
         *   AFHTTPResponseSerializer           二进制格式
         *   AFJSONResponseSerializer           JSON
         *   AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
         *   AFXMLDocumentResponseSerializer (Mac OS X)
         *   AFPropertyListResponseSerializer   PList
         *   AFImageResponseSerializer          Image
         *   AFCompoundResponseSerializer       组合
         */
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

#pragma mark - 请求
/**
 *  GET 请求
 *
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return 可以用来取消任务
 */
-(NSURLSessionDataTask *)GET:(NSString *)URLString
                  parameters:(id)parameters
                     success:(requestSuccessBlock)success
                     failure:(requestFailureBlock)failure
{
    self.url = URLString;
    self.success = success;
    self.failure = failure;
    self.dic = parameters;
    //请求超时时间
    [self setRequestTimeoutSeconds:networkTimeout];
    //公用参数
    //生成该请求的唯一标识，由url和参数MD5加密后生成
    NSString *singleID = [self singleID];
    //缓存
    if (self.useCache) {
        //若使用缓存
        CacheObj *obj = [self validateCacheForsigleID:singleID];
        if (obj && success) {
            //缓存存在
            success(obj.responseJsonStr);
            return nil;
        }
    }
    
    //发送请求
//    NSString *beginTime = [self getCurrentTimeStamp];
    
    __weak typeof(self) weakSelf = self;
    
    return [self.sessionManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //缓存请求成功的内容
//        [weakSelf cacheHttpRequestBeginTime:beginTime responseObj:responseObject requestEndTime:[self getCurrentTimeStamp] sigleID:singleID];
        NSLog(@"responseObject:%@",responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf netWorkFailureHandle:error];
    }];
}


/**
 *  POST 请求
 *
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return 可以用来取消任务
 */
-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(id)parameters
                      success:(requestSuccessBlock)success
                      failure:(requestFailureBlock)failure
{
    self.url = URLString;
    self.dic = parameters;
    self.success = success;
    self.failure = failure;
    //请求超时时间
    [self setRequestTimeoutSeconds:networkTimeout];
    //公用参数
    //生成该请求的唯一标识，由url和参数经MD5加密后生成
     NSString *singleID = [self singleID];
    //缓存
    if (self.useCache) {
        //若使用缓存
        CacheObj *obj = [self validateCacheForsigleID:singleID];
        if (obj && success) {
            self.success(obj.responseJsonStr);
            return nil;
        }
    }
    //发送请求
//    NSString *beginTime = [self getCurrentTimeStamp];
    __weak typeof (self) weakSelf = self;
    NSLog(@"http -> url:%@ \nparameters:\n%@ \n",URLString,parameters);
    
    NSURLSessionDataTask *task = [self.sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        NSLog(@"%@",data);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf netWorkFailureHandle:error];
    }];
    
    NSLog(@"%@?%@",@"http://www.lvkeworld.com/ashx/App.ashx",[[NSString alloc]initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    return task;
    
}

//校检是否使用缓存
-(CacheObj *)validateCacheForsigleID:(NSString *)singleID
{
    SNNetCache *cache = [SNNetCache shareCache];
    if ([cache containsObjectForKey:singleID]) {
        NSString *json = [cache objectForKey:singleID];
        NSDictionary *dic = [cache jsonToDic:json];
        CacheObj *obj = [[CacheObj alloc]init];
        obj.url = dic[@"url"];
        obj.requestTime = dic[@"requestTime"];
        obj.parameter = dic[@"parameter"];
        obj.responseJsonStr = dic[@"responseJsonStr"];
        obj.reponseTime = dic[@"reponseTime"];
        return obj;
    }
    return nil;
}

//获取当前的时间戳
-(NSString *)getCurrentTimeStamp
{
    return [NSString stringWithFormat:@"%ld",(long)([[NSDate date] timeIntervalSince1970] * 1000 )];
}

//网络请求失败的回调
-(void)netWorkFailureHandle:(NSError *)error
{
    if (self.failure) {
        //错误回调存在
        if (error.code == NSURLErrorNotConnectedToInternet) {
            self.failure(kNetworkConnectionError);
        }else{
            self.failure(error);
        }
    }
}

//设置请求头内容
- (void)setValue:(NSString *)value forHttpHeader:(NSString *)header {
    
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:header];
}

//设置返回内容的接收类型
-(void)setResponseAcceptableContentType:(NSString *)type
{
    [self.sessionManager.responseSerializer setAcceptableContentTypes:[[self.sessionManager.responseSerializer acceptableContentTypes]setByAddingObject:type]];
}

//获取所有可接受内容类型
- (NSSet *)getAllresponseAcceptableContentType {
    
    return [self.sessionManager.responseSerializer acceptableContentTypes];
}

//设置请求的超时时间
-(void)setRequestTimeoutSeconds:(NSTimeInterval)seconds
{
    self.sessionManager.requestSerializer.timeoutInterval = seconds;
}

//根据url和参数生成唯一标示，作为缓存的唯一标示
-(NSString *)singleID
{
    NSString *parameterJsonStr = [self.dic toJsonString];
    NSString *str = [NSString stringWithFormat:@"%@%@",self.url,parameterJsonStr];
    return [str md5];
}

//缓存内容
- (void)cacheHttpRequestBeginTime:(NSString *)beginTime responseObj:(NSString *)responseObj requestEndTime:(NSString *)endTime sigleID:(NSString *)sigleID {

    //异步子线程缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CacheObj *obj = [[CacheObj alloc]init];
        obj.url = self.url;
        obj.requestTime = beginTime;
        obj.parameter = self.dic;
        obj.reponseTime = endTime;
        obj.responseJsonStr = responseObj;
        NSString *jsonStr = [[obj toDic] toJsonString];
       [[SNNetCache shareCache] setObject:jsonStr forKey:sigleID];
    });
}

//设置是否使用缓存
- (void)isUseCache:(BOOL)flag
{
    self.useCache = flag;
}

//清除缓存
- (void)clearCache
{
    [[SNNetCache shareCache] removeObjectforKey:[self singleID]];
}


#pragma mark - setter / getter
-(AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
    }
    return _sessionManager;
}

@end
