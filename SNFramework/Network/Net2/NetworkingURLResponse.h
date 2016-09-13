//
//  NetworkingURLResponse.h
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingConfiguration.h"
@interface NetworkingURLResponse : NSObject
@property(nonatomic,assign,readonly)NetworkingURLResponseStatus status;
@property(nonatomic,assign,readonly)NSInteger requestId;
@property(nonatomic,copy)NSDictionary *requestParams;//参数
@property(nonatomic,strong,readonly)NSURLSessionDataTask *task;
@property(nonatomic,copy,readonly)id responseData;//返回的数据
@property(nonatomic,copy,readonly)id content;//json解析之后的数据
@property(nonatomic,assign,readonly)BOOL isCache;
@property(nonatomic,copy)NSString *faileType;

-(instancetype)initWithData:(id)data;
//
/*
 * 成功
 */
-(instancetype)initWithSessionDataTask:(NSURLSessionDataTask*)task NetRequestId:(NSNumber*)requestId NetRequestParams:(NSDictionary*)requertParams NetResponseData:(id)responseData NetStatus:(NetworkingURLResponseStatus)status;

/*
 * error
 */
- (instancetype)initWithSessionDataTask:(NSURLSessionDataTask *)task requestId:(NSNumber *)requestId requestParams:(NSDictionary *)requestParams responseData:(id)responseData error:(NSError *)error;


@end
