//
//  SNNetwork.h
//  SNFramework
//
//  Created by huangshuni on 16/9/1.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>

//缓存对象
@interface CacheObj : NSObject

@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,copy) NSString *requestTime;
@property (nonatomic,copy) NSString *reponseTime;
@property (nonatomic,copy) NSString *responseJsonStr;

@end

//成功回调
typedef void(^requestSuccessBlock)(id responseObj);
//失败回调
typedef void(^requestFailureBlock)(NSError *error);


@interface SNNetwork : NSObject

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
                     failure:(requestFailureBlock)failure;


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
                     failure:(requestFailureBlock)failure;


//设置是否使用缓存
- (void)isUseCache:(BOOL)flag;
//清除缓存
- (void)clearCache;

@end
