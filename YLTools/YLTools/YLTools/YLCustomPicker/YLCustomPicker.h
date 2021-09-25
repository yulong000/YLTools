//
//  YLCustomPicker.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YLCustomPickerHandler)(NSString *item, NSInteger index);

@interface YLCustomPicker : UIView

@property (nonatomic, strong) UIColor *toolbarBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIColor *confirmButtonTitleColor;
@property (nonatomic, strong) UIColor *titleColor;

+ (instancetype)showCustomPickerWithTitle:(NSString * _Nullable)title
                                  itemArr:(NSArray <NSString *> *)itemArr
                               selectItem:(NSString * _Nullable)item
                                   handler:(YLCustomPickerHandler _Nullable)handler;

+ (NSMutableArray *)itemsWithModelArr:(NSArray *)modelArr displayProperty:(NSString *)displayProperty;

@end

NS_ASSUME_NONNULL_END
