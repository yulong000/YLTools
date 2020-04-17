//
//  AppDelegate.m
//  YLTools
//
//  Created by weiyulong on 2020/4/6.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YLPaymentTools.h"
#import "YLOAuthLoginTools.h"
#import <WXApi.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:@"" universalLink:@""];
    [AMapServices sharedServices].apiKey = @"b61e2a98bb1f20168ee610217b153f80";
    
    // 友盟
    [UMConfigure initWithAppkey:@"5d44f5260cafb27ea4000922" channel:nil];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxeb5335a24d2af0c6" appSecret:@"eda31dc6541b77ef241f1a3f6a9832d7" redirectURL:@"https://www.baidu.com"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954" appSecret:@"bb6c37b6f0c7f324e288fdacdc52217a" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101659399"  appSecret:@"101659399" redirectURL:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]) {
        if([url.absoluteString containsString:@"oauth"]) {
            return [YLOAuthLoginTools openUrl:url];
        }
        return [YLPaymentTools openUrl:url];
    }
    if([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.alipay.iphoneclient"]) {
        return [YLPaymentTools openUrl:url];
    }
    return YES;
}


@end
