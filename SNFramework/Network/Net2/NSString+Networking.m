//
//  NSString+Networking.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NSString+Networking.h"

@implementation NSString (Networking)
/*
 *json字符串转NSDictionary
 */
-(NSDictionary*)NetworkingjsonDictionary{
    if (self == nil) {
        return nil;
    }else{
        NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            return nil;
        }else{
            return dic;
        }
    }
}

@end
