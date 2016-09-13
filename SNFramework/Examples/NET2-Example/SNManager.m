//
//  SNManager.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "SNManager.h"

@implementation SNManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator=self;
        self.subclass=self;
    }
    return self;
}
#pragma mark-用来做缓存的标示符
-(NSString*)methodName{
    
    return @"home.com";
}

#pragma mark--需要对输入的参数做处理
-(BOOL)NetworkingManager:(NetworkingBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    
    return NO;
}
#pragma mark-需要对返回的数据处理
-(BOOL)NetworkingManager:(NetworkingBaseManager *)manager isCorrecWithCallBackData:(NSDictionary *)data{
    
    return YES;
    
}
#pragma mark-是否需要缓存
-(BOOL)shouldCache{
    return YES;
}

@end
