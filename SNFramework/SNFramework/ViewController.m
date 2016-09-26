//
//  ViewController.m
//  SNFramework
//
//  Created by huangshuni on 16/8/25.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "ViewController.h"
#import "NET2Controller.h"
#import "NET1ViewController.h"
#import "SNWordViewController.h"

#import <AFNetworking/AFNetworking.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSArray *datasArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDelegate / UITableViewDataSourse
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.datasArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NET1ViewController *vc = [[NET1ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        NET2Controller *vc = [[NET2Controller alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        SNWordViewController *vc = [[SNWordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - setter / getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

-(NSArray *)datasArr
{
    if (!_datasArr) {
        _datasArr = [NSArray arrayWithObjects:@"集约型网络请求框架",@"离散型网络请求框架",@"富文本编辑器", nil];
    }
    return _datasArr;
}


@end
