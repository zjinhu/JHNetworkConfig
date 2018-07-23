//
//  JHNetworkConfig.m
//  JHNetworkConfig
//
//  Created by HU on 2018/7/20.
//  Copyright © 2018年 HU. All rights reserved.
//

#import "JHNetworkConfig.h"
#import "JHNetworkConfigViewController.h"

/************************************************************************/

static NSString *const keyNetwork = @"JHNetworkSettingHost";

/************************************************************************/

static NSString *const keyNetworkConfig        = @"keyNetworkConfig";
static NSString *const keyNetworkConfigPublic  = @"keyNetworkConfigPublic";
static NSString *const keyNetworkConfigDevelop = @"keyNetworkConfigDevelop";
static NSString *const keyNetworkConfigOhter   = @"keyNetworkConfigOhter";

/************************************************************************/

@interface JHNetworkConfig ()

@property (nonatomic, copy) void (^completeBlock)(void);
@property (nonatomic, assign) BOOL isExitApp;

@property (nonatomic, assign) NSInteger isPublicNetworkConfig;
///// 网络环境设置（名称，url地址；注：名称为键、url地址为值）
@property (nonatomic, strong) NSDictionary *networkDict;
@property (nonatomic, strong) NSString *publicName;
@property (nonatomic, strong) NSString *publicUrl;
@property (nonatomic, strong) NSString *developName;
@property (nonatomic, strong) NSString *developUrl;
// 环境配置变量
@property (nonatomic, strong) NSMutableDictionary *configDict;

@property (nonatomic, weak) UIViewController *controller;

@end

@implementation JHNetworkConfig

- (instancetype)init {
    self = [super init];
    if (self)  {
        
    }
    return self;
}

+ (JHNetworkConfig *)shareConfig {
    static JHNetworkConfig *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[JHNetworkConfig alloc] init];
        assert(sharedManager != nil);
    });
    
    return sharedManager;
}

- (void)initializeConfig; {
    [self readConfigNetwork];
    [self setDefaultNetwork];
}

- (void)readConfigNetwork {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // 初始化APP时的配置
    for (NSString *key in self.configDict.allKeys) {
        if ([key isEqualToString:keyNetworkConfig]) {
            // 网络环境
            NSString *value = [self.configDict objectForKey:key];
            self.isPublicNetworkConfig = value.integerValue;
        } else if ([key isEqualToString:keyNetworkConfigDevelop]) {
            self.developName = kNameDelelop;
            self.developUrl = [self.configDict objectForKey:key];
        } else if ([key isEqualToString:keyNetworkConfigPublic]) {
            self.publicName = kNamePublish;
            self.publicUrl = [self.configDict objectForKey:key];
        } else {
            NSDictionary *dictTmp = [self.configDict objectForKey:key];
            if (dictTmp && 0 != dictTmp.count) {
                [dict setDictionary:dictTmp];
            }
        }
    }
    // 开发和发布配置
    [dict setValue:self.publicUrl forKey:self.publicName];
    [dict setValue:self.developUrl forKey:self.developName];
    // 手动添加的地址配置
    NSDictionary *dictAdd = [[NSUserDefaults standardUserDefaults] objectForKey:kAddNetworkAddress];
    for (NSString *key in dictAdd.allKeys) {
        NSString *value = [dictAdd objectForKey:key];
        [dict setValue:value forKey:key];
    }
    //
    self.networkDict = [NSDictionary dictionaryWithDictionary:dict];
    
    NSAssert(self.publicName != nil, @"self.publicName must be not nil");
    NSAssert(self.publicUrl != nil, @"self.publicUrl must be not nil");
    NSAssert(self.developName != nil, @"self.developName must be not nil");
    NSAssert(self.developUrl != nil, @"self.developUrl must be not nil");
    NSAssert(self.configDict != nil, @"self.networkDict must be not nil");
}

// 设置初始化网络环境
- (void)setDefaultNetwork {
    NSString *networkName = [self getDefaultNetworkName];
    NSArray *nameArray = self.networkDict.allKeys;
    [nameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([name isEqualToString:networkName]) {
            [self setDefaultNetwork:name];
            *stop = YES;
        }
    }];
}

