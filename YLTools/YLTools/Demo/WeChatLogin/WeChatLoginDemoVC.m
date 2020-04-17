//
//  WeChatLoginDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/8/12.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "WeChatLoginDemoVC.h"
#import "YLOAuthLoginTools.h"

@interface WeChatLoginDemoVC ()

@end

@implementation WeChatLoginDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.font = Font(15);
    resultLabel.size = CGSizeMake(200, 30);
    resultLabel.centerX = self.view.width / 2;
    resultLabel.top = 100;
    [self.view addSubview:resultLabel];
    
    UIButton *dateBtn = [UIButton buttonWithTitle:@"微信登录" clickBlock:^(UIButton *button) {
        [YLOAuthLoginTools loginWithWechatHandler:^(BOOL success, NSString * _Nonnull code) {
            if(success) {
                // 登录成功
                resultLabel.text = [NSString stringWithFormat:@"登录成功! code : %@", code];
            } else {
                // 登录失败
                resultLabel.text = [NSString stringWithFormat:@"登录失败! code : %@", code];
            }
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dateBtn];
    
}

@end
