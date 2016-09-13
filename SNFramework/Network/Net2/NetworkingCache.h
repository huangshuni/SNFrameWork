//
//  NetworkingCache.h
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingCache : NSObject


+(instancetype)sharedInstance;

-(NSData*)fetchCacheDataWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams;

/**
 *  通过key来获取缓存的数据
 *
 *  @param key 缓存的标识符
 *
 *  @return 缓存的数据
 */
-(NSData*)fetchCachedDataWithKey:(NSString*)key;

/**
 *  生成缓存的标识符
 *
 *  @param serviceIdentifier 缓存标志
 *  @param methodName        请求API的标识符
 *  @param requestParams     参数
 *
 *  @return 生成的缓存标识符
 */
-(NSString*)keyWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams;

//保存数据
- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams;
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key;

/**
 *  根据缓存标识符删除缓存
 *
 *  @param key 缓存标识符
 */
- (void)deleteCacheWithKey:(NSString *)key;
- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams;

- (void)clean;


@end
