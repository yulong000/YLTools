//
//  ViewController.m
//  YLTools
//
//  Created by weiyulong on 2020/4/6.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工具库";
    
    [self.view addSubview:self.tableView = [self createTableView]];
    self.tableView.frame = self.view.bounds;
}

- (NSArray *)dataArr {
    if(_dataArr == nil) {
        _dataArr = @[@{@"title" : @"网络请求",     @"controller" : @"NetworkDemoVC"},
                     @{@"title" : @"支付",        @"controller" : @"PayDemoVC"},
                     @{@"title" : @"定时器",      @"controller" : @"TimerDemoVc"},
                     @{@"title" : @"日期选择器",   @"controller" : @"DatePickerDemoVC"},
                     @{@"title" : @"性别选择器",   @"controller" : @"SexPickerDemoVC"},
                     @{@"title" : @"微信登录",     @"controller" : @"WeChatLoginDemoVC"},
                     @{@"title" : @"虚线",        @"controller" : @"DashLineDemoVC"},
                     @{@"title" : @"地址选择器",   @"controller" : @"AddressPickerDemoVC"},
                     @{@"title" : @"图片/视频选择器",@"controller" : @"PhotoPickerDemoVC"},
                     @{@"title" : @"定位",        @"controller" : @"LocationDemoVC"},
                     @{@"title" : @"分享",        @"controller" : @"ShareDemoVC"},
                     @{@"title" : @"音频播放",     @"controller" : @"AudioPlayDemoVC"},
                     @{@"title" : @"自定义按钮",   @"controller" : @"ButtonDemoVC"},
                     @{@"title" : @"textView",   @"controller" : @"TextViewDemoVC"},
                     @{@"title" : @"圆角View",    @"controller" : @"CornerViewDemoVC"},
                     @{@"title" : @"自定义选择器",  @"controller" : @"CustomPickerDemoVC"},
                     @{@"title" : @"富文本显示",   @"controller" : @"RichTextViewDemoVC"},];
    }
    return _dataArr;
}

#pragma mark 创建talbeView
- (UITableView *)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    return tableView;
}

#pragma mark - tableView
#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ViewControllerTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [self.dataArr[indexPath.row] objectForKey:@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *clazz = [self.dataArr[indexPath.row] objectForKey:@"controller"];
    UIViewController *vc = [[NSClassFromString(clazz) alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = [self.dataArr[indexPath.row] objectForKey:@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


@end
