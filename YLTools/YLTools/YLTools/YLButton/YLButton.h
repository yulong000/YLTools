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

/**  图片占比 (上下布局为 高度,  左右布局为宽度)  default = 0.5 */
@property (nonatomic, assign) CGFloat imageViewRatio;

/// 图片和文字的间距, default  = 3
@property (nonatomic, assign) CGFloat seperateGap;


@end

NS_ASSUME_NONNULL_END
