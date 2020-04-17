//
//  YLDatePicker.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YLDatePickerHandlerType) {
    YLDatePickerHandlerTypeCancel,              // 取消
    YLDatePickerHandlerTypeConfirm,             // 确定
};

typedef  void(^YLDatePickerHandler)(YLDatePickerHandlerType handlerType, NSDate *_Nullable date);

@interface YLDatePicker : UIView

@property (nonatomic, readonly) UIDatePicker *datePicker;

@property (nonatomic, strong) UIColor *toolbarBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIColor *confirmButtonTitleColor;

+ (instancetype)showDatePickerWithMode:(UIDatePickerMode)mode handler:(YLDatePickerHandler)handler;


@end

NS_ASSUME_NONNULL_END
