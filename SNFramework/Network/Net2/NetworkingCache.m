//
//  NetworkingCache.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NetworkingCache.h"
#import "NetworkingCacheObjdect.h"
#import "NSDictionary+Networking.h"
#import "NetworkingConfiguration.h"

@interface NetworkingCache ()<NSCacheDelegate>
@property(nonatomic,strong)NSCache *cache;
@end

@implementation NetworkingCache

#pragma mark - life cycle
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static NetworkingCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance =[[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - define
-(NSData*)fetchCacheDataWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams
{
 return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

-(id)fetchCachedDataWithKey:(NSString*)key{
    
    NetworkingCacheObjdect *cancheObjdect =[self.cache objectForKey:key];
    //如果过期或者为空
    if (cancheObjdect.isOutdated || cancheObjdect.isEmpty) {
        return nil ;
    }else{
        return cancheObjdect.content;
    }
}
-(NSString*)keyWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams{
    return [NSString stringWithFormat:@"%@%@%@",serviceIdentifier,methodName,[requestParams NetworkingUrlParamsStringSignature:NO]];
}



- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key
{
    NetworkingCacheObjdect *cachedObject = [self.cache objectForKey:key];
    if (cachedObject ==nil) {
        cachedObject =[[NetworkingCacheObjdect alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

-(void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

-(void)clean
{
    [self.cache removeAllObjects];
}

#pragma mark - setter / getter
-(NSCache*)cache{
    
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        //能够缓存对象的最大数量 默认值是 0，表示没有限制
        _cache.countLimit = NetworkingCacheCountLimit;
        //标示缓存是否回收废弃的内容 默认值是 YES，表示自动回收
        _cache.evictsObjectsWithDiscardedContent=YES;
        _cache.delegate=self;
        
    }
    return _cache;
}


@end
