//
//  NetworkingBaseManager.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NetworkingBaseManager.h"
#import "NetHTTPSessionManager.h"
#import "NetworkingCache.h"

@interface NetworkingBaseManager ()

@property(nonatomic,strong)NetworkingCache *cache;

@property (nonatomic, strong)NSMutableArray *requestIdList;
@property(nonatomic,strong,readwrite)id fetchedRawData;//用于保存保存网络请求的数据
@property(nonatomic,assign,readwrite)BOOL isReachable;//网络状态
@property(nonatomic,assign,readwrite)NetwokingAPIManagerErrorType errorType;

//@property(nonatomic,assign,readwrite)NetworkingURLResponseStatus
@end

@implementation NetworkingBaseManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dataDelegate=nil;
        self.validator=nil;
        self.paramSource=nil;
        self.fetchedRawData=nil;
        
        self.errorType=NetworkingAPIManagerErrorTypeDefault;
        self.requestType=NetworkingMangerRequesetTypePost;
        self.subclass=(id <NetworkingRequestManager>)self;
    }
    return self;
}

-(NSInteger)loadData{
    
    id params = [self.paramSource NetworkingParamsForAPI:self];
    NSInteger requestId = [self loadDataWithURL:self.requestURL Params:params];
    return requestId;
}

-(NSInteger)loadDataWithURL:(NSString*)url Params:(NSDictionary*)params{
    
    NSInteger requetId = 0;
    NSDictionary * APIParams = [self reformParams:params];
    /*
     先判断参数验证是否成功，再判断网络状态
     */
    //    if ([self shouldCallAPIWithParms:params]){
    if ([self.validator NetworkingManager:self isCorrectWithParamsData:APIParams]){
        
        if (self.paramSource && [self.paramSource respondsToSelector:@selector(NetworkingManagerBackCorrectParamsResult:)]) {
            [self.paramSource NetworkingManagerBackCorrectParamsResult:self];
        }
        /**
         *  是否需要缓存
         */
        if ([self shouldCache]) {
            //如果已经有缓存的数据，那么从缓存中取数据
            if ([self hasCaheWithParams:APIParams]) {
                return 0;
            }
        }
        if ([self isReachable]) {
            
            switch (self.requestType) {
                case NetworkingMangerRequesetTypeGet:
                    [self CallDataWithType:@"GET" params:params requestId:requetId];
                    break;
                case NetworkingMangerRequesetTypePost:
                    [self CallDataWithType:@"POST" params:params requestId:requetId];
                    break;
                default:
                    break;
            }
            NSMutableDictionary *apiParams = [params mutableCopy];
            [apiParams setObject:@(requetId) forKey:NetAPIBaseManagerRequestID];
            [self afterCallingAPIWithParams:apiParams];
            return requetId;
            
        }else{
            
            [self failedOnCallingAPI:nil withErrorType:NetworkingAPIManagerErrorTypeNoNetWork];
            return requetId;
        }
        
    }else{
        [self failedOnCallingAPI:nil withErrorType:NetworkingAPIManagerErrorTypeParamsError];
        return requetId;
    }
    
    //    }
    return requetId;
}

-(void)CallDataWithType:(NSString*)type params:(id)params requestId:(NSInteger)requestId
{
    if ([type isEqualToString:@"GET"]) {
        [[NetHTTPSessionManager sharedManager] callGETWithUrl:self.requestURL?self.requestURL:LKB_URL params:params success:^(NetworkingURLResponse *response) {
            if (self.dataDelegate) {
                [self successedOnCallingAPI:response];
            }
        } failure:^(NetworkingURLResponse *response) {
            if (self.dataDelegate) {
                [self failedOnCallingAPI:response withErrorType:NetworkingAPIManagerErrorTypeNoNetWork];
            }
        }];
        [self.requestIdList addObject:@(requestId)];
    }else if([type isEqualToString:@"POST"]){
        [[NetHTTPSessionManager sharedManager] callPOSTWithUrl:self.requestURL?self.requestURL:LKB_URL params:params success:^(NetworkingURLResponse *response) {
            if (self.dataDelegate) {
                [self successedOnCallingAPI:response];
            }
        } failure:^(NetworkingURLResponse *response) {
            if (self.dataDelegate) {
                [self failedOnCallingAPI:response withErrorType:NetworkingAPIManagerErrorTypeNoNetWork];\
            }
        }];
        [self.requestIdList addObject:@(requestId)];
    }
   
}

//该函数作用：可以根据你项目的实际情况，来处理API的参数
//如果需要在调用API之前额外添加一些参数，比如pageNuber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
-(NSDictionary*)reformParams:(NSDictionary*)params
{
    IMP childIMP = [self.subclass methodForSelector:@selector(reformParams:)];//通过找该方法的ID,来实现方法
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    if (childIMP==selfIMP) {
        return params;
    }else{
        //如果child是继承得来的，程序就不会运行到这里，会直接运行子类中的IMP
        //如果child是另一个对象，程序就会运行到这里
        NSDictionary *result =nil;
        result = [self.subclass reformParams:params];
        if (result) {
            return result;
        }else{
            return params;
        }
    }
}

