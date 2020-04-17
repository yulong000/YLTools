//
//  AddressPickerDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/8/18.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "AddressPickerDemoVC.h"
#import "YLAddressPicker.h"

@interface AddressPickerDemoVC ()

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) AddressModel *address;
@property (nonatomic, strong) AddressModel *addr;

@end

@implementation AddressPickerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    self.addressLabel.font = Font(15);
    self.addressLabel.textColor = BlackColor;
    self.addressLabel.size = CGSizeMake(300, 30);
    self.addressLabel.centerX = self.view.centerPoint.x;
    self.addressLabel.top = kNavTotalHeight + 30;
    [self.view addSubview:self.addressLabel];
    
    __weak typeof(self) weakSelf = self;
    UIButton *addressBtn = [UIButton buttonWithTitle:@"省市区" clickBlock:^(UIButton *button) {
        
        // 显示省市区地址选择器
        YLAddressPicker *addressPicker = [YLAddressPicker showAddressPickerWithAddress:weakSelf.address handler:^(AddressModel * _Nonnull address) {
            weakSelf.address = address;
            weakSelf.addressLabel.text = address.fullAddress;
        }];
        
        // 自定义地址选择器的样式, 非必选
        addressPicker.confirmButtonTitleColor = BlueColor;
        addressPicker.cancelButtonTitleColor = RedColor;
        addressPicker.toolbarBackgroundColor = OrangeColor;
    }];
    
    UIButton *addrBtn = [UIButton buttonWithTitle:@"省市" clickBlock:^(UIButton *button) {
        
        // 显示省市地址选择器
        YLAddressPicker *addressPicker = [YLAddressPicker showProvinceAndCityPickerWithAddress:weakSelf.addr handler:^(AddressModel * _Nonnull address) {
            weakSelf.addr = address;
            weakSelf.addressLabel.text = address.fullAddress;
        }];
        
        // 自定义地址选择器的样式, 非必选
        addressPicker.confirmButtonTitleColor = BlueColor;
        addressPicker.cancelButtonTitleColor = RedColor;
        addressPicker.toolbarBackgroundColor = OrangeColor;
    }];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:addressBtn],
                                                [[UIBarButtonItem alloc] initWithCustomView:addrBtn]];
}


@end
