//
//  DashLineDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/8/14.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "DashLineDemoVC.h"
#import "YLDashLineView.h"

@interface DashLineDemoVC ()

@end

@implementation DashLineDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLDashLineView *line1 = [[YLDashLineView alloc] init];
    line1.size = CGSizeMake(self.view.width, 2);
    line1.top = 150;
    [self.view addSubview:line1];
    
    YLDashLineView *line2 = [[YLDashLineView alloc] init];
    line2.size = CGSizeMake(self.view.width, 5);
    line2.top = 180;
    line2.lineColor = RedColor;
    line2.lineWidth = 3;
    [self.view addSubview:line2];
    
    YLDashLineView *line3 = [[YLDashLineView alloc] init];
    line3.size = CGSizeMake(self.view.width, 10);
    line3.top = 210;
    line3.lineDash = 10;
    line3.spaceDash = 10;
    line3.lineWidth = 10;
    line3.lineColor = GreenColor;
    [self.view addSubview:line3];
    
    YLDashLineView *line4 = [[YLDashLineView alloc] init];
    line4.size = CGSizeMake(self.view.width, 2);
    line4.top = 240;
    line4.spaceDash = 10;
    line4.lineDash = 5;
    [self.view addSubview:line4];
}


@end
