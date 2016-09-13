//
//  NetworkingURLResponse.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NetworkingURLResponse.h"
#import "NSString+Networking.h"

@interface NetworkingURLResponse ()
@property(nonatomic,assign,readwrite)NetworkingURLResponseStatus status;
@property(nonatomic,assign,readwrite)NSInteger requesId;
@property(nonatomic,strong,readwrite)NSURLSessionDataTask *task;
@property(nonatomic,copy,readwrite)id responseData;
@property(nonatomic,copy,readwrite)id content;
@property(nonatomic,assign,readwrite)BOOL isCache;
@end

@implementation NetworkingURLResponse

-(instancetype)initWithData:(id)data
{
    self =[super init];
    if (self) {
        self.task=nil;
        self.status =[self responseStatusWithError:nil];
        self.requesId = 0;
        id resData;
        if ([data isKindOfClass:[NSDictionary class]]) {
            resData =data;
        }else{
            resData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        }
        self.content = [resData[@"value"]NetworkingjsonDictionary];
        self.responseData = resData ? resData:data;
        self.isCache=YES;
    }
    return self;
}

-(instancetype)initWithSessionDataTask:(NSURLSessionDataTask *)task NetRequestId:(NSNumber *)requestId NetRequestParams:(NSDictionary *)requertParams NetResponseData:(id)responseData NetStatus:(NetworkingURLResponseStatus)status{
    self = [super init];
    if (self) {
        
        if (responseData) {
            id data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
            self.content = [data[@"value"] NetworkingjsonDictionary];
            self.responseData = data?data:responseData;
        }else{
            self.content=nil;
            self.responseData=nil;
        }
        self.requesId = [requestId integerValue];
        self.isCache = NO;
        self.requestParams =requertParams;
        self.status = status;
    }
    return self;
}

-(instancetype)initWithSessionDataTask:(NSURLSessionDataTask *)task requestId:(NSNumber *)requestId requestParams:(NSDictionary *)requestParams responseData:(id)responseData error:(NSError *)error
{
    if (self = [super init]) {
        self.task = task;
        self.status = [self responseStatusWithError:error];
        self.requesId = [requestId integerValue];
        self.requestParams = requestParams;
        if (responseData) {
            id data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
            self.content = [data[@"value"]NetworkingjsonDictionary];
            self.responseData = data?data:responseData;
        } else {
            self.content = nil;
            self.responseData = nil;
        }
        self.isCache = NO;
    }
    
    return self;
}


#pragma mark - private methods
- (NetworkingURLResponseStatus)responseStatusWithError:(NSError *)error
{
    
    if (error) {
        NetworkingURLResponseStatus result = NetworkingURLResponseStatusNoNetwork;
        
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = NetworkingURLResponseStatusErrorTimeout;
        }
        return result;
    } else {
        return NetworkingURLResponseStatusSuccess;
    }
}

@end
