
#import "NSString+bounds.h"

@implementation NSString (bounds)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font {
    return [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size;
}

@end
