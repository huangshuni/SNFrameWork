//
//  NetworkingCacheObjdect.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NetworkingCacheObjdect.h"
#import "NetworkingConfiguration.h"
@interface NetworkingCacheObjdect ()
@property(nonatomic,copy,readwrite)NSData*content;
@property(nonatomic,copy,readwrite)NSDate *lastUpdateTime;
@end

@implementation NetworkingCacheObjdect

-(BOOL)isEmpty{
    
    return self.content ==nil;
    
}
-(void)setContent:(NSData *)content
{
    _content=content;
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}
//缓存时间是否会超时
-(BOOL)isOutdated{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval >NetworkingOutdateTimeSeconds;
}

-(instancetype)initWithContent:(NSData *)content
{
    self = [super init];
    if (self) {
        self.content=content;
    }
    return self;
}

-(void)updateContent:(NSData *)content{
    self.content=content;
}

@end
