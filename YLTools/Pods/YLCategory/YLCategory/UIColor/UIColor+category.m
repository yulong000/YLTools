#import "UIColor+category.h"

@implementation UIColor (category)

#pragma mark 随机颜色
+ (UIColor *)randomColor {
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
    return randColor;
}

#pragma mark 16进制 -> 颜色
+ (UIColor *)colorWithHex:(UInt32)hex {
    return [UIColor colorWithHex:hex andAlpha:1];
}
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((hex >> 16) & 0xFF) / 255.0
                           green:((hex >> 8) & 0xFF) / 255.0
                            blue:(hex & 0xFF) / 255.0
                           alpha:alpha];
}

#pragma mark 获取某个颜色设置透明度后的颜色
+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    if(color == nil)    return nil;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:MAX(0, MIN(alpha, 1))];
}

/**
 *  生成颜色数值
 *
 *  @param string 16进制字符串
 *  @param start  起始位置
 *  @param length 长度
 *
 *  @return 颜色数值
 */
CGFloat colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    // 从16进制字符串中扫描一个无符号整型数值
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

#pragma mark 16进制字符串 -> 颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 1);
            green = colorComponentFrom(colorString, 1, 1);
            blue  = colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = colorComponentFrom(colorString, 0, 1);
            red   = colorComponentFrom(colorString, 1, 1);
            green = colorComponentFrom(colorString, 2, 1);
            blue  = colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = colorComponentFrom(colorString, 0, 2);
            green = colorComponentFrom(colorString, 2, 2);
            blue  = colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = colorComponentFrom(colorString, 0, 2);
            red   = colorComponentFrom(colorString, 2, 2);
            green = colorComponentFrom(colorString, 4, 2);
            blue  = colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
