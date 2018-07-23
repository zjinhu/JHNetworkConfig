//
//  JHNetworkConfigViewController.h
//  JHNetworkConfig
//
//  Created by HU on 2018/7/20.
//  Copyright © 2018年 HU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHNetworkConfigViewController : UIViewController
/// 数据源-地址字典
@property (nonatomic, strong) NSDictionary *configURLs;
/// 数据源-名称
@property (nonatomic, strong) NSString *configName;
/// 响应回调-选择
@property (nonatomic, copy) void (^configSelected)(NSString *name);
 
@end
