#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (category)

/**  长度不为0的字符串  */
- (BOOL)isValidString;

/**  是否是 [NSNull null]  */
- (BOOL)isNull;

/// 获取显示在最上面的控制器
+ (UIViewController *)topVc;

/// 获取缓存大小
+ (NSString *)getCacheInfo;
/// 清除缓存
+ (void)clearCache;

@end
