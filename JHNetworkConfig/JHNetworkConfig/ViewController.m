//
//  ViewController.m
//  JHNetworkConfig
//
//  Created by HU on 2018/7/23.
//  Copyright © 2018年 HU. All rights reserved.
//

#import "ViewController.h"
#import "JHNetworkConfig.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //VC上添加按钮控制
    [[JHNetworkConfig shareConfig] configWithTarget:self frame:CGRectMake(100, 100, 100, 50) exitApp:NO complete:^{
        NSLog(@"%@",NetworkHost);
    }];
    //nav上右侧按钮控制
//    [[JHNetworkConfig shareConfig] configWithTarget:self exitApp:NO complete:^{
//        NSLog(@"%@",NetworkHost);
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