-(BOOL)shouldCache{
    
    return NetworkingCacheRequirement;
}

-(BOOL)hasCaheWithParams:(NSDictionary*)params{
    
    //缓存标示符
    NSString * const serviceIdentifier =NetworkingServiceIdentifier;
    NSString *methodName = self.subclass.methodName;
    
    id result =[self.cache fetchCacheDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    if (result ==nil) {
        return NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NetworkingURLResponse *response = [[NetworkingURLResponse alloc] initWithData:result];
        response.requestParams = params;
        
        [self successedOnCallingAPI:response];
    });
    
    
    return YES;
}

-(void)successedOnCallingAPI:(NetworkingURLResponse*)response
{
    
    if (response.content) {
        self.fetchedRawData =[response.content copy];
    }else{
        self.fetchedRawData =[response.responseData copy];
    }
    
    if ([self.validator NetworkingManager:self isCorrecWithCallBackData:response.content]) {
        if([self shouldCache]  && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:NetworkingServiceIdentifier methodName:self.subclass.methodName requestParams:response.requestParams];
            
        }
        [self beforePerformSuccessWithResponse:response];
        
    }else{
        [self failedOnCallingAPI:response withErrorType:NetworkingAPIManagerErrorTypeNoContent];
    }
}
-(void)beforePerformSuccessWithResponse:(NetworkingURLResponse *)response{
    
    self.errorType =NetworkingAPIManagerErrorTypeSuccess;
    if (self !=self.Intercetor && [self.Intercetor respondsToSelector:@selector(NetworkingManager:RequestSuccessBackResponse:)]) {
        [self.Intercetor NetworkingManager:self RequestSuccessBackResponse:response];
    }
    if (self !=self.dataDelegate && [self.dataDelegate respondsToSelector:@selector(NetworkingManagerRequestSuccessBackData:)]) {
        [self.dataDelegate NetworkingManagerRequestSuccessBackData:self];
    }
}
/**
 * 请求失败 代理回调
 */
-(void)failedOnCallingAPI:(NetworkingURLResponse*)response withErrorType:(NetwokingAPIManagerErrorType)errorType{
    
    if (response.status==NetworkingURLResponseStatusErrorTimeout) {
        errorType=NetworkingAPIManagerErrorTypeTimeout;
    }else if (response.status==NetworkingURLResponseStatusNoNetwork){
        errorType=NetworkingAPIManagerErrorTypeNoNetWork;
    }
    if (errorType == NetworkingAPIManagerErrorTypeTimeout) {
        self.errorType = NetworkingAPIManagerErrorTypeTimeout;
        self.faileType=@"网络不给力请稍后再试";
        
    }else{
        self.errorType =errorType;
        switch (errorType) {
            case NetworkingAPIManagerErrorTypeNoNetWork:
                self.faileType=@"网络断开喽";
                break;
            case NetworkingAPIManagerErrorTypeParamsError:
                self.faileType=@"服务器在自拍";
                break;
            case NetworkingAPIManagerErrorTypeNoContent:
                self.faileType=@"服务器在自拍";
                break;
                
            default:
                break;
        }
    }
    
    [self beforePerformFailWithResponse:response];
    
}
-(void)beforePerformFailWithResponse:(NetworkingURLResponse *)response{
    if (self !=self.Intercetor && [self.Intercetor respondsToSelector:@selector(NetworkingManager:RequestFailedBackResponese:)]) {
        
        [self.Intercetor NetworkingManager:self RequestFailedBackResponese:response];
    }
    if (self!=self.dataDelegate && [self.dataDelegate respondsToSelector:@selector(NetworkingManagerRequestFailedBackData:)]) {
        [self.dataDelegate NetworkingManagerRequestFailedBackData:self];
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}


- (id)fetchDataWithReformer:(id<NetAPIManagerCallbackDataReformer>)reformer{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}


/*
 * 单独取消请求
 */
- (void)cancelRequestWithRequestId:(NSNumber *)requestID
{
    if ([self.requestIdList containsObject:requestID]) {
        [self.requestIdList removeObject:requestID];
        [[NetHTTPSessionManager sharedManager]cancelRequestWithRequestId:requestID];
    }
}
/*
 * 取消所有请求
 */
- (void)cancelAllRequest
{
    [[NetHTTPSessionManager sharedManager]cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)dealloc{
    
    [self cancelAllRequest];
    self.requestIdList = nil;
}


/*
 * 网络状态
 */
-(BOOL)isReachable{
    
    BOOL isReachability=[NetHTTPSessionManager sharedManager].isReachable;
    
    if (!isReachability) {
        self.errorType=NetworkingAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

-(NSMutableArray*)requestIdList{
    if (!_requestIdList) {
        _requestIdList=[NSMutableArray array];
    }
    return _requestIdList;
}



@end
