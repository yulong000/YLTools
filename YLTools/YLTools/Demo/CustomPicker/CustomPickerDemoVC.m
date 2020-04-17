//
//  CustomPickerDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/11/7.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "CustomPickerDemoVC.h"
#import "YLCustomPicker.h"

@interface CustomPickerDemoVC ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation CustomPickerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = Font(15);
    self.textLabel.size = CGSizeMake(300, 30);
    self.textLabel.centerX = self.view.centerPoint.x;
    self.textLabel.top = kNavTotalHeight + 30;
    [self.view addSubview:self.textLabel];
    
    __weak typeof(self) weakSelf = self;
    UIButton *customBtn = [UIButton buttonWithTitle:@"自定义选择" clickBlock:^(UIButton *button) {
        
        // 显示自定义选择器
        YLCustomPicker *customPicker = [YLCustomPicker showCustomPickerWithTitles:@[@"自定义字符串1",
                                                                                    @"自定义字符串2",
                                                                                    @"自定义字符串3",
                                                                                    @"自定义字符串4",
                                                                                    @"自定义字符串5", ]
                                                                      selectTitle:weakSelf.textLabel.text
                                                                          handler:^(NSString * _Nonnull title, NSInteger index) {
            weakSelf.textLabel.text = title;
        }];
        
        // 自定义选择器的样式, 非必选
        customPicker.confirmButtonTitleColor = BlueColor;
        customPicker.cancelButtonTitleColor = RedColor;
        customPicker.toolbarBackgroundColor = OrangeColor;
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
}

@end
