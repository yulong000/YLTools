//
//  YLOAuthLoginTools.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLOAuthLoginTools.h"
#import <WXApi.h>

@interface YLOAuthLoginTools () <WXApiDelegate>

@property (nonatomic, copy  ) YLOAuthLoginHandler handler;

@end

@implementation YLOAuthLoginTools

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static YLOAuthLoginTools *tools = nil;
    dispatch_once(&onceToken, ^{
        tools = [[YLOAuthLoginTools alloc] init];
    });
    return tools;
}

+ (void)loginWithWechatHandler:(YLOAuthLoginHandler)handler {
    if(![WXApi isWXAppInstalled]) {
        // 未安装微信客户端
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您未安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:sure];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        return ;
    }
    [YLOAuthLoginTools shareInstance].handler = handler;
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"wechat_login";
    [WXApi sendReq:req completion:nil];
}

#pragma mark - 微信回调
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 登录回调
        SendAuthResp *auth = (SendAuthResp *)resp;
        NSString *code = auth.code;
        switch (auth.errCode) {
            case WXSuccess: {
                // 成功
                if(self.handler) {
                    self.handler(YES, code);
                }
            }
                break;
            case WXErrCodeAuthDeny: {
                // 拒绝
                if(self.handler) {
                    self.handler(NO, code);
                }
            }
                break;
            case WXErrCodeUserCancel: {
                // 取消
                if(self.handler) {
                    self.handler(NO, code);
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark 回调
+ (BOOL)openUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[YLOAuthLoginTools shareInstance]];
}

@end
