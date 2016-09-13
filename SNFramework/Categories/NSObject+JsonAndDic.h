//
//  NSObject+JsonAndDic.h
//  SNFramework
//
//  Created by huangshuni on 16/9/5.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class  NSObject (JsonAndDic)
 *
 * @abstract 将对象转化为字典或json字符串
 *
 */
@interface NSObject (JsonAndDic)

//将字典转化为json
- (NSString *)toJsonString;
//将对象转化为Dic,父类属性未转
- (NSDictionary *)toDic;
//字典转json
- (NSString *)dicToJson:(NSDictionary *)dic;
//json转字典
- (NSDictionary *)jsonToDic:(NSString *)jsonStr;


@end
