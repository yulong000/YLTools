//
//  YLPaymentTools.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 支付回调状态
typedef NS_ENUM(NSInteger, YLPaymentResult) {
    YLPaymentResultSuccess,         // 支付成功
    YLPaymentResultCancel,          // 取消支付
    YLPaymentResultNetworkError,    // 网络错误
    YLPaymentResultOtherError       // 其他错误
};


// 支付渠道
typedef NS_ENUM(NSInteger, YLPaymentChannel) {
    YLPaymentChannelWX,         // 微信支付
    YLPaymentChannelALI,        // 支付宝支付
    YLPaymentChannelUnion,      // 银联支付
};


/**  支付回调结果 */
typedef void (^YLPaymentResultBlock)(YLPaymentResult result, YLPaymentChannel channel);


@interface YLPaymentTools : NSObject

/**
 支付 （包含微信和支付宝）
 
 @param payCharge 后台返回的payCharge
 
 🖕🖕🖕 注: 支付宝支付的 CFBundleURLName = alipay,如果不一致,请修改一致
 */
+ (void)payWithPayChargeParams:(id)payCharge resultBlock:(YLPaymentResultBlock)resultBlock;

/**
 支付后跳转回APP
 在 AppDelegate 中添加此代码
     - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
        return [YLPaymentTools openUrl:url];
     }
 */
+ (BOOL)openUrl:(NSURL *)url;


@end

NS_ASSUME_NONNULL_END
