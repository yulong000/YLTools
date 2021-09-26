
#import <UIKit/UIKit.h>

typedef void (^UILabelClickedBlock)(UILabel *label);

@interface UILabel (category)

/**  添加点击事件  */
@property (nonatomic, copy) UILabelClickedBlock clickedBlock;

/**
 获取label的size, 文字自适应, 不限高度

 @param maxWidth 最大的宽度
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth;

/**
 获取label的size, 文字自适应
 
 @param maxWidth 最大的宽度
 @param lines 行数
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)lines;

/**
 获取label的size, 文字自适应, 不限高度 
 
 @param maxWidth 最大的宽度
 @param attributes 文字属性
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth attributes:(NSDictionary *)attributes;


/**
 获取label的size, 文字自适应

 @param maxWidth 最大的宽度
 @param lines 行数
 @param attributes 文字属性
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)lines attributes:(NSDictionary *)attributes;

/**
 获取label的size, 文字自适应

 @param fixedHeight 固定高度
 */
- (CGSize)sizeWithSingleLineFixedHeight:(CGFloat)fixedHeight;

/**
 获取label的size, 文字自适应

 @param fixedHeight 固定高度
 */
- (CGSize)sizeWithSingleLineMaxWidth:(CGFloat)maxWidth fixedHeight:(CGFloat)fixedHeight;

/// 设置label的size,文字自适应, 文本居中
/// @param padding 文字左右留的间距
/// @param fixedHeight label设置的固定高度
- (CGSize)sizeWithSingleLineAutoWidthWithPadding:(CGFloat)padding fixedHeight:(CGFloat)fixedHeight;


/// 设置label的size,文字自适应
/// @param padding 文字左右留的间距
/// @param minWidth 最小的label宽度
/// @param fixedHeight label设置的固定高度
- (CGSize)sizeWithSingleLineAutoWidthWithPadding:(CGFloat)padding minWidth:(CGFloat)minWidth fixedHeight:(CGFloat)fixedHeight;


/// 快捷创建Label
/// @param font 字号
+ (instancetype)labelWithFont:(UIFont *)font;


/// 快捷创建Label
/// @param font 字号
/// @param textColor 字体颜色
+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;


/// 快捷创建Label
/// @param font 字号
/// @param textColor 字体颜色
/// @param alignment 对齐方式
+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment;

/// 快速创建Label
/// @param text 文本
/// @param textColor 文本颜色
/// @param font 字号
+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;


/// 快速创建Label
/// @param text 文本
/// @param textColor 文本颜色
/// @param alignment 对齐方式
/// @param font 字号
+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment font:(UIFont *)font;

@end
