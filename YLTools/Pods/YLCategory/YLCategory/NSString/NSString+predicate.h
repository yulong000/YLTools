
#import <Foundation/Foundation.h>

@interface NSString (predicate)

/**
 *  手机号有效性
 */
- (BOOL)isMobileNumber;

/**
 *  邮箱的有效性
 */
- (BOOL)isEmailAddress;

/**
 *  简单的身份证有效性
 *
 */
- (BOOL)isIdentityCardNumForHazy;

/**
 *  精确的身份证号码有效性检测
 *
 */
- (BOOL)isIdentityCardNum;

/**
 *  车牌号的有效性
 */
- (BOOL)isCarNumber;

/**
 *  银行卡的有效性
 */
- (BOOL)bankCardluhmCheck;

/**
 纯数字
 */
- (BOOL)isNumberText;

/**
  价格字符串, 保留2位小数
 */
- (BOOL)isPriceText;

@end
