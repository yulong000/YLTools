//
//  YLCornerView.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLCornerView : UIView

/// 圆角的位置
@property (nonatomic, assign) UIRectCorner rectCorner;

/// 圆角尺寸
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
