//
//  YLShadowView.h
//  TaoZhao
//
//  Created by weiyulong on 2020/6/28.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLShadowView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;

/// 上下左右的边距   default =  UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

NS_ASSUME_NONNULL_END
