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
        
        NSMutableArray <UILabel *>*arr = [NSMutableArray array];
        for (int i = 0; i < 5; i ++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"第%d个选项", i];
            [arr addObject:label];
        }
        
        // 显示自定义选择器
//        YLCustomPicker *customPicker = [YLCustomPicker showCustomPickerWithTitle:@"自定义选择" itemArr:[YLCustomPicker itemsWithModelArr:arr displayProperty:@"text"] selectItem:weakSelf.textLabel.text handler:^(NSString * _Nonnull item, NSInteger index) {
//            weakSelf.textLabel.text = item;
//        }];
        
        YLCustomPicker *customPicker = [YLCustomPicker showCustomPickerWithTitle:nil itemArr:@[] selectItem:weakSelf.textLabel.text handler:^(NSString * _Nonnull item, NSInteger index) {
            weakSelf.textLabel.text = item;
        }];
        
        // 自定义选择器的样式, 非必选
        customPicker.confirmButtonTitleColor = BlueColor;
        customPicker.cancelButtonTitleColor = RedColor;
        customPicker.toolbarBackgroundColor = OrangeColor;
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
}

@end
