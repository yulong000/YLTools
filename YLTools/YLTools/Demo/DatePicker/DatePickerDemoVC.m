//
//  DatePickerDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/8/9.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "DatePickerDemoVC.h"
#import "YLDatePicker.h"

@interface DatePickerDemoVC ()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation DatePickerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = Font(15);
    self.timeLabel.size = CGSizeMake(300, 30);
    self.timeLabel.centerX = self.view.centerPoint.x;
    self.timeLabel.top = kNavTotalHeight + 30;
    [self.view addSubview:self.timeLabel];
    
    __weak typeof(self) weakSelf = self;
    UIButton *dateBtn = [UIButton buttonWithTitle:@"选择日期" clickBlock:^(UIButton *button) {
        
        // 显示日期选择器
        /*
        YLDatePicker *datePicker = [YLDatePicker showDatePickerWithMode:UIDatePickerModeDate handler:^(NSDate * _Nonnull date) {
            weakSelf.timeLabel.text = [date stringValueWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        }];
        
        // 自定义日期选择器的样式, 非必选
        datePicker.confirmButtonTitleColor = BlueColor;
        datePicker.cancelButtonTitleColor = RedColor;
        datePicker.toolbarBackgroundColor = OrangeColor;
        datePicker.datePicker.maximumDate = [NSDate dateWithFormat:@"yyyy-MM-dd" string:@"2020-12-01"];
        datePicker.datePicker.minimumDate = [NSDate dateWithFormat:@"yyyy-MM-dd" string:@"2019-08-01"];
        datePicker.datePicker.date = [NSDate dateWithFormat:@"yyyy-MM-dd" string:@"2020-01-01"];
         */
        
        [YLDatePicker showDatePickerWithTitle:@"选择日期" mode:UIDatePickerModeDate selectDate:[NSDate date].yesterday minDate:[NSDate dateWithFormat:@"yyyy-MM-dd" string:@"2021-02-20"] maxDate:[NSDate dateWithFormat:@"yyyy-MM-dd" string:@"2023-12-30"] handler:^(NSDate * _Nonnull date) {
            weakSelf.timeLabel.text = [date stringValueWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dateBtn];
}


@end
