//
//  YLDashLineView.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDashLineDefaultColor [UIColor grayColor]

NS_ASSUME_NONNULL_BEGIN

@interface YLDashLineView : UIView

/**  间隔线的颜色 default = 灰色  */
@property (nonatomic, strong) UIColor *lineColor;

/**  间隔线的线宽 default = 1  */
@property (nonatomic, assign) CGFloat lineWidth;

/**  间隔线的实线部分的宽度 default = 2 */
@property (nonatomic, assign) CGFloat lineDash;

/**  间隔线的虚线部分的宽度 default = 2 */
@property (nonatomic, assign) CGFloat spaceDash;

@end

NS_ASSUME_NONNULL_END
