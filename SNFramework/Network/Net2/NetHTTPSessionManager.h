//
//  NetHTTPSesstionManager.h
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkingURLResponse.h"

typedef void (^NetworkingURLResponseCallBack)(NetworkingURLResponse *response);

@interface NetHTTPSessionManager : NSObject

@property (nonatomic, readonly) BOOL isReachable;
+(instancetype)sharedManager;


/*
 * GET请求
 * 参数可以方在url中,也可以放在params中
 */
- (NSInteger)callGETWithUrl:(NSString *)url params:(id)params success:(NetworkingURLResponseCallBack)success failure:(NetworkingURLResponseCallBack)failure;


/*
 * POST请求
 */

- (NSInteger)callPOSTWithUrl:(NSString *)url params:(id)params success:(NetworkingURLResponseCallBack)success failure:(NetworkingURLResponseCallBack)failure;


/*
 * 单独取消请求
 */

- (void)cancelRequestWithRequestId:(NSNumber *)requestID;

/*
 * 根据数组取消请求
 */

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;



@end
