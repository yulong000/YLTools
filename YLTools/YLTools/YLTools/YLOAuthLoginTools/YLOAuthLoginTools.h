//
//  YLOAuthLoginTools.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 登录后的回调, success 是否成功, code : 状态码
typedef void (^YLOAuthLoginHandler)(BOOL success, NSString *code);

@interface YLOAuthLoginTools : NSObject

/**  微信登录  */
+ (void)loginWithWechatHandler:(YLOAuthLoginHandler)handler;

/**  登录回调
     在 AppDelegate 中添加此代码
         - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
             return [YLOAuthLoginTools openUrl:url];
         }
 */
+ (BOOL)openUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
