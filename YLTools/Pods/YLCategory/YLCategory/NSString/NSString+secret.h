//
//  NSString+secret.h
//  YLCategory
//
//  Created by weiyulong on 2018/10/29.
//  Copyright © 2018 WYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (secret)

/**  MD5 小写 加密 */
- (NSString *)MD5_lower;

/**  MD5 大写 加密  */
- (NSString *)MD5_upper;

@end

NS_ASSUME_NONNULL_END
