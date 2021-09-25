//
//  YLSexPicker.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLSexPicker.h"

#define kSexPickerBackgroundColor          [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define kSexPickerToolbarBackgroundColor   [UIColor colorWithRed:66.0 / 255 green:155.0 / 255 blue:277.0 / 255 alpha:1]
#define kSexPickerCancelButtonTitleColor   [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kSexPickerConfirmButtonTitleColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kSexPickerTitleColor               [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kSexPickerContentViewHeight        ([UIScreen mainScreen].bounds.size.height / 3)


@interface YLSexPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, assign) YLPersonSex sex;
@property (nonatomic, copy  ) YLSexPickerHandler handler;


@end

@implementation YLSexPicker
@synthesize cancelButtonTitleColor  = _cancelButtonTitleColor,
            confirmButtonTitleColor = _confirmButtonTitleColor,
            toolbarBackgroundColor  = _toolbarBackgroundColor,
            titleColor = _titleColor;

+ (instancetype)showSexPickerWithSex:(YLPersonSex)sex handler:(YLSexPickerHandler)handler {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    YLSexPicker *picker = [[YLSexPicker alloc] initWithFrame:keyWindow.bounds];
    picker.handler = handler;
    picker.sex = sex;
    [keyWindow addSubview:picker];
    [picker show];
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = kSexPickerBackgroundColor;
        [self addSubview:self.bgView];
        
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = WhiteColor;
        [self.contentView addSubview:self.pickerView];
        
        self.toolBar = [[UIView alloc] init];
        self.toolBar.backgroundColor = kSexPickerToolbarBackgroundColor;
        [self.contentView addSubview:self.toolBar];
        
        self.cancelBtn = [[UIButton alloc] init];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kSexPickerCancelButtonTitleColor forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:self.cancelBtn];
        
        self.confirmBtn = [[UIButton alloc] init];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:kSexPickerConfirmButtonTitleColor forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:self.confirmBtn];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = kSexPickerTitleColor;
        self.titleLabel.text = @"选择性别";
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
    self.contentView.frame = CGRectMake(0, self.height - kSexPickerContentViewHeight, self.width, kSexPickerContentViewHeight);
    self.toolBar.frame = CGRectMake(0, 0, self.contentView.width, 40);
    self.pickerView.frame = CGRectMake(0, self.toolBar.height, self.contentView.width, self.contentView.height - self.toolBar.height);
    self.cancelBtn.frame = CGRectMake(0, 0, 60, self.toolBar.height);
    self.confirmBtn.frame = CGRectMake(self.toolBar.width - self.cancelBtn.width, 0, self.cancelBtn.width, self.toolBar.height);
    self.titleLabel.frame = CGRectMake(self.cancelBtn.right + 10, 0, self.confirmBtn.left - self.cancelBtn.right - 20, self.toolBar.height);
}

#pragma mark - pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(row == 0) return @"男";
    return @"女";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.sex = row == 0 ? YLPersonSexMan : YLPersonSexWoman;
}

#pragma mark - 取消
- (void)cancel {
    [self hide];
}
#pragma mark 确定
- (void)confirm {
    if(self.handler) {
        self.handler(self.sex);
        YLLog(@"性别选择 : %@", self.sex == YLPersonSexMan ? @"男" : @"女");
    }
    [self hide];
}

#pragma mark 显示
- (void)show {
    self.contentView.origin = CGPointMake(0, self.height);
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.origin = CGPointMake(0, self.height - kSexPickerContentViewHeight);
        self.bgView.alpha = 1;
        [self.pickerView selectRow:MIN(self.sex, 1) inComponent:0 animated:YES];
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
