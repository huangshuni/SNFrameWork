//
//  NET2Controller.m
//  SNFramework
//
//  Created by huangshuni on 16/9/12.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "NET2Controller.h"
#import "SNManager.h"

@interface NET2Controller ()<NetworkingManagerParamSourceDelegate,NetworkingRequestBackResponseDelegate,NetworkingRequestBackDataDelegate>

@property (nonatomic,strong) SNManager *snManager;

@end

@implementation NET2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.snManager loadData];
}


#pragma mark - datas delegate
#pragma mark-返回参数-NetworkingManagerParamSourceDelegate
-(NSDictionary*)NetworkingParamsForAPI:(NetworkingBaseManager *)manager{
    if ([manager isKindOfClass:[SNManager class]]) {
        
        return @{@"apikey":@"b6a26fb81b2429e1",@"action":@"getHomeDatas",@"City":@"深圳"};
    }
    return nil;
}
#pragma mark-验证参数成功
-(void)NetworkingManagerBackCorrectParamsResult:(NetworkingBaseManager *)manager{
        if ([manager isKindOfClass:[SNManager class]]) {
            
        }
}

#pragma mark-成功返回的数据-NetworkingRequestBackDateDelegate
-(void)NetworkingManagerRequestSuccessBackData:(NetworkingBaseManager *)manager{
    if ([manager isKindOfClass:[SNManager class]]) {
        
//      self.datasArr = [self.mainpageManage fetchDataWithReformer:self.mainPageRefrom];
//        self.mainPageHeadView.datasArr = self.datasArr;
    }
    
}
#pragma maerk-失败返回的数据
-(void)NetworkingManagerRequestFailedBackData:(NetworkingBaseManager *)manager{
    
    if (manager.errorType==NetworkingAPIManagerErrorTypeParamsError) {
        
    }
}

#pragma mark-成功返回的数据-NetworkingRequestBackResponseDelegate
-(void)NetworkingManager:(NetworkingBaseManager *)manager RequestSuccessBackResponse:(NetworkingURLResponse *)response{
    if ([manager isKindOfClass:[SNManager class]]) {
        NSLog(@"%@",response.content);
    }
}

#pragma mark-失败返回的数据-NetworkingRequestBackResponseDelegate
-(void)NetworkingManager:(NetworkingBaseManager *)manager RequestFailedBackResponese:(NetworkingURLResponse *)response{
    
}


#pragma mark - setter / getter
-(SNManager *)snManager
{
    if (!_snManager) {
        _snManager = [[SNManager alloc]init];
        _snManager.Intercetor = self;
        _snManager.dataDelegate = self;
        _snManager.paramSource = self;
    }
    return _snManager;
}

@end
