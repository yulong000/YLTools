#import <UIKit/UIKit.h>

@interface UIColor (category)

/**
 随机色
 */
+ (UIColor *)randomColor;

/**
 *  由16进制颜色字符串格式生成UIColor
 *
 *  @param hexString 16进制颜色#00FF00
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;


/**
 获取某个颜色设置透明度后的颜色

 @param color 原有的颜色
 @param alpha 在原有颜色的基础上设置透明度
 @return 返回需要的颜色
 */
+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha;

@end
