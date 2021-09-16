//
//  ButtonDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/10/6.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "ButtonDemoVC.h"
#import "YLButton.h"

@interface ButtonDemoVC ()

@end

@implementation ButtonDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLButton *btn1 = [[YLButton alloc] initWithFrame:CGRectMake(100, 100, 150, 40)];
    [btn1 setTitle:@"默认样式" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"share_link"] forState:UIControlStateNormal];
    btn1.layoutMode = YLButtonLayoutModeDefault;
    btn1.backgroundColor = RedColor;
    [self.view addSubview:btn1];
    
    YLButton *btn2 = [[YLButton alloc] initWithFrame:CGRectMake(100, 150, 150, 40)];
    [btn2 setTitle:@"默认样式1" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"share_circle"] forState:UIControlStateNormal];
    btn2.layoutMode = YLButtonLayoutModeDefault;
    btn2.imgViewSize = CGSizeMake(20, 20);
    btn2.backgroundColor = BlueColor;
    [self.view addSubview:btn2];
    
    YLButton *btn3 = [[YLButton alloc] initWithLayout:YLButtonLayoutModeImageViewRight imgViewSize:CGSizeMake(30, 30)];
    [btn3 setTitle:@"字左图右" forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
    btn3.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn3.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    btn3.backgroundColor = GrayColor;
    btn3.frame = CGRectMake(100, 200, 80, 40);
    [self.view addSubview:btn3];
    
    YLButton *btn4 = [[YLButton alloc] initWithFrame:CGRectMake(100, 250, 80, 150)];
    [btn4 setTitle:@"字上图下" forState:UIControlStateNormal];
    [btn4 setImage:[UIImage imageNamed:@"share_qqZone"] forState:UIControlStateNormal];
    btn4.layoutMode = YLButtonLayoutModeImageViewBottom;
    btn4.imgViewSize = CGSizeMake(20, 20);
    btn4.backgroundColor = GreenColor;
    [self.view addSubview:btn4];
    
    YLButton *btn5 = [[YLButton alloc] initWithFrame:CGRectMake(100, 450, 80, 100)];
    [btn5 setTitle:@"图上字下" forState:UIControlStateNormal];
    [btn5 setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];
    btn5.layoutMode = YLButtonLayoutModeImageViewTop;
    btn5.imgViewSize = CGSizeMake(20, 20);
    btn5.backgroundColor = OrangeColor;
    [self.view addSubview:btn5];
}

@end
