//
//  TextViewDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/10/8.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "TextViewDemoVC.h"
#import "YLTextView.h"

@interface TextViewDemoVC ()

@end

@implementation TextViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLTextView *textView1 = [[YLTextView alloc] initWithFrame:CGRectMake(20, 100, 150, 150)];
    textView1.layer.borderColor = BlackColor.CGColor;
    textView1.layer.borderWidth = 1;
    textView1.font = Font(20);
    textView1.textColor = BlueColor;
    textView1.placeholder = @"最多20个字";
    textView1.maxLength = 20;
    textView1.showTextLength = YES;
    [self.view addSubview:textView1];
    
    YLTextView *textView2 = [[YLTextView alloc] initWithFrame:CGRectMake(200, 100, 150, 150)];
    textView2.layer.borderColor = BlackColor.CGColor;
    textView2.layer.borderWidth = 3;
    textView2.font = Font(12);
    textView2.textColor = RedColor;
    textView2.placeholder = @"不限制输入";
    textView2.text = @"已经输入的字符";
    [self.view addSubview:textView2];
    
    YLTextView *textView3 = [[YLTextView alloc] initWithFrame:CGRectMake(20, 270, 150, 150)];
    textView3.layer.borderColor = BlackColor.CGColor;
    textView3.layer.borderWidth = 1;
    textView3.font = Font(15);
    textView3.textColor = GreenColor;
    textView3.placeholder = @"最多10个字";
    textView3.maxLength = 10;
    textView3.text = @"已经输入的字符超过了最多的10个字";
    [self.view addSubview:textView3];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
