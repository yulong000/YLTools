//
//  YLPaymentTools.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLPaymentTools.h"
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>

@interface YLPaymentTools () <WXApiDelegate>

@property (nonatomic, copy) YLPaymentResultBlock resultBlock;

@end

@implementation YLPaymentTools

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static YLPaymentTools *tools = nil;
    dispatch_once(&onceToken, ^{
        tools = [[YLPaymentTools alloc] init];
    });
    return tools;
}

#pragma mark 支付
+ (void)payWithPayChargeParams:(NSDictionary *)payCharge resultBlock:(YLPaymentResultBlock)resultBlock {
    YLPaymentTools *tools = [YLPaymentTools shareInstance];
    tools.resultBlock = resultBlock;
    if ([payCharge isKindOfClass:[NSString class]] && [(NSString *)payCharge containsString:@"alipay"]) {
        //支付宝支付
        //获取App Scheme
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
        NSArray *array = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"CFBundleURLTypes"];
        NSString *appScheme;
        for (NSDictionary *dict in array) {
            if ([dict[@"CFBundleURLName"] isEqualToString:@"alipay"]) {
                appScheme = [dict[@"CFBundleURLSchemes"] firstObject];
                break;
            }
        }
        // 发起支付宝支付
        [[AlipaySDK defaultService] payOrder:(NSString *)payCharge fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            [tools showAliPayResultWithResultDic:resultDic];
        }];
    } else if([payCharge isKindOfClass:[NSDictionary class]] && payCharge[@"appid"] != nil) {
        // 微信支付
        if(![WXApi isWXAppInstalled]) {
            // 未安装微信客户端
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您未安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:sure];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            return ;
        }
        //发起微信支付
        PayReq* req   = [[PayReq alloc] init];
        req.partnerId = payCharge[@"partnerid"];
        req.prepayId  = payCharge[@"prepayid"];
        req.nonceStr  = payCharge[@"noncestr"];
        req.timeStamp = [payCharge[@"timestamp"] intValue];
        req.package   = payCharge[@"package"];
        req.sign      = payCharge[@"sign"];
        [WXApi sendReq:req completion:nil];
    }
}

#pragma mark 支付回调
+ (BOOL)openUrl:(NSURL *)url {
    // 支付宝客户端
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[YLPaymentTools shareInstance] showAliPayResultWithResultDic:resultDic];
        }];
        return YES;
    }
    // 支付宝网页版
    if ([url.host isEqualToString:@"platformapi"]) {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[YLPaymentTools shareInstance] showAliPayResultWithResultDic:resultDic];
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:[YLPaymentTools shareInstance]];
}

#pragma mark 支付宝支付结果回调
- (void)showAliPayResultWithResultDic:(NSDictionary *)resultDic {
    NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
    if(self.resultBlock) {
        switch (resultStatus) {
            case 9000:      // 支付成功
                self.resultBlock(YLPaymentResultSuccess, YLPaymentChannelALI);
                YLLog(@"支付宝支付成功");
                break;
            case 6001:      // 用户中途取消
                self.resultBlock(YLPaymentResultCancel, YLPaymentChannelALI);
                YLLog(@"支付宝支付已取消");
                break;
            case 6002:      // 网络连接错误
                self.resultBlock(YLPaymentResultNetworkError, YLPaymentChannelALI);
                YLLog(@"支付宝支付网络错误");
                break;
            default:        // 其他的支付失败
                self.resultBlock(YLPaymentResultOtherError, YLPaymentChannelALI);
                YLLog(@"支付宝支付发生错误");
                break;
        }
    }
}

#pragma mark - 微信支付回调
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        // 微信终端返回给第三方的关于支付结果的结构体
        PayResp *response = (PayResp *)resp;
        YLPaymentTools *tools = [YLPaymentTools shareInstance];
        if(tools.resultBlock) {
            switch (response.errCode) {
                case WXSuccess:             // 支付成功
                    tools.resultBlock(YLPaymentResultSuccess, YLPaymentChannelWX);
                    YLLog(@"微信支付成功");
                    break;
                case WXErrCodeSentFail:     // 发送失败
                    tools.resultBlock(YLPaymentResultNetworkError, YLPaymentChannelWX);
                    YLLog(@"微信支付失败");
                    break;
                case WXErrCodeUserCancel:   // 用户点击取消
                    tools.resultBlock(YLPaymentResultCancel, YLPaymentChannelWX);
                    YLLog(@"微信支付已取消");
                    break;
                default:                    // 其他的支付失败
                    tools.resultBlock(YLPaymentResultOtherError, YLPaymentChannelWX);
                    YLLog(@"微信支付发生错误");
                    break;
            }
        }
    }
}

@end
