
#import "MBProgressHUD+YL.h"
#import <objc/runtime.h>

#define SetHUDColor // hud.bezelView.color = [UIColor colorWithWhite:0.8 alpha:0.8];

static const char MBProgressHUDButtonClickedBlockKey = '\0';

@implementation MBProgressHUD (YL)

#pragma mark 当传入的view 为 nil 时,将hud添加到 window 上
+ (UIView *)hudShowViewWithInputView:(UIView *)inputView {
    if(inputView)   return inputView;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            [window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")] == NO &&
            [window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")] == NO &&
            [window isKindOfClass:NSClassFromString(@"FLEXWindow")] == NO &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark - 显示自定义view
+ (MBProgressHUD *)showWithCustomView:(UIView *)customView  message:(NSString *)message toView:(UIView *)view {
    view = [self hudShowViewWithInputView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    hud.label.text = message;
    hud.square = YES;
    SetHUDColor
    return hud;
}

#pragma mark - 显示信息
+ (MBProgressHUD *)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MBProgressHUD" withExtension:@"bundle"];
    if(url == nil) {
        url = [[[[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil] URLByAppendingPathComponent:@"YLCategory"] URLByAppendingPathExtension:@"framework"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        url = [bundle URLForResource:@"MBProgressHUD" withExtension:@"bundle"];
    }
    NSString *path = [[NSBundle bundleWithURL:url].bundlePath stringByAppendingPathComponent:icon];
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    MBProgressHUD *hud = [self showWithCustomView:customView message:text toView:view];
    hud.square = NO;
    SetHUDColor
    [hud hideAnimated:YES afterDelay:kHUDHiddenAfterSecond];
    hud.tag = arc4random() % 1000 + 10; // 10 - 1009, 会自动隐藏的
    return hud;
}

#pragma mark 显示成功信息
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view {
    return [self show:success icon:@"success" view:view];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success {
    return [self showSuccess:success toView:nil];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success completionBlock:(MBProgressHUDCompletionBlock)block {
    MBProgressHUD *hud = [self showSuccess:success];
    hud.completionBlock = block;
    return hud;
}

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block {
    MBProgressHUD *hud = [self showSuccess:success toView:view];
    hud.completionBlock = block;
    return hud;
}

#pragma mark 显示错误信息
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view {
    return [self show:error icon:@"error" view:view];
}

+ (MBProgressHUD *)showError:(NSString *)error {
    return [self showError:error toView:nil];
}

+ (MBProgressHUD *)showError:(NSString *)error completionBlock:(MBProgressHUDCompletionBlock)block {
    MBProgressHUD *hud = [self showError:error];
    hud.completionBlock = block;
    return hud;
}

+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block {
    MBProgressHUD *hud = [self showError:error toView:view];
    hud.completionBlock = block;
    return hud;
}

#pragma mark - 显示一些提示信息, 带菊花, 可设置动画效果
+ (MBProgressHUD *)showMessage:(NSString *)message
                 detailMessage:(NSString *)detailMessage
                        toView:(UIView *)view
                      animated:(BOOL)animated
                 dimBackground:(BOOL)dimBackground {
    view = [self hudShowViewWithInputView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    SetHUDColor
    hud.label.text = message;
    hud.detailsLabel.text = detailMessage;
    if(dimBackground) {
        // YES代表需要蒙版效果
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.3];
    }
    return hud;
}
+ (MBProgressHUD *)showMessage:(NSString *)message
                        toView:(UIView *)view
                      animated:(BOOL)animated
                 dimBackground:(BOOL)dimBackground {
    return [self showMessage:message detailMessage:nil toView:view animated:animated dimBackground:dimBackground];
}
+ (MBProgressHUD *)showMessage:(NSString *)message
                        toView:(UIView *)view
                      animated:(BOOL)animated {
    return [self showMessage:message toView:view animated:animated dimBackground:NO];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
                      animated:(BOOL)animated{
    return [self showMessage:message toView:nil animated:animated];
}


#pragma mark - 显示一些提示信息, 带菊花 ,有动画效果
+ (MBProgressHUD *)showMessage:(NSString *)message
                 detailMessage:(NSString *)detailMessage
                        toView:(UIView *)view
                 dimBackground:(BOOL)dimBackground {
    return [self showMessage:message detailMessage:detailMessage toView:view animated:YES dimBackground:dimBackground];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
                        toView:(UIView *)view
                 dimBackground:(BOOL)dimBackground {
    return [self showMessage:message detailMessage:nil toView:view dimBackground:dimBackground];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    return [self showMessage:message toView:view dimBackground:NO];
}

+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

#pragma mark - 隐藏HUD
+ (void)hideHUDForView:(UIView *)view {
    view = [self hudShowViewWithInputView:view];
    // 排除掉会自动隐藏的hud, 解决多个hud时隐藏不掉的bug
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self] && subview.tag < 10) {
            if (subview.superview) {
                [(MBProgressHUD *)subview hideAnimated:NO];
                break;
            }
        }
    }
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

#pragma mark - 显示文本提示信息, 带详细信息
+ (MBProgressHUD *)showText:(NSString *)text
                 detailText:(NSString *)detailText
                     toView:(UIView *)view
                     square:(BOOL)square
           hiddenAfterDelay:(CGFloat)delay {
    view = [self hudShowViewWithInputView:view];
    if(delay <= 0)      delay = kHUDHiddenAfterSecond;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    SetHUDColor
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.detailsLabel.text = detailText;
    hud.square = square;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
    hud.tag = arc4random() % 1000 + 10; // 10 - 1009, 会自动隐藏的
    return hud;
}

#pragma mark - 显示文本提示信息
+ (MBProgressHUD *)showText:(NSString *)text
                 detailText:(NSString *)detailText
                     toView:(UIView *)view {
    return [self showText:text detailText:detailText toView:view square:YES hiddenAfterDelay:kHUDHiddenAfterSecond];
}

+ (MBProgressHUD *)showText:(NSString *)text
                     toView:(UIView *)view
                     square:(BOOL)square
           hiddenAfterDelay:(CGFloat)delay {
    return [self showText:text detailText:nil toView:view square:square hiddenAfterDelay:delay];
}

+ (MBProgressHUD *)showText:(NSString *)text
          toView:(UIView *)view
hiddenAfterDelay:(CGFloat)delay {
    return [self showText:text toView:view square:NO hiddenAfterDelay:delay];
}

+ (MBProgressHUD *)showText:(NSString *)text hiddenAfterDelay:(CGFloat)delay {
    return [self showText:text toView:nil hiddenAfterDelay:delay];
}

+ (MBProgressHUD *)showText:(NSString *)text {
    return [self showText:text toView:nil hiddenAfterDelay:0];
}

+ (MBProgressHUD *)showText:(NSString *)text hiddenAfterDelay:(CGFloat)delay completionBlock:(MBProgressHUDCompletionBlock)block {
    MBProgressHUD *hud = [self showText:text hiddenAfterDelay:delay];
    hud.completionBlock = block;
    return hud;
}

+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view hiddenAfterDelay:(CGFloat)delay completionBlock:(MBProgressHUDCompletionBlock)block {
    MBProgressHUD *hud = [self showText:text toView:view hiddenAfterDelay:delay];
    hud.completionBlock = block;
    return hud;
}

#pragma mark - 环形的进度条
+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text toView:(UIView *)view {
    view = [self hudShowViewWithInputView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    SetHUDColor
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = text;
    return hud;
}
#pragma mark 带按钮的环形进度条
+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text
                                        toView:(UIView *)view
                                   buttonTitle:(NSString *)title
                                    clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock {
    view = [self hudShowViewWithInputView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    SetHUDColor
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = text;
    [hud.button addTarget:hud action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    hud.clickedBlock = clickBlock;
    [hud.button setTitle:title forState:UIControlStateNormal];
    return hud;
}

#pragma mark - 横向进度条
+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text toView:(UIView *)view {
    view = [self hudShowViewWithInputView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = text;
    SetHUDColor
    return hud;
}



#pragma mark -
- (void)buttonClick {
    if(self.clickedBlock) {
        self.clickedBlock(self.button);
    }
}

- (void)setClickedBlock:(MBProgressHUDButtonClickedBlock)clickedBlock {
    [self willChangeValueForKey:@"clickedBlock"];
    objc_setAssociatedObject(self, &MBProgressHUDButtonClickedBlockKey, clickedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"clickedBlock"];
}

- (MBProgressHUDButtonClickedBlock)clickedBlock {
    return objc_getAssociatedObject(self, &MBProgressHUDButtonClickedBlockKey);
}

@end
