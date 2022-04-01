//
//  PraiseDemoVC.m
//  YLTools
//
//  Created by 魏宇龙 on 2022/2/10.
//  Copyright © 2022 weiyulong. All rights reserved.
//

#import "PraiseDemoVC.h"
#import "YLPraiseButton.h"

@interface PraiseDemoVC ()

@end

@implementation PraiseDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"仿今日头条点赞";
    
    YLPraiseButton *btn = [[YLPraiseButton alloc] init];
    [self.view addSubview:btn];
    
    btn.frame = CGRectMake(200, 300, 40, 40);
}


@end
