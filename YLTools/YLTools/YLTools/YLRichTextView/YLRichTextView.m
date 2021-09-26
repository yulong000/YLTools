//
//  YLRichTextView.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLRichTextView.h"

@interface YLRichTextView () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL finish;


@end

@implementation YLRichTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.autoHeight = YES;
        [self addSubview:self.webView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.width = self.width;
    if(self.autoHeight == NO) {
        self.webView.height = self.height;
    }
}

- (void)setAutoHeight:(BOOL)autoHeight {
    _autoHeight = autoHeight;
    self.webView.scrollView.scrollEnabled = !autoHeight;
}

#pragma mark 加载完毕,计算高度
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.body.scrollHeight;" completionHandler:^(NSNumber *height, NSError * _Nullable error) {
        if(weakSelf.autoHeight == NO)   return;
        weakSelf.webView.height = height.floatValue;
        if(weakSelf.heightChangedBlock) {
            weakSelf.heightChangedBlock(weakSelf.webView.height, weakSelf);
        }
    }];
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];   // 禁止长按弹窗
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];      // 禁止选中
}

#pragma mark 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    YLLog(@"富文本 点击了链接 : %@", url.absoluteString);
    if([url.absoluteString hasPrefix:@"tel://"] ||
       [url.absoluteString hasPrefix:@"sms://"] ||
       [url.absoluteString hasPrefix:@"mailto://"]) {
        // 拨打电话,发送短信,发送邮件
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark 在新的页面中打开
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSURL *url = navigationAction.request.URL;
    YLLog(@"新窗口打开链接 : %@", url.absoluteString);
    if(url.absoluteString.length) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    return nil;
}

#pragma mark 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    YLLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)setRichText:(NSString *)richText {
    if(richText && [_richText isEqualToString:richText] == NO) {
        _richText = [richText copy];
        [self.webView loadHTMLString:_richText baseURL:nil];
    }
}

- (WKWebView *)webView {
    if(_webView == nil) {
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        [preferences setValue:@(YES) forKey:@"allowFileAccessFromFileURLs"];
        
        // 禁止缩放
        NSString *injectionJSString = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:injectionJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
    
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        config.suppressesIncrementalRendering = YES;
        config.preferences = preferences;
        config.userContentController = wkUController;
        if(@available(iOS 10.0, *)) {
            config.mediaTypesRequiringUserActionForPlayback = true;
        }
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.autoresizesSubviews = YES;
        _webView.scrollView.scrollEnabled = !self.autoHeight;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

@end
