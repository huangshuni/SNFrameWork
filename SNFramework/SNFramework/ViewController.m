//
//  ViewController.m
//  SNFramework
//
//  Created by huangshuni on 16/8/25.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "ViewController.h"
#import "NET2Controller.h"

#import "CommonCrypto/CommonDigest.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn setTitle:@"clickMe" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 200, 100, 50);
    [btn1 setTitle:@"net2数据请求" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(net2btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    

    
}

-(void)btnClick
{
  
    NSString *url = @"http://www.lvkeworld.com/ashx/App.ashx";
   NSDictionary *paramers = @{@"action":@"getMyDatas",@"apikey":@"b6a26fb81b2429e1",@"userid":@"570"};
    SNNetwork *request1 = [[SNNetwork alloc]init];
//    [request1 isUseCache:YES];
    [request1 POST:url parameters:paramers success:^(id responseObj) {
        
        NSLog(@"请求成功");
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败");
    }];
//    [request1 GET:url parameters:paramers success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
}

-(void)net2btnClick
{
    NET2Controller *vc = [[NET2Controller alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


/*
 * 获取APIKey,
 */
- (NSString *)getAPIKey{
    
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMM"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:locationString]) {
        return [[NSUserDefaults standardUserDefaults]objectForKey:locationString];
    }
    
    NSString *oldLocationString = [NSString stringWithFormat:@"%ld",[locationString integerValue]-1];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:oldLocationString];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *MD5 = [self createMD5:locationString];
    
    NSString *str = [MD5 substringWithRange:NSMakeRange(8, 16)];
    
    NSString *str1 = [str substringFromIndex:11];
    
    NSString *str2 = [NSString stringWithFormat:@"%@%@",[str substringWithRange:NSMakeRange(0, 1)],str1];
    
    NSString *apiKey = [[self createMD5:str2] substringWithRange:NSMakeRange(8, 16)];
    
    [[NSUserDefaults standardUserDefaults]setObject:apiKey forKey:locationString];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return apiKey;
}

/*
 * MD5加密
 */
-(NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}


@end