// 获取网络环境名称
- (NSString *)getDefaultNetworkName {
    // 默认开发测试环境
    NSString *networkName = [NetworkUserDefault objectForKey:keyNetwork];
    if (![self.networkDict.allKeys containsObject:networkName]) {
        // 手动配置的地址被删除后，默认使用开发环境
        networkName = nil;
    }
    if (1 == self.isPublicNetworkConfig) {
        // 发布环境
        if (networkName && 0 != networkName.length) {
            // 如果是发布环境，且设置了网络环境，则使用设置的网络环境
        } else  {
            // 如果没有重新设置网络环境，则默认使用发布环境
            networkName = self.publicName;
        }
    } else {
        // 非发布环境
        if (!networkName || 0 == networkName.length) {
            // 如果没有初始化值，默认开发环境
            networkName = self.developName;
        }
    }
    return networkName;
}

// 设置网络环境名称
- (void)setDefaultNetwork:(NSString *)name {
    if (name && 0 != name.length) {
        [NetworkUserDefault setObject:name forKey:keyNetwork];
        [NetworkUserDefault synchronize];
    }
}

// 获取开发网络环境地址
- (NSString *)getDefaultNetworkHost {
   __block NSString *networkUrl = nil;
    
    NSString *networkName = [NetworkUserDefault objectForKey:keyNetwork];
    NSArray *nameArray = self.networkDict.allKeys;
 
    [nameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([name isEqualToString:networkName]) {
            networkUrl = [self.networkDict objectForKey:name];
            *stop = YES;
        }
    }];
    return networkUrl;
}

#pragma mark 设置方法

// 设置APP环境按钮
- (void)configWithTarget:(UIViewController *)target exitApp:(BOOL)isExit complete:(void (^)(void))complete {
    self.isExitApp = isExit;
    
    if (complete) {
        self.completeBlock = [complete copy];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 80.0, 44.0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    if (1 == self.isPublicNetworkConfig) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(networkClick:)];
        tapRecognizer.numberOfTapsRequired = 5;
        [button addGestureRecognizer:tapRecognizer];
    } else {
        NSString *name = [self getDefaultNetworkName];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(networkClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (target) {
        self.controller = target;
        target.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)configWithTarget:(UIViewController *)targer frame:(CGRect)rect exitApp:(BOOL)isExit complete:(void (^)(void))complete {
    self.isExitApp = isExit;
    
    if (complete) {
        self.completeBlock = [complete copy];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 80.0, 44.0);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    if (1 == self.isPublicNetworkConfig) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(networkClick:)];
        tapRecognizer.numberOfTapsRequired = 5;
        [button addGestureRecognizer:tapRecognizer];
    } else {
        NSString *name = [self getDefaultNetworkName];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:name forState:UIControlStateNormal];
        [button addTarget:self action:@selector(networkClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (targer) {
        self.controller = targer;
        [targer.view addSubview:button];
        button.frame = rect;
    }
}

#pragma mark 响应方法

- (void)networkClick:(id)sender {
    NSLog(@"设置前：(%@)%@", [NetworkConfig getDefaultNetworkName], NetworkHost);
    typeof(self) __weak weakSelf = self;
    NSString *name = [self getDefaultNetworkName];
    JHNetworkConfigViewController *vc = [[JHNetworkConfigViewController alloc] init];
    vc.configURLs = self.networkDict;
    vc.configName = name;
    vc.configSelected = ^(NSString *name){
        // 保存选择环境
        [weakSelf setDefaultNetwork:name];
        if ([sender isKindOfClass:[UIButton class]]) {
            [sender setTitle:name forState:UIControlStateNormal];
        }
        NSLog(@"设置后：(%@)%@", [NetworkConfig getDefaultNetworkName], NetworkHost);
        // 退出重启，或重新连接
        [weakSelf exitApplication];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.controller presentViewController:nav animated:YES completion:NULL];
}

- (void)exitApplication{
    if (self.completeBlock){
        self.completeBlock();
    }
    
    if (self.isExitApp){
        // 退出APP
        exit(0);
    }
}

#pragma mark - setter

- (void)setConfigHost:(NSString *)configHost{
    [self.configDict setObject:configHost forKey:keyNetworkConfig];
}

- (void)setConfigHostDebug:(NSString *)configHostDebug{
    [self.configDict setObject:configHostDebug forKey:keyNetworkConfigDevelop];
}

- (void)setConfigHostRelease:(NSString *)configHostRelease{
    [self.configDict setObject:configHostRelease forKey:keyNetworkConfigPublic];
}

- (void)setConfigHostDebugDict:(NSDictionary *)configHostDebugDict{
    [self.configDict setObject:configHostDebugDict forKey:keyNetworkConfigOhter];
}

- (NSMutableDictionary *)configDict{
    if (_configDict == nil){
        _configDict = [NSMutableDictionary dictionary];
    }
    return _configDict;
}
@end
