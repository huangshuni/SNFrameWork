//
//  NSDictionary+Networking.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NSDictionary+Networking.h"
#import "NSArray+Networking.h"

@implementation NSDictionary (Networking)
-(NSString*)NetworkingUrlParamsStringSignature:(BOOL)isForSignature{
    
    NSArray *sorteArry=[self NetworkingTransformedUrlParamsArraySignature:isForSignature];
    return [sorteArry NetworkingParamString];
}
-(NSArray*)NetworkingTransformedUrlParamsArraySignature:(BOOL)isFroSignature{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  key, id obj, BOOL *  stop) {
        
        if(![obj isKindOfClass:[NSString class]]){
            obj = [NSString stringWithFormat:@"%@",obj];
        }
        if (isFroSignature) {
            //对特殊字符转义
            obj = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)obj, NULL, (CFStringRef)@"!*'();:@&;=+$,/?%#[]", kCFStringEncodingUTF8));
        }
        if ([obj length]>0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

@end
