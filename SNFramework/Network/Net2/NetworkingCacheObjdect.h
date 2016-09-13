//
//  NetworkingCacheObjdect.h
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingCacheObjdect : NSObject
@property(nonatomic,copy,readonly)NSData *content;
@property(nonatomic,copy,readonly)NSDate *lastUpdateTime;
@property(nonatomic,assign,readonly)BOOL isOutdated;//判断缓存的时间是否过时
@property(nonatomic,assign,readonly)BOOL isEmpty;

-(instancetype)initWithContent:(NSData*)content;
-(void)updateContent:(NSData*)content;

@end
