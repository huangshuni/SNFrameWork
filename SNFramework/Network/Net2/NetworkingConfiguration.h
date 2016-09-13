//
//  NetworkingConfiguration.h
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#ifndef NetworkingConfiguration_h
#define NetworkingConfiguration_h

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const NetAPIBaseManagerRequestID = @"NetAPIBaseManagerRequestID";


typedef  NS_ENUM(NSUInteger,NetworkingURLResponseStatus){
    
    NetworkingURLResponseStatusSuccess,//请求成功
    NetworkingURLResponseStatusErrorTimeout,//网络超时
    NetworkingURLResponseStatusNoNetwork,//在这里除了超时以外的错误都是无网络错误
    
};

static  BOOL const NetworkingCacheRequirement = YES;//是否需要缓存
static  NSUInteger const NetworkingCacheCountLimit =20;//缓存的大小
static  NSTimeInterval  NetworkingTimeoutSeconds = 15.0f;//网络超时
static NSString *const NetworkingServiceIdentifier=@"serviceIdentifier";
static  NSUInteger const NetworkingOutdateTimeSeconds = 300;//5分钟的cache过期时间



#endif /* NetworkingConfiguration_h */
