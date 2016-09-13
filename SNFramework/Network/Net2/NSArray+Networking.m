//
//  NSArray+Networking.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NSArray+Networking.h"

@implementation NSArray (Networking)
-(NSString*)NetworkingParamString{
    NSMutableString *paramString = [[NSMutableString alloc] init];
    NSArray *sortedParams = [self sortedArrayUsingSelector:@selector(compare:)];
    [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        if ([paramString length]==0) {
            [paramString appendFormat:@"%@",obj];
        }else{
            [paramString appendFormat:@"&%@",obj];
        }
    }];
    return paramString;
}
@end
