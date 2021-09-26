#import <UIKit/UIKit.h>

typedef void (^UIButtonClickedBlock)(UIButton *button);

@interface UIButton (block)

/**
 点击回调
 */
@property (nonatomic, copy)   UIButtonClickedBlock clickedBlock;


/// 创建button
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithClickBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置正常状态下的title
/// @param title title
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithTitle:(NSString *)title clickBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置正常状态下的image
/// @param image image
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithImage:(UIImage *)image clickBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置正常状态下的image, 和选中状态下的image
/// @param image 正常状态下的image
/// @param selectedImage 选中状态下的image
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage clickBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置正常状态下的 title 和 image
/// @param title title
/// @param image image
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image clickBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置正常状态下 backgroundImage
/// @param backgroundImage backgroundImage
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithBackgroundImage:(UIImage *)backgroundImage clickBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置正常状态下title 和 backgroundImage
/// @param title title
/// @param backgroundImage backgroundImage
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置纯色的 backgroundImage, 圆角
/// @param title title
/// @param bgImageColor backgroundImage 的颜色
/// @param cornerRadius 圆角
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithTitle:(NSString *)title backgroundImageCorlor:(UIColor *)bgImageColor cornerRadius:(CGFloat)cornerRadius clickBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置正常状态下的 title, titleColor, font
/// @param title title
/// @param titleColor titleColor
/// @param font font
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font clickedBlock:(UIButtonClickedBlock)clickedBlock;


/// 创建button, 设置正常状态下的 title, titleColor, font, 纯色的背景图. 圆角
/// @param title title
/// @param titleColor titleColor
/// @param font font
/// @param bgImageColor backgroundImage 的颜色
/// @param cornerRadius 圆角
/// @param clickedBlock 点击回调
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundImageCorlor:(UIColor *)bgImageColor cornerRadius:(CGFloat)cornerRadius clickedBlock:(UIButtonClickedBlock)clickedBlock;


/// button只有title时根据title设置button的size,
/// @param padding title 左右的间距
/// @param fixHeight 固定高度, 传0则自适应
- (CGSize)sizeWithTitlePadding:(CGFloat)padding fixHeight:(CGFloat)fixHeight;

@end
