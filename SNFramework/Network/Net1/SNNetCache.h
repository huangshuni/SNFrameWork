//
//  SNNetCache.h
//  SNFramework
//
//  Created by huangshuni on 16/9/6.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNNetCache : NSObject

+(instancetype)shareCache;

//是否包含该缓存
- (BOOL)containsObjectForKey:(NSString *)key;
//获取该缓存
- (id)objectForKey:(NSString *)key;
//设置该缓存
- (void)setObject:(id)obj forKey:(NSString *)key;
//移除该缓存
- (void)removeObjectforKey:(NSString *)key;
//移除所有缓存
- (void)removeAllObjects;

@end
