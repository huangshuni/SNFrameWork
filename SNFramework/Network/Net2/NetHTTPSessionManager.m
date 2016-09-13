//
//  NetHTTPSesstionManager.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NetHTTPSessionManager.h"

@interface NetHTTPSessionManager ()

@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong)NSMutableDictionary *dispatchTable;
@property (nonatomic, strong)NSNumber *recordedRequestId;

@end

@implementation NetHTTPSessionManager
+(instancetype)sharedManager
{
    static NetHTTPSessionManager *session=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        session =[[NetHTTPSessionManager alloc] init];
        //开始监控网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return session;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager=[AFHTTPSessionManager manager];
        _sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval =NetworkingTimeoutSeconds;
        
    }
    return self;
}

-(NSInteger)callGETWithUrl:(NSString *)url params:(id)params success:(NetworkingURLResponseCallBack)success failure:(NetworkingURLResponseCallBack)failure{
    NSNumber *requesID=[self generateRequestId];
    
    /*
     * 到这个block的时候已经是主线程了
     */
    NSURLSessionDataTask *task=[_sessionManager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSURLSessionDataTask *storedTask = [self.dispatchTable objectForKey:requesID];
        if (storedTask == nil) {
            //如果这个task是被cancel，就不处理回调；
            return;
        }
        NetworkingURLResponse *response=[[NetworkingURLResponse alloc] initWithSessionDataTask:task NetRequestId:requesID NetRequestParams:params NetResponseData:responseObject NetStatus:NetworkingURLResponseStatusSuccess];
        success?success(response):nil;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSURLSessionDataTask *storedTask = [self.dispatchTable objectForKey:requesID];
        if (storedTask == nil) {
            //如果这个task是被cancel，就不处理回调；
            return;
        }
        NetworkingURLResponse *response=[[NetworkingURLResponse alloc] initWithSessionDataTask:task NetRequestId:requesID NetRequestParams:params NetResponseData:nil NetStatus:NetworkingURLResponseStatusSuccess];
        
        failure?failure(response):nil;
        
    }];
    [self.dispatchTable setObject:task forKey:requesID];
    return [requesID integerValue];
    
}

-(NSInteger)callPOSTWithUrl:(NSString *)url params:(id)params success:(NetworkingURLResponseCallBack)success failure:(NetworkingURLResponseCallBack)failure{
    NSNumber *requestID = [self generateRequestId];
    
    NSURLSessionDataTask *task=[_sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSURLSessionDataTask *storedTask = [self.dispatchTable objectForKey:requestID];
        if (storedTask == nil) {
            //如果这个task是被cancel，就不处理回调；
            return;
        }
        NetworkingURLResponse *response=[[NetworkingURLResponse alloc] initWithSessionDataTask:task NetRequestId:requestID NetRequestParams:params NetResponseData:responseObject NetStatus:NetworkingURLResponseStatusSuccess];
        
        
        success?success(response):nil;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSURLSessionDataTask *storedTask = [self.dispatchTable objectForKey:requestID];
        if (storedTask == nil) {
            //如果这个task是被cancel，就不处理回调；
            return;
        }
        NetworkingURLResponse *response=[[NetworkingURLResponse alloc] initWithSessionDataTask:task requestId:requestID requestParams:params responseData:nil error:error];
        
        failure?failure(response):nil;
        
    }];
    NSLog(@"%@?%@",LKB_URL,[[NSString alloc]initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
//    debugMethod();
    
    [self.dispatchTable setObject:task forKey:requestID];
    
    return [requestID integerValue];
    
}


/*
 * 单独取消请求
 */
- (void)cancelRequestWithRequestId:(NSNumber *)requestID
{
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestID];
    
    if (task) {
        [task cancel];
    }
    
    [self.dispatchTable removeObjectForKey:requestID];
}
/*
 * 根据数组取消请求
 */

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    
    NSInteger count = [requestIDList count];
    
    for (int i = 0; i < count; i++) {
        [self cancelRequestWithRequestId:requestIDList[i]];
    }
}


// 之所以不用getter，是因为如果放到getter里面的话，每次调用self.recordedRequestId的时候，需要其值发生改变，违背了getter的初衷
-(NSNumber*)generateRequestId{
    
    if (_recordedRequestId==nil) {
        _recordedRequestId = @(1);
    }else{
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

-(BOOL)isReachable{
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    if(manger.networkReachabilityStatus==AFNetworkReachabilityStatusNotReachable){
        return NO;
    }else{
        return YES;
    }
}

@end
