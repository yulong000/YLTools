#import <Foundation/Foundation.h>

@interface NSObject (category)

/**  长度不为0的字符串  */
- (BOOL)isValidString;

/**  是否是 [NSNull null]  */
- (BOOL)isNull;

@end
