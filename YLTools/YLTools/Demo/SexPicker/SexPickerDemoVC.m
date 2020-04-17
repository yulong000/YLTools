//
//  SexPickerDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/8/12.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "SexPickerDemoVC.h"
#import "YLSexPicker.h"

@interface SexPickerDemoVC ()

@property (nonatomic, strong) UILabel *sexLabel;

@end

@implementation SexPickerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sexLabel = [[UILabel alloc] init];
    self.sexLabel.textAlignment = NSTextAlignmentCenter;
    self.sexLabel.font = Font(15);
    self.sexLabel.size = CGSizeMake(300, 30);
    self.sexLabel.centerX = self.view.centerPoint.x;
    self.sexLabel.top = kNavTotalHeight + 30;
    [self.view addSubview:self.sexLabel];
    
    __weak typeof(self) weakSelf = self;
    UIButton *sexBtn = [UIButton buttonWithTitle:@"选择性别" clickBlock:^(UIButton *button) {
        
        // 显示性别选择器
        YLSexPicker *sexPicker = [YLSexPicker showSexPickerWithSex:YLPersonSexMan handler:^(YLPersonSex sex) {
            weakSelf.sexLabel.text = sex == YLPersonSexMan ? @"男" : @"女";
        }];
        
        // 自定义性别选择器的样式, 非必选
        sexPicker.confirmButtonTitleColor = BlueColor;
        sexPicker.cancelButtonTitleColor = RedColor;
        sexPicker.toolbarBackgroundColor = OrangeColor;
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sexBtn];
}
@end
