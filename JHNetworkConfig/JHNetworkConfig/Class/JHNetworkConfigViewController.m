//
//  JHNetworkConfigViewController.m
//  JHNetworkConfig
//
//  Created by HU on 2018/7/20.
//  Copyright © 2018年 HU. All rights reserved.
//

#import "JHNetworkConfigViewController.h"
#import "JHNetworkConfig.h"
@interface JHNetworkConfigViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *configTableView;
@property (nonatomic, strong) NSString *selectedName;

@property (nonatomic, strong) NSIndexPath *previousIndex;

@end

@implementation JHNetworkConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"网络环境配置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(buttonConfirm)];
    
    // 列表视图
    _configTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, (self.view.frame.size.height - 80.0)) style:UITableViewStylePlain];
    _configTableView.delegate = self;
    _configTableView.dataSource = self;
    _configTableView.tableFooterView = [UIView new];
    _configTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _configTableView.showsHorizontalScrollIndicator = NO;
    _configTableView.showsVerticalScrollIndicator = NO;
    _configTableView.estimatedRowHeight = 100;
    _configTableView.rowHeight = UITableViewAutomaticDimension;
    _configTableView.estimatedSectionHeaderHeight = 0;
    _configTableView.estimatedSectionFooterHeight = 0;
    _configTableView.delaysContentTouches = YES;
    [self.view addSubview:_configTableView];

    // 拖动配置按钮
    UISegmentedControl *segmentButton = [[UISegmentedControl alloc] initWithItems:@[@"添加地址", @"删除地址"]];
    [self.view addSubview:segmentButton];
    segmentButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    segmentButton.frame = CGRectMake(20.0, (_configTableView.frame.origin.y + _configTableView.frame.size.height + 20.0), (self.view.frame.size.width - 40.0), 40.0);
    segmentButton.backgroundColor = [UIColor clearColor];
    segmentButton.tintColor = [UIColor blueColor];
    segmentButton.layer.cornerRadius = 5.0;
    segmentButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    segmentButton.layer.borderWidth = 1.0;
    segmentButton.layer.masksToBounds = YES;
    segmentButton.clipsToBounds = YES;
    segmentButton.momentary = YES;
    [segmentButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%@ dealloc...", [self class]);
}

-(void)setConfigURLs:(NSDictionary *)configURLs{
    _configURLs = configURLs;
    [_configTableView reloadData];
}
-(void)setConfigName:(NSString *)configName{
    _configName = configName;
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _configURLs.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
        // 字体颜色
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    NSString *name = _configURLs.allKeys[indexPath.row];
    cell.textLabel.text = name;
    NSString *url = [_configURLs objectForKey:name];
    cell.detailTextLabel.text = url;
    // 字体颜色
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([_configName isEqualToString:name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // 字体高亮颜色
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.textColor = [UIColor blueColor];
        
        _previousIndex = indexPath;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 当前选择回调
        _selectedName = _configURLs.allKeys[indexPath.row];
    // 选择操作
    if (_previousIndex) {
        UITableViewCell *cellPrevious = [tableView cellForRowAtIndexPath:_previousIndex];
        cellPrevious.accessoryType = UITableViewCellAccessoryNone;
        
        // 字体颜色
        cellPrevious.textLabel.textColor = [UIColor blackColor];
        cellPrevious.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    cellSelected.accessoryType = UITableViewCellAccessoryCheckmark;
    // 字体高亮颜色
    cellSelected.textLabel.textColor = [UIColor blueColor];
    cellSelected.detailTextLabel.textColor = [UIColor blueColor];
    
    _previousIndex = indexPath;
}


#pragma mark - 响应

- (void)buttonConfirm{
    // 保存
    if (_configSelected && _selectedName){
        _configSelected(_selectedName);
    }
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)addAddress:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    if (0 == index){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.placeholder = @"网络名称";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.secureTextEntry = NO;
            textField.placeholder = @"必须https:// 或 http:// 开头的网络地址";
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 第一个输入框
            UITextField *nameField = [[alert textFields] objectAtIndex:0];
            NSString *name = nameField.text;
            NSLog(@"name = %@",name);
            
            // 第二个输入框
            UITextField *valueTextField = [[alert textFields] objectAtIndex:1];
            NSString *value = valueTextField.text;
            NSLog(@"value = %@",value);
            
            if ((name && 0 < name.length) && ((value && 0 < value.length && ([value hasPrefix:@"http://"] || [value hasPrefix:@"https://"])))) {
                //
                NSDictionary *dictTmp = [NetworkUserDefault objectForKey:kAddNetworkAddress];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictTmp];
                if (dict == nil) {
                    dict = [[NSMutableDictionary alloc] init];
                }
                [dict setValue:value forKey:name];
                [NetworkUserDefault setObject:dict forKey:kAddNetworkAddress];
                [NetworkUserDefault synchronize];
                
                // 属性设置
                for (NSString *key in self.configURLs.allKeys) {
                    NSString *value = [self.configURLs objectForKey:key];
                    [dict setValue:value forKey:key];
                }
                self.configURLs = dict;
                
                [NetworkConfig initializeConfig];
                
                [self.configTableView reloadData];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (1 == index){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除地址" message:@"确定删除手动添加地址？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDictionary *dictTmp = [NetworkUserDefault objectForKey:kAddNetworkAddress];
            if (dictTmp) {
                if ([dictTmp.allKeys containsObject:self.configName]) {
                    self.configName = kNameDelelop;
                    self.selectedName = kNameDelelop;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.configURLs];
                for (NSString *key in dictTmp.allKeys) {
                    [dict removeObjectForKey:key];
                }
                self.configURLs = dict;
                
                [NetworkUserDefault removeObjectForKey:kAddNetworkAddress];
                [NetworkUserDefault synchronize];
                
                [NetworkConfig initializeConfig];
                
                [self.configTableView reloadData];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
