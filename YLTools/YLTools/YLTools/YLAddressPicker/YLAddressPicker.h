//
//  YLAddressPicker.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressModel;
typedef  void(^YLAddressPickerHandler)(AddressModel *address);

@interface YLAddressPicker : UIView

@property (nonatomic, strong) UIColor *toolbarBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIColor *confirmButtonTitleColor;
@property (nonatomic, strong) UIColor *titleColor;

/**  选择省市区  */
+ (instancetype)showAddressPickerWithAddress:(AddressModel * _Nullable)address handler:(YLAddressPickerHandler _Nullable)handler;

/**  选择省市  */
+ (instancetype)showProvinceAndCityPickerWithAddress:(AddressModel * _Nullable)address handler:(YLAddressPickerHandler _Nullable)handler;

@end

@interface AddressModel : NSObject

/**  省  */
@property (nonatomic, copy)   NSString *province;
/**  市  */
@property (nonatomic, copy)   NSString *city;
/**  区, 选择省市的时候, 该字段为@""  */
@property (nonatomic, copy)   NSString *district;

/**  省市区  */
- (NSString *)fullAddress;

@end

NS_ASSUME_NONNULL_END
