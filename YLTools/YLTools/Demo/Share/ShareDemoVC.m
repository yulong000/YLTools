//
//  ShareDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/9/6.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "ShareDemoVC.h"
#import "YLShareView.h"

@interface ShareDemoVC ()


@end

@implementation ShareDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *addressBtn = [UIButton buttonWithTitle:@"分享" clickBlock:^(UIButton *button) {
        [YLShareView shareWithTitle:@"分享的标题" desc:@"分享的小标题" thumbImage:[UIImage imageNamed:@"share_circle"] webpageUrl:@"http://www.baidu.com" resultHandler:^(BOOL success) {
            YLLog(@"分享结果: %d", success);
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addressBtn];
}


@end
