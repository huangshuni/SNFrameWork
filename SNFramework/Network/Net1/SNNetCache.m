//
//  SNNetCache.m
//  SNFramework
//
//  Created by huangshuni on 16/9/6.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "SNNetCache.h"
#import <YYKit/YYKit.h>

#define cacheName @"SNNetworkCache"

@interface SNNetCache ()

@property (nonatomic,strong) YYCache *cache;

@end

@implementation SNNetCache

static SNNetCache *snCache;

+(instancetype)shareCache{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        snCache = [[self alloc] init];
        snCache.cache = [[YYCache alloc]initWithPath:[snCache cachePath]];
    });
    return snCache;
}

//是否包含该缓存
- (BOOL)containsObjectForKey:(NSString *)key
{
    return [snCache.cache containsObjectForKey:key];
}

//获取该缓存
- (id)objectForKey:(NSString *)key
{
   return [snCache.cache objectForKey:key];
}

//设置该缓存
- (void)setObject:(id)obj forKey:(NSString *)key
{
    [snCache.cache setObject:obj forKey:key];
}

//移除该缓存
- (void)removeObjectforKey:(NSString *)key
{
    [snCache.cache removeObjectForKey:key];
}
//移除所有缓存
- (void)removeAllObjects
{
    [snCache.cache removeAllObjects];
}

#pragma mark - private

- (NSString *)cachePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachePath stringByAppendingPathComponent:@"NetworkCache"];
    BOOL isDir;
    BOOL flag = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDir && !flag)) {
        //文件夹不存在
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:cacheName];
}


@end
