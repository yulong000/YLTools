//
//  YLButton.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YLButtonLayoutMode) {
    YLButtonLayoutModeDefault,              // 图左字右
    YLButtonLayoutModeImageViewRight,       // 图右字左
    YLButtonLayoutModeImageViewTop,         // 图上字下
    YLButtonLayoutModeImageViewBottom,      // 图下字上
};

NS_ASSUME_NONNULL_BEGIN

@interface YLButton : UIButton

/** 布局方式  */
@property (nonatomic, assign) YLButtonLayoutMode layoutMode;
/// 图片的大小, 默认, 设置 imageEdgeInsets和titleEdgeInsets来改变上下左右的间距
@property (nonatomic, assign) CGSize imgViewSize;

- (instancetype)initWithLayout:(YLButtonLayoutMode)layout imgViewSize:(CGSize)size;
+ (instancetype)buttonWithLayout:(YLButtonLayoutMode)layout imgViewSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
