//
//  TimerDemoVc.m
//  YLTools
//
//  Created by weiyulong on 2019/8/8.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "TimerDemoVc.h"
#import "YLWeakTimer.h"

@interface TimerDemoVc ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) int count;

@end

@implementation TimerDemoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.width - 20, 180)];
    message.centerX = self.view.centerPoint.x;
    message.text = @"1.直接使用NSTimer, 当控制器销毁时, 如果定时器未销毁, 继续执行, 会造成野指针 crash。\n2.一种方式 : 在每次控制器将要销毁之前, 先将定时器销毁, 处理起来相对麻烦。\n3.第二种方式 : 在定时器每次执行之前, 先判断delegate是否存在, 如果存在, 继续执行;如果不存在, 销毁定时器。\n4.YLWeakTimer采用第二种方式, 对NSTimer进行内部处理, 降低使用难度, 使用方法类似于NSTimer。";
    message.numberOfLines = 0;
    message.adjustsFontSizeToFitWidth = YES;
    message.font = Font(15);
    [self.view addSubview:message];
    
    // 输入倒计时的时间
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, message.bottom + 20, 200, 40)];
    self.textField.font = Font(16);
    self.textField.placeholder = @"输入倒计时的秒数";
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.centerX = self.view.centerPoint.x;
    [self.view addSubview:self.textField];
    
    // 显示倒计时
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.textField.bottom + 10, self.view.width, 30)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = Font(16);
    self.timeLabel.textColor = RGBA(53, 191, 126, 1);
    [self.view addSubview:self.timeLabel];
    
    __weak typeof(self) weakSelf = self;
    UIButton *begin = [UIButton buttonWithTitle:@"开始" backgroundImageCorlor:RGBA(53, 191, 126, 1) cornerRadius:5 clickBlock:^(UIButton *button) {
        // 先判断定时器是否在运行, 如果运行中,则清除
        if(weakSelf.timer.isValid) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
        }
        
        // 将定时器添加到runloop中, 开始倒计时
        weakSelf.count = weakSelf.textField.text.intValue;
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"倒计时 %d s", weakSelf.count];
        [[NSRunLoop mainRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
    }];
    [begin setTitleColor:WhiteColor forState:UIControlStateNormal];
    begin.size = CGSizeMake(200, 40);
    begin.top = self.timeLabel.bottom + 10;
    begin.centerX = self.timeLabel.centerX;
    [self.view addSubview:begin];
}

- (void)dealloc {
    NSLog(@"%@  销毁了!", NSStringFromClass([self class]));
}

- (NSTimer *)timer {
    if(_timer == nil) {
        __weak typeof(self) weakSelf = self;
        _timer = [YLWeakTimer timerWithTimeInterval:1 target:self repeatHandler:^(NSTimer * _Nonnull timer) {
            if(-- weakSelf.count > 0) {
                weakSelf.timeLabel.text = [NSString stringWithFormat:@"倒计时 %d s", weakSelf.count];
            } else {
                weakSelf.timeLabel.text = @"倒计时 结束!";
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
        }];
    }
    return _timer;
}


@end
