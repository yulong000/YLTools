#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (category)

/**  移除所有的子控件  */
- (void)removeAllSubviews;

/**  添加一组子控件  */
- (void)addSubViewsFromArray:(NSArray *)subViews;

/**  获取view所在的controller  */
- (nullable UIViewController *)controller;

/**  设置边框  */
- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**  设置圆角  */
- (void)setCornerRadius:(CGFloat)cornerRadius;

/**  设置边框和圆角  */
- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
