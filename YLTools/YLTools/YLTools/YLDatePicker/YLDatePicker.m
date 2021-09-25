//
//  YLDatePicker.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLDatePicker.h"

#define kDatePickerBackgroundColor          [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define kDatePickerToolbarBackgroundColor   [UIColor colorWithRed:66.0 / 255 green:155.0 / 255 blue:277.0 / 255 alpha:1]
#define kDatePickerCancelButtonTitleColor   [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kDatePickerConfirmButtonTitleColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kDatePickerTitleColor               [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kDatePickerContentViewHeight        ([UIScreen mainScreen].bounds.size.height / 3)


@interface YLDatePicker ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, copy)   YLDatePickerHandler resultHandler;
@end


@implementation YLDatePicker
@synthesize cancelButtonTitleColor  = _cancelButtonTitleColor,
            confirmButtonTitleColor = _confirmButtonTitleColor,
            toolbarBackgroundColor  = _toolbarBackgroundColor,
            titleColor = _titleColor;

+ (instancetype)showDatePickerWithMode:(UIDatePickerMode)mode handler:(YLDatePickerHandler)handler {
    return [self showDatePickerWithTitle:nil mode:mode selectDate:nil minDate:nil maxDate:nil handler:handler];
}

+ (instancetype)showDatePickerWithTitle:(NSString *)title selectDate:(NSDate *)selectDate handler:(YLDatePickerHandler)handler {
    return [self showDatePickerWithTitle:title mode:UIDatePickerModeDate selectDate:selectDate minDate:nil maxDate:nil handler:handler];
}

+ (instancetype)showDatePickerWithTitle:(NSString *)title mode:(UIDatePickerMode)mode selectDate:(NSDate *)selectDate handler:(YLDatePickerHandler)handler {
    return [self showDatePickerWithTitle:title mode:mode selectDate:selectDate minDate:nil maxDate:nil handler:handler];
}

+ (instancetype)showDatePickerWithTitle:(NSString *)title mode:(UIDatePickerMode)mode selectDate:(NSDate *)selectDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate handler:(YLDatePickerHandler)handler {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    YLDatePicker *picker = [[YLDatePicker alloc] initWithFrame:keyWindow.bounds];
    picker.titleLabel.text = title;
    picker.datePicker.datePickerMode = mode;
    picker.datePicker.date = selectDate;
    picker.datePicker.minimumDate = minDate;
    picker.datePicker.maximumDate = maxDate;
    picker.resultHandler = handler;
    [keyWindow addSubview:picker];
    [picker show];
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = kDatePickerBackgroundColor;
        [self addSubview:self.bgView];
        
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        
        self.pickerView = [[UIDatePicker alloc] init];
        if(@available(iOS 13.4, *)) self.pickerView.preferredDatePickerStyle = UIDatePickerStyleWheels;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        
        self.toolBar = [[UIView alloc] init];
        self.toolBar.backgroundColor = kDatePickerToolbarBackgroundColor;
        [self.contentView addSubview:self.toolBar];
        
        self.cancelBtn = [[UIButton alloc] init];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kDatePickerCancelButtonTitleColor forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:self.cancelBtn];
        
        self.confirmBtn = [[UIButton alloc] init];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:kDatePickerConfirmButtonTitleColor forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:self.confirmBtn];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = kDatePickerTitleColor;
        [self.toolBar addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.pickerView];
        
        __weak typeof(self) weakSelf = self;
        [self.bgView addTapGestureHandleBlock:^(UIView *view, UITapGestureRecognizer *tap) {
            [weakSelf cancel];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.contentView.frame = CGRectMake(0, self.height - kDatePickerContentViewHeight, self.width, kDatePickerContentViewHeight);
    self.toolBar.frame = CGRectMake(0, 0, self.contentView.width, 40);
    self.pickerView.frame = CGRectMake(0, self.toolBar.height, self.contentView.width, self.contentView.height - self.toolBar.height);
    self.cancelBtn.frame = CGRectMake(0, 0, 60, self.toolBar.height);
    self.confirmBtn.frame = CGRectMake(self.toolBar.width - self.cancelBtn.width, 0, self.cancelBtn.width, self.toolBar.height);
    self.titleLabel.frame = CGRectMake(self.cancelBtn.right + 10, 0, self.confirmBtn.left - self.cancelBtn.right - 20, self.toolBar.height);
}

#pragma mark 取消
- (void)cancel {
    [self hide];
}
#pragma mark 确定
- (void)confirm {
    if(self.resultHandler) {
        self.resultHandler(self.pickerView.date);
        YLLog(@"日期选择 : %@", self.pickerView.date);
    }
    [self hide];
}

#pragma mark 显示
- (void)show {
    self.contentView.origin = CGPointMake(0, self.height);
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.origin = CGPointMake(0, self.height - kDatePickerContentViewHeight);
        self.bgView.alpha = 1;
    }];
}

#pragma mark 隐藏
- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0;
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UIDatePicker *)datePicker {
    return self.pickerView;
}

#pragma mark - 自定义设置

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor {
    if(cancelButtonTitleColor) {
        _cancelButtonTitleColor = cancelButtonTitleColor;
        [self.cancelBtn setTitleColor:_cancelButtonTitleColor forState:UIControlStateNormal];
    }
}

- (void)setConfirmButtonTitleColor:(UIColor *)confirmButtonTitleColor {
    if(confirmButtonTitleColor) {
        _confirmButtonTitleColor = confirmButtonTitleColor;
        [self.confirmBtn setTitleColor:_confirmButtonTitleColor forState:UIControlStateNormal];
    }
}

- (void)setToolbarBackgroundColor:(UIColor *)toolbarBackgroundColor {
    if(toolbarBackgroundColor) {
        _toolbarBackgroundColor = toolbarBackgroundColor;
        [self.confirmBtn setTitleColor:_toolbarBackgroundColor forState:UIControlStateNormal];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    if(titleColor) {
        _titleColor = titleColor;
        self.titleLabel.textColor = titleColor;
    }
}

- (UIColor *)cancelButtonTitleColor {
    return [self.cancelBtn titleColorForState:UIControlStateNormal];
}

- (UIColor *)confirmButtonTitleColor {
    return [self.confirmBtn titleColorForState:UIControlStateNormal];
}

- (UIColor *)toolbarBackgroundColor {
    return self.toolBar.backgroundColor;
}

- (UIColor *)titleColor {
    return self.titleLabel.textColor;
}

@end
