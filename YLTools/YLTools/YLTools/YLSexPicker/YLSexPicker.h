//
//  YLSexPicker.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YLPersonSex) {
    YLPersonSexMan,              // 男
    YLPersonSexWoman,            // 女
};

typedef  void(^YLSexPickerHandler)(YLPersonSex sex);


@interface YLSexPicker : UIView


@property (nonatomic, strong) UIColor *toolbarBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIColor *confirmButtonTitleColor;
@property (nonatomic, strong) UIColor *titleColor;

+ (instancetype)showSexPickerWithSex:(YLPersonSex)sex handler:(YLSexPickerHandler)handler;


@end

NS_ASSUME_NONNULL_END
