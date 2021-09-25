//
//  YLDatePicker.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef  void(^YLDatePickerHandler)(NSDate *date);

@interface YLDatePicker : UIView

@property (nonatomic, readonly) UIDatePicker *datePicker;

@property (nonatomic, strong) UIColor *toolbarBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIColor *confirmButtonTitleColor;
@property (nonatomic, strong) UIColor *titleColor;

+ (instancetype)showDatePickerWithMode:(UIDatePickerMode)mode
                               handler:(YLDatePickerHandler)handler;

+ (instancetype)showDatePickerWithTitle:(nullable NSString *)title
                             selectDate:(nullable NSDate *)selectDate
                                handler:(YLDatePickerHandler)handler;

+ (instancetype)showDatePickerWithTitle:(nullable NSString *)title
                                   mode:(UIDatePickerMode)mode
                             selectDate:(nullable NSDate *)selectDate
                                handler:(YLDatePickerHandler)handler;
            
+ (instancetype)showDatePickerWithTitle:(nullable NSString *)title
                                   mode:(UIDatePickerMode)mode
                             selectDate:(nullable NSDate *)selectDate
                                minDate:(nullable NSDate *)minDate
                                maxDate:(nullable NSDate *)maxDate
                                handler:(YLDatePickerHandler)handler;


@end

NS_ASSUME_NONNULL_END
