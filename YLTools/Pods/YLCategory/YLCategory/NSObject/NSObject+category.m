#import "NSObject+category.h"

@implementation NSObject (category)

#pragma mark 是否是长度不为0的字符串
- (BOOL)isValidString {
    if([self isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)self;
        return str.length > 0;
    }
    return NO;
}

#pragma mark 是否是 [NSNull null]
- (BOOL)isNull {
    return [self isKindOfClass:[NSNull class]];
}

@end
