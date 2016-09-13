//
//  SNReformer.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "SNReformer.h"
#import "SNManager.h"

@interface SNReformer ()
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation SNReformer

-(id)manager:(NetworkingBaseManager *)manager reformData:(NSDictionary *)data{
    [self.dataArr removeAllObjects];
    if ([manager isKindOfClass:[SNManager class]]) {
        return self.dataArr;
    }
    return nil;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
