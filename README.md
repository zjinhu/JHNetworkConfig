# JHNetworkConfig
网络环境变量配置
代码参考 SYNetworkEnvironment 感谢SYNetworkEnvironment作者，我精简了部分代码和方法，直接拿来用了

##  使用方法
适当位置配置网络环境
```objc
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ //只执行一次就可以了
        NetworkConfig.configHost = @"0";
        NetworkConfig.configHostDebug = @"https://api.github.com/";
        NetworkConfig.configHostRelease = @"https://www.baidu.com";
        NetworkConfig.configHostDebugDict = @{@"环境1":@"http://www.google.com",
                                              @"环境2":@"https://www.sina.com"};
        // 初始化
        [NetworkConfig initializeConfig];
    });
```
适当位置添加UI方法
```objc
    //VC上添加按钮控制
    [[JHNetworkConfig shareConfig] configWithTarget:self frame:CGRectMake(100, 100, 100, 50) exitApp:NO complete:^{
        NSLog(@"%@",NetworkHost);
    }];
    //nav上右侧按钮控制
//    [[JHNetworkConfig shareConfig] configWithTarget:self exitApp:NO complete:^{
//        NSLog(@"%@",NetworkHost);
//    }];
```

全局获取Host地址
```objc
#import "JHNetworkConfig.h"
使用宏
#define NetworkHost         ([[JHNetworkConfig shareConfig] getDefaultNetworkHost])
```

##  安装
### 1.手动添加:<br>
*   1.将 JHNetworkConfig 文件夹添加到工程目录中<br>
*   2.导入 JHNetworkConfig.h

### 2.CocoaPods:<br>
*   1.在 Podfile 中添加 pod 'JHNetworkConfig'<br>
*   2.执行 pod install 或 pod update<br>
*   3.导入 JHNetworkConfig.h
 
