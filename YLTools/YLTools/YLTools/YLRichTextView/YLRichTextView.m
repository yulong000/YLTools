//
//  YLRichTextView.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLRichTextView.h"

@interface YLRichTextView () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
/**  是否完成加载  */
@property (nonatomic, assign) BOOL finish;


@end

@implementation YLRichTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.scrollView.bounces = NO;
        self.webView.userInteractionEnabled = NO;
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.backgroundColor = ClearColor;
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:self.webView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.width = self.width;
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentSize"] && self.finish) {
        [self refreshHeight];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='220%'";
    [self.webView stringByEvaluatingJavaScriptFromString:str];
    self.finish = YES;
    [self refreshHeight];
}

- (void)refreshHeight {
    if(self.webView.height == self.webView.scrollView.contentSize.height) return;
    self.webView.height = self.webView.scrollView.contentSize.height;
    if(self.heightChangedBlock) {
        self.heightChangedBlock(self.webView.height, self);
    }
}

- (void)setContent:(NSString *)content {
    NSString *htmlStr = [NSString stringWithFormat:@"<div style=\"font-size:20px;line-height:2.0 !important\">%@</div>", content];
    if([_content isEqualToString:htmlStr] == NO) {
        _content = [htmlStr copy];
        [self.webView loadHTMLString:_content baseURL:nil];
    }
}

@end
