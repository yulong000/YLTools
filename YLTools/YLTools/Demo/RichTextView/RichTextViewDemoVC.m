//
//  RichTextViewDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/11/7.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "RichTextViewDemoVC.h"
#import "YLRichTextView.h"

@interface RichTextViewDemoVC ()

@end

@implementation RichTextViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLRichTextView *textView = [[YLRichTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    textView.content = @"<p>张家港未来最大的生态园——黄泗浦生态园,正在紧锣密鼓地建设中。</p><p><img src=\"http://www.zjghsp.com.cn/HSPMana/res/ueditor/net/upload/image/20190531/6369489334412225251456258.png\" title=\"image.png\" alt=\"image.png\"/></p><p>生态园简介</p><p>黄泗浦生态园是苏州市生态文明建设的“十大工程”之一,也是苏州市“十大郊野公园”之一。</p><p>生态园位于杨舍镇与塘桥镇城市发展轴中间,规划面积为17.7平方公里。先行启动的是核心区的建设,核心区规划面积为4.7平方公里,其中园内生态绿地面积达3125亩,水域总面积达2160亩,其中西湖水域面积约1000亩,东湖水域面积约600亩。</p>";
    textView.heightChangedBlock = ^(CGFloat height, YLRichTextView *textView) {
        textView.height = height;
        YLLog(@"高度发生变化 : %f", height);
    };
    [self.view addSubview:textView];
}


@end
