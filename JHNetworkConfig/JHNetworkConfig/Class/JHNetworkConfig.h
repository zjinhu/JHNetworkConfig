//
//  JHNetworkConfig.h
//  JHNetworkConfig
//
//  Created by HU on 2018/7/20.
//  Copyright © 2018年 HU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/************************************************************************/

static NSString *const kNameDelelop = @"默认开发测试环境";
static NSString *const kNamePublish = @"默认发布环境";

static NSString *const kAddNetworkAddress = @"ManualAddNetworkAddress";
#define NetworkUserDefault  [NSUserDefaults standardUserDefaults]

#define NetworkConfig       ([JHNetworkConfig shareConfig])
#define NetworkHost         ([[JHNetworkConfig shareConfig] getDefaultNetworkHost])

/************************************************************************/
@interface JHNetworkConfig : NSObject
/// 网络环境（0为测试环境；1为线上环境）
@property (nonatomic, strong) NSString *configHost;
/// 测试环境地址（默认地址）
@property (nonatomic, strong) NSString *configHostDebug;
/// 线上环境地址（线上地址）
@property (nonatomic, strong) NSString *configHostRelease;
/// 测试环境地址集合（默认地址）
@property (nonatomic, strong) NSDictionary *configHostDebugDict;


+ (JHNetworkConfig *)shareConfig;

/// 初始化网络环境（注意：发布时环境状态为1）
- (void)initializeConfig;

/// 获取开发网络环境地址
- (NSString *)getDefaultNetworkHost;

/**
 *  设置APP环境按钮（注：显示在设置视图控制器的导航栏右按钮；若在发布环境，则不显示标题，连续点击5次弹出设置视图）
 *  @param targer          添加设置控制网络环境按钮的视图控制器（即设置成该视图控制器的导航栏右按钮）
 *  @param isExit          是否退出当前APP
 *  @param complete        设置完成的后回调处理（如：退出登录，或退出APP，或回到根视图控制器并重新刷新网络）
 */
- (void)configWithTarget:(UIViewController *)targer exitApp:(BOOL)isExit complete:(void (^)(void))complete;

/**
 *  设置APP环境按钮（注：显示在指定视图的指定位置）
 *
 *  @param targer   添加设置网络环境按钮的视图
 *  @param rect     在视图中的显示位置
 *  @param isExit   是否退出当前APP
 *  @param complete 设置完成后的回调
 */
- (void)configWithTarget:(UIViewController *)targer frame:(CGRect)rect exitApp:(BOOL)isExit complete:(void (^)(void))complete;

@end
