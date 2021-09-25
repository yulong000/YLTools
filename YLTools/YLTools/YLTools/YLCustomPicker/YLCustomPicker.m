//
//  YLCustomPicker.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLCustomPicker.h"

#define kCustomPickerBackgroundColor          [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define kCustomPickerToolbarBackgroundColor   [UIColor colorWithRed:66.0 / 255 green:155.0 / 255 blue:277.0 / 255 alpha:1]
#define kCustomPickerCancelButtonTitleColor   [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kCustomPickerConfirmButtonTitleColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kCustomPickerTitleColor               [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kCustomPickerContentViewHeight        ([UIScreen mainScreen].bounds.size.height / 3)


@interface YLCustomPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy)   YLCustomPickerHandler handler;
@property (nonatomic, copy)   NSString *preTitle;
@property (nonatomic, assign) NSInteger index;


@end

@implementation YLCustomPicker
@synthesize cancelButtonTitleColor  = _cancelButtonTitleColor,
            confirmButtonTitleColor = _confirmButtonTitleColor,
            toolbarBackgroundColor  = _toolbarBackgroundColor,
            titleColor = _titleColor;

+ (instancetype)showCustomPickerWithTitle:(NSString *)title itemArr:(NSArray<NSString *> *)itemArr selectItem:(NSString *)item handler:(YLCustomPickerHandler)handler {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    YLCustomPicker *picker = [[YLCustomPicker alloc] initWithFrame:keyWindow.bounds];
    picker.titleLabel.text = title;
    picker.handler = handler;
    picker.preTitle = item;
    picker.dataArr = itemArr;
    [keyWindow addSubview:picker];
    [picker show];
    return picker;
}

+ (NSMutableArray *)itemsWithModelArr:(NSArray *)modelArr displayProperty:(NSString *)displayProperty {
    NSMutableArray *arr = [NSMutableArray array];
    if(displayProperty.length) {
        for (NSObject *model in modelArr) {
            NSString *value = [model valueForKey:displayProperty];
            if(value && [value isKindOfClass:[NSString class]]) {
                [arr addObject:value];
            }
        }
    }
    return arr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = kCustomPickerBackgroundColor;
        [self addSubview:self.bgView];
        
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = WhiteColor;
        [self.contentView addSubview:self.pickerView];
        
        self.toolBar = [[UIView alloc] init];
        self.toolBar.backgroundColor = kCustomPickerToolbarBackgroundColor;
        [self.contentView addSubview:self.toolBar];
        
        self.cancelBtn = [[UIButton alloc] init];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kCustomPickerCancelButtonTitleColor forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:self.cancelBtn];
        
        self.confirmBtn = [[UIButton alloc] init];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:kCustomPickerConfirmButtonTitleColor forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:self.confirmBtn];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = kCustomPickerTitleColor;
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
    self.contentView.frame = CGRectMake(0, self.height - kCustomPickerContentViewHeight, self.width, kCustomPickerContentViewHeight);
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
    return self.dataArr.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(row < self.dataArr.count) {
        self.preTitle = self.dataArr[row];
        self.index = row;
    }
}

#pragma mark - 取消
- (void)cancel {
    [self hide];
}
#pragma mark 确定
- (void)confirm {
    if(self.dataArr.count && self.handler) {
        self.handler(self.preTitle, self.index);
        YLLog(@"选择了 %d : %@", (int)self.index, self.preTitle);
    }
    [self hide];
}

#pragma mark 显示
- (void)show {
    self.contentView.origin = CGPointMake(0, self.height);
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.origin = CGPointMake(0, self.height - kCustomPickerContentViewHeight);
        self.bgView.alpha = 1;
    }];
    
    // 选中默认行
    if(self.dataArr.count == 0) return ;
    for (int i = 0; i < self.dataArr.count; i ++) {
        if(self.preTitle.isValidString && [self.preTitle isEqualToString:self.dataArr[i]]) {
            [self.pickerView selectRow:i inComponent:0 animated:YES];
            [self pickerView:self.pickerView didSelectRow:i inComponent:0];
            return ;
        }
    }
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
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
