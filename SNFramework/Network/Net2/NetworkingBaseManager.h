//
//  NetworkingBaseManager.h
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingURLResponse.h"

@class NetworkingBaseManager;

typedef NS_ENUM(NSInteger,NetwokingAPIManagerErrorType) {
    
    NetworkingAPIManagerErrorTypeDefault,//没有产生过API请求，这个是manager的默认状态
    NetworkingAPIManagerErrorTypeSuccess,//API请求成功且返回数据正确，此时manager的数据是可以直接那拿来使用的
    NetworkingAPIManagerErrorTypeNoContent,//API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    NetworkingAPIManagerErrorTypeParamsError,//参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    NetworkingAPIManagerErrorTypeTimeout, //请求超时。JFHTTPSessionManager设置的是20秒超时，具体超时时间的设置请自己去看HTTPSessionManager的相关代码。
    NetworkingAPIManagerErrorTypeNoNetWork,//网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    
};

typedef NS_ENUM(NSInteger,NetworkingAPIManagerRequestType) {
    NetworkingMangerRequesetTypePost,//Post请求
    NetworkingMangerRequesetTypeGet,//Get请求
};

#pragma mark - NetworkingManagerParamSourceDelegate ---
//该代理方法是放在ViewController里面实现，来获取API的参数
@protocol NetworkingManagerParamSourceDelegate <NSObject>
@optional
-(void)NetworkingManagerBackCorrectParamsResult:(NetworkingBaseManager*)manager;

@required//这个属性表示该代理方法必须要实现,设置请求的参数
-(NSDictionary*)NetworkingParamsForAPI:(NetworkingBaseManager*)manager;
@end


#pragma mark - NetworkingRequestManager --
@protocol NetworkingRequestManager <NSObject>
@required
//用来做缓存的标示符，即每个API数据缓存的时候都应该有自己的标示符
-(NSString*)methodName;
@optional
-(void)cleanData;
-(NSDictionary*)reformParams:(NSDictionary*)params;
//是否需要缓存
-(BOOL)shouldCache;
@end



#pragma mark - NetworkingRequestValidator --
@protocol NetworkingRequestValidator <NSObject>
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 */
-(BOOL)NetworkingManager:(NetworkingBaseManager*)manager isCorrecWithCallBackData:(NSDictionary*)data;

//当前只能传字典
/*
 
 “
 william补充（2015-11-11）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 ”
 
 所以不要以为这个params验证不重要。当调用API的参数是来自用户输入的时候，验证是很必要的。
 当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
 不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
 
 */
-(BOOL)NetworkingManager:(NetworkingBaseManager*)manager isCorrectWithParamsData:(NSDictionary*)data;

@end



#pragma mark - NetworkingRequestBackResponseDelegate --
/*
 网络请求成功之后返回的二进制数据
 调用API对参数的验证
 */
@protocol NetworkingRequestBackResponseDelegate <NSObject>

@optional
//请求成功后调用的代理
-(void)NetworkingManager:(NetworkingBaseManager*)manager RequestSuccessBackResponse:(NetworkingURLResponse*)response;
//请求失败后调用调理
-(void)NetworkingManager:(NetworkingBaseManager*)manager RequestFailedBackResponese:(NetworkingURLResponse*)response;
/*
 调用API，需要对参数经行的验证
 */
-(BOOL)NetworkingManager:(NetworkingBaseManager*)manage RequestWithParams:(NSDictionary*)params;
@end


#pragma mark - NetworkingRequestBackDataDelegate --
@protocol NetworkingRequestBackDataDelegate <NSObject>
/*
 ** 调用API成功和失败之后使用该代理方法
 */
@required
-(void)NetworkingManagerRequestSuccessBackData:(NetworkingBaseManager*)manager;
-(void)NetworkingManagerRequestFailedBackData:(NetworkingBaseManager*)manager;
@end


#pragma mark - NetAPIManagerInterceptor --
@protocol NetAPIManagerInterceptor <NSObject>
@optional
- (void)manager:(NetworkingBaseManager *)manager beforePerformSuccessWithResponse:(NetworkingURLResponse *)response;
- (void)manager:(NetworkingBaseManager *)manager afterPerformSuccessWithResponse:(NetworkingURLResponse *)response;

- (void)manager:(NetworkingBaseManager *)manager beforePerformFailWithResponse:(NetworkingURLResponse *)response;
- (void)manager:(NetworkingBaseManager *)manager afterPerformFailWithResponse:(NetworkingURLResponse *)response;

- (BOOL)manager:(NetworkingBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(NetworkingBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end

#pragma mark--处理返回的数据
@protocol NetAPIManagerCallbackDataReformer <NSObject>
@required
- (id)manager:(NetworkingBaseManager *)manager reformData:(NSDictionary *)data;
@end


@interface NetworkingBaseManager : NSObject
@property(nonatomic,weak)id<NetworkingManagerParamSourceDelegate>paramSource;//参数
@property(nonatomic,strong)NSString *requestURL;
@property(nonatomic,weak)NSObject<NetworkingRequestManager>*subclass;//缓存相关
@property(nonatomic,weak)id<NetworkingRequestValidator>validator;//验证
@property(nonatomic,weak)id <NetworkingRequestBackResponseDelegate>Intercetor;//成功失败
@property(nonatomic,assign,readonly)NetwokingAPIManagerErrorType errorType;
@property(nonatomic,weak)id<NetworkingRequestBackDataDelegate>dataDelegate;//API成功和失败
@property(nonatomic,assign)BOOL isShowHUD;//用来判断是否需要显示数据请求之后状态的提示框
@property(nonatomic,assign)NetworkingAPIManagerRequestType requestType;
@property(nonatomic,copy)NSString *faileType;//网络请求失败的提示
@property (nonatomic, weak) id<NetAPIManagerInterceptor> interceptor;//拦截

/*
 请求网络数据
 */
-(NSInteger)loadData;
/*
 处理API参数
 */
-(NSDictionary*)reformParams:(NSDictionary*)params;

/*
 是否需要缓存
 */
-(BOOL)shouldCache;


- (id)fetchDataWithReformer:(id<NetAPIManagerCallbackDataReformer>)reformer;

-(void)beforePerformFailWithResponse:(NetworkingURLResponse *)response;
-(void)beforePerformSuccessWithResponse:(NetworkingURLResponse *)response;

- (void)cancelRequestWithRequestId:(NSNumber *)requestID;

- (void)cancelAllRequest;

@end
