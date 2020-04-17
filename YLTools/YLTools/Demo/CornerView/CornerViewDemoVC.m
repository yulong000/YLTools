//
//  CornerViewDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/10/10.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "CornerViewDemoVC.h"
#import "YLCornerView.h"

@interface CornerViewDemoVC ()

@end

@implementation CornerViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLCornerView *view1 = [[YLCornerView alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
    view1.backgroundColor = RedColor;
    view1.cornerRadius = 5;
    view1.rectCorner = UIRectCornerAllCorners;
    [self.view addSubview:view1];
    
    YLCornerView *view2 = [[YLCornerView alloc] init];
    view2.backgroundColor = BlueColor;
    view2.cornerRadius = 20;
    view2.rectCorner = UIRectCornerAllCorners;
    [self.view addSubview:view2];
    view2.frame = CGRectMake(150, 100, 100, 50);
    
    YLCornerView *view3 = [[YLCornerView alloc] initWithFrame:CGRectMake(20, 200, 100, 50)];
    view3.backgroundColor = GreenColor;
    view3.cornerRadius = 10;
    view3.rectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    [self.view addSubview:view3];
    
    YLCornerView *view4 = [[YLCornerView alloc] initWithFrame:CGRectMake(150, 200, 100, 50)];
    view4.backgroundColor = RedColor;
    view4.cornerRadius = 25;
    view4.rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight;
    [self.view addSubview:view4];
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(20, 300, 100, 50)];
    view5.layer.cornerRadius = 10;
    view5.clipsToBounds = YES;
    view5.backgroundColor = BlackColor;
    [self.view addSubview:view5];
}


@end
