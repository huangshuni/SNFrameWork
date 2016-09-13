//
//  NSDictionary+Networking.h
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Networking)
/**
 该方法前面是没有问号的，如果用于POST,那就不用加问号，如果用于GET，就要加个问号
 参数isForSignature用来判断url参数里面的符号要不要转义
 **/
-(NSString*)NetworkingUrlParamsStringSignature:(BOOL)isForSignature;


@end
