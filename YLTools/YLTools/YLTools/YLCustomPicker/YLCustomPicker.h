//
//  YLCustomPicker.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YLCustomPickerHandler)(NSString *title, NSInteger index);

@interface YLCustomPicker : UIView

@property (nonatomic, strong) UIColor *toolbarBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIColor *confirmButtonTitleColor;

+ (instancetype)showCustomPickerWithTitles:(NSArray <NSString *> *)titles
                               selectTitle:(NSString * _Nullable)title
                                   handler:(YLCustomPickerHandler _Nullable)handler;



@end

NS_ASSUME_NONNULL_END
