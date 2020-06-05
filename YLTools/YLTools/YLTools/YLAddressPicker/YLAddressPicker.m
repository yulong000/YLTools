//
//  YLAddressPicker.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLAddressPicker.h"

#define kAddressPickerBackgroundColor          [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define kAddressPickerToolbarBackgroundColor   [UIColor colorWithRed:66.0 / 255 green:155.0 / 255 blue:277.0 / 255 alpha:1]
#define kAddressPickerCancelButtonTitleColor   [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kAddressPickerConfirmButtonTitleColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kAddressPickerContentViewHeight        ([UIScreen mainScreen].bounds.size.height / 3)

#pragma mark - 省

@class YLAddressCityModel;
@interface YLAddressProvinceModel : NSObject

@property (nonatomic, copy)   NSString *province;
@property (nonatomic, strong) NSArray <YLAddressCityModel *> *cities;

@end

@implementation YLAddressProvinceModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cities" : @"YLAddressCityModel"};
}

@end

#pragma mark  市

@class YLAddressDistrictModel;
@interface YLAddressCityModel : NSObject

@property (nonatomic, copy)   NSString *city;
@property (nonatomic, strong) NSArray <YLAddressDistrictModel *> *districts;

@end

@implementation YLAddressCityModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"districts" : @"YLAddressDistrictModel"};
}

@end

#pragma mark 区

@interface YLAddressDistrictModel : NSObject

@property (nonatomic, copy)   NSString *district;
@property (nonatomic, strong) NSArray <NSString *> *streets;

@end

@implementation YLAddressDistrictModel


@end

#pragma mark -


@interface YLAddressPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray <YLAddressProvinceModel *> *dataArr;

/**  记录省市区  */
@property (nonatomic, assign) NSInteger provinceIndex;
@property (nonatomic, assign) NSInteger cityIndex;
@property (nonatomic, assign) NSInteger districtIndex;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, strong) AddressModel *address;
@property (nonatomic, strong) AddressModel *addressTmp;

@property (nonatomic, copy  ) YLAddressPickerHandler handler;

/**  只显示省市  */
@property (nonatomic, assign) BOOL showProvinceAndCity;

@end

@implementation YLAddressPicker
@synthesize cancelButtonTitleColor  = _cancelButtonTitleColor,
            confirmButtonTitleColor = _confirmButtonTitleColor,
            toolbarBackgroundColor  = _toolbarBackgroundColor;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = ClearColor;
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = WhiteColor;
        
        self.toolBar = [[UIView alloc] init];
        self.toolBar.backgroundColor = kAddressPickerToolbarBackgroundColor;
        [self addSubview:self.toolBar];
        
        self.cancelBtn = [[UIButton alloc] init];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:kAddressPickerCancelButtonTitleColor forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:self.cancelBtn];
        
        self.confirmBtn = [[UIButton alloc] init];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:kAddressPickerConfirmButtonTitleColor forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:self.confirmBtn];
        
        [self addSubview:self.pickerView];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        self.dataArr = [YLAddressProvinceModel mj_objectArrayWithKeyValuesArray:arr];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.toolBar.frame = CGRectMake(0, self.height, self.width, 40);
    self.pickerView.frame = CGRectMake(0, self.height + self.toolBar.height, self.width, 200);
    self.cancelBtn.frame = CGRectMake(0, 0, 60, self.toolBar.height);
    self.confirmBtn.frame = CGRectMake(self.width - self.cancelBtn.width, 0, self.cancelBtn.width, self.toolBar.height);
}

- (AddressModel *)address {
    if(_address == nil) {
        _address = [[AddressModel alloc] init];
    }
    return _address;
}

- (void)setAddressTmp:(AddressModel *)addressTmp {
    _addressTmp = addressTmp;
    NSString *province = _addressTmp.province;
    NSString *city = _addressTmp.city;
    NSString *district = _addressTmp.district;
    NSInteger provinceIndex = 0;
    for (int i = 0; i < self.dataArr.count; i ++) {
        YLAddressProvinceModel *model = self.dataArr[i];
        if([model.province isEqualToString:province]) {
            provinceIndex = i;
            break;
        }
    }
    [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    [self pickerView:self.pickerView didSelectRow:provinceIndex inComponent:0];
    
    NSInteger cityIndex = 0;
    for (int i = 0; i < self.dataArr[provinceIndex].cities.count; i ++) {
        YLAddressCityModel *model = self.dataArr[provinceIndex].cities[i];
        if([model.city isEqualToString:city]) {
            cityIndex = i;
            break;
        }
    }
    
    [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
    [self pickerView:self.pickerView didSelectRow:cityIndex inComponent:1];
    if(self.showProvinceAndCity == NO) {
        NSInteger districtIndex = 0;
        for (int i = 0; i < self.dataArr[provinceIndex].cities[cityIndex].districts.count; i ++) {
            YLAddressDistrictModel *model = self.dataArr[provinceIndex].cities[cityIndex].districts[i];
            if([model.district isEqualToString:district]) {
                districtIndex = i;
                break;
            }
        }
        [self.pickerView selectRow:districtIndex inComponent:2 animated:YES];
        [self pickerView:self.pickerView didSelectRow:districtIndex inComponent:2];
    } else {
        self.address.district = @"";
    }
}

+ (instancetype)showAddressPickerWithAddress:(AddressModel *)address handler:(YLAddressPickerHandler)handler {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    YLAddressPicker *pickerView = [[YLAddressPicker alloc] initWithFrame:keyWindow.bounds];
    pickerView.handler = handler;
    pickerView.addressTmp = address;
    [keyWindow addSubview:pickerView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pickerView show];
    });
    return pickerView;
}

+ (instancetype)showProvinceAndCityPickerWithAddress:(AddressModel *)address handler:(YLAddressPickerHandler)handler {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    YLAddressPicker *pickerView = [[YLAddressPicker alloc] initWithFrame:keyWindow.bounds];
    pickerView.handler = handler;
    pickerView.addressTmp = address;
    pickerView.showProvinceAndCity = YES;
    [keyWindow addSubview:pickerView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pickerView show];
    });
    return pickerView;
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.bottom = self.height;
        self.toolBar.bottom = self.pickerView.top;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerView.top = self.height + self.toolBar.height;
        self.toolBar.bottom = self.pickerView.top;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark 取消
- (void)cancel {
    [self hide];
}
#pragma mark 确定
- (void)confirm {
    if(self.showProvinceAndCity) {
        self.address.district = @"";
    }
    if(self.handler) {
        self.handler(self.address);
        YLLog(@"地址选择 : %@ --> %@", self.addressTmp.fullAddress, self.address.fullAddress);
    }
    [self hide];
}

#pragma mark - pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.showProvinceAndCity ? 2 : 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return  self.width / (self.showProvinceAndCity ? 2 : 3);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0)  return self.dataArr.count;
    if(component == 1)  return self.dataArr[self.provinceIndex].cities.count;
    if(component == 2)  return self.dataArr[self.provinceIndex].cities[self.cityIndex].districts.count;
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0) return self.dataArr[row].province;
    if(component == 1) return self.dataArr[self.provinceIndex].cities[row].city;
    if(component == 2) return self.dataArr[self.provinceIndex].cities[self.cityIndex].districts[row].district;
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0) {
        self.provinceIndex = row;
        self.cityIndex = 0;
        self.address.province = self.dataArr[row].province;
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self pickerView:pickerView didSelectRow:0 inComponent:1];
    } else if (component == 1) {
        self.cityIndex = row;
        self.address.city = self.dataArr[self.provinceIndex].cities[row].city;
        if(self.showProvinceAndCity) {
            self.address.district = @"";
            return;
        }
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        [self pickerView:pickerView didSelectRow:0 inComponent:2];
    } else if(component == 2) {
        self.districtIndex = row;
        self.address.district = self.dataArr[self.provinceIndex].cities[self.cityIndex].districts[row].district;
    }
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
        self.toolBar.backgroundColor = _toolbarBackgroundColor;
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

@end

@implementation AddressModel

- (NSString *)fullAddress {
    if(self.province.length && [self.province isEqualToString:self.city]) {
        return [NSString stringWithFormat:@"%@%@", self.province, self.district];
    }
    return [NSString stringWithFormat:@"%@%@%@", self.province, self.city, self.district];
}

@end

