
#import "MBProgressHUD+YL.h"
#import <objc/runtime.h>

static const char MBProgressHUDButtonClickedBlockKey = '\0';

@implementation MBProgressHUD (YL)

#pragma mark 当传入的view 为 nil 时,将hud添加到 window 上
+ (UIView *)getHUDSuperViewWithInputView:(UIView *)inputView {
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

#pragma mark 获取bundle里的图片
+ (UIImage *)bundleImage:(NSString *)icon {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MBProgressHUD" withExtension:@"bundle"];
    if(url == nil) {
        url = [[[[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil] URLByAppendingPathComponent:@"YLCategory"] URLByAppendingPathExtension:@"framework"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        url = [bundle URLForResource:@"MBProgressHUD" withExtension:@"bundle"];
    }
    NSString *path = [[NSBundle bundleWithURL:url].bundlePath stringByAppendingPathComponent:icon];
    return [UIImage imageWithContentsOfFile:path];
}

#pragma mark - 显示信息
+ (MBProgressHUD *)show:(NSString *)text icon:(UIImage *)icon view:(UIView *)view {
    UIImageView *customView = [[UIImageView alloc] initWithImage:icon];
    MBProgressHUD *hud = [self showWithCustomView:customView message:text toView:view];
    hud.square = NO;
    if([MBProgressHUDConfig shareInstance].hudColor) {
        hud.bezelView.color = [MBProgressHUDConfig shareInstance].hudColor;
    }
    [hud hideAnimated:YES afterDelay:[MBProgressHUDConfig shareInstance].hideAfterTimer];
    return hud;
}

#pragma mark - 显示成功信息，自动隐藏

+ (MBProgressHUD *)showSuccess:(NSString *)success {
    return [self showSuccess:success toView:nil];
}
+ (MBProgressHUD *)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second {
    return [self showSuccess:success toView:nil hideAfterDelay:second];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success completionBlock:(MBProgressHUDCompletionBlock)block {
    return [self showSuccess:success toView:nil completionBlock:block];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block {
    return [self showSuccess:success toView:nil hideAfterDelay:second completionBlock:block];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view {
    return [self showSuccess:success toView:view completionBlock:nil];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view hideAfterDelay:(CGFloat)second {
    return [self showSuccess:success toView:view hideAfterDelay:second completionBlock:nil];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block {
    return [self showSuccess:success toView:view hideAfterDelay:0 completionBlock:block];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view hideAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block {
    NSString *text = @"success";
    if([success isKindOfClass:[NSString class]] && success.length > 0) {
        text = success;
    }
    MBProgressHUD *hud = [self show:success icon:[MBProgressHUDConfig shareInstance].successImage ?: [MBProgressHUD bundleImage:@"success"] view:view];
    hud.completionBlock = block;
    if(second > 0) {
        [hud hideAnimated:YES afterDelay:second];
    }
    return hud;
}

#pragma mark - 显示错误信息

+ (MBProgressHUD *)showError:(NSString *)error {
    return [self showError:error completionBlock:nil];
}

+ (MBProgressHUD *)showError:(NSString *)error hideAfterDelay:(CGFloat)second {
    return [self showError:error hideAfterDelay:second completionBlock:nil];
}

+ (MBProgressHUD *)showError:(NSString *)error completionBlock:(MBProgressHUDCompletionBlock)block {
    return [self showError:error hideAfterDelay:0 completionBlock:block];
}

+ (MBProgressHUD *)showError:(NSString *)error hideAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block {
    return [self showError:error toView:nil hideAfterDelay:second completionBlock:block];
}

+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view {
    return [self showError:error toView:view completionBlock:nil];
}

+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view hideAfterDelay:(CGFloat)second {
    return [self showError:error toView:view hideAfterDelay:second completionBlock:nil];
}

+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block {
    return [self showError:error toView:view hideAfterDelay:0 completionBlock:block];
}

+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view hideAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block {
    NSString *text = @"error";
    if([error isKindOfClass:[NSString class]] && error.length > 0) {
        text = error;
    }
    MBProgressHUD *hud = [self show:text icon:[MBProgressHUDConfig shareInstance].successImage ?: [MBProgressHUD bundleImage:@"error"] view:view];
    hud.completionBlock = block;
    if(second > 0) {
        [hud hideAnimated:YES afterDelay:second];
    }
    return hud;
}

#pragma mark - 显示带文字的loading信息，需手动隐藏

+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message detailMessage:(NSString *)detailMessage {
    return [self showMessage:message detailMessage:detailMessage toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    return [self showMessage:message detailMessage:nil toView:view];
}

+ (MBProgressHUD *)showMessage:(NSString *)message detailMessage:(NSString *)detailMessage toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getHUDSuperViewWithInputView:view] animated:YES];
    hud.label.text = message;
    hud.detailsLabel.text = detailMessage;
    if([MBProgressHUDConfig shareInstance].hudColor) {
        hud.bezelView.color = [MBProgressHUDConfig shareInstance].hudColor;
    }
    if([MBProgressHUDConfig shareInstance].textColor) {
        hud.label.textColor = [MBProgressHUDConfig shareInstance].textColor;
    }
    if([MBProgressHUDConfig shareInstance].detailTextColor) {
        hud.detailsLabel.textColor = [MBProgressHUDConfig shareInstance].detailTextColor;
    }
    return hud;
}


#pragma mark 隐藏HUD
+ (void)hideHUDForView:(UIView *)view {
    view = [self getHUDSuperViewWithInputView:view];
    // 排除掉会自动隐藏的hud, 解决多个hud时隐藏不掉的bug
    [view.subviews.reverseObjectEnumerator.allObjects enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:self]) {
            [((MBProgressHUD *)obj) hideAnimated:NO];
        }
    }];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

#pragma mark - 显示文本提示信息, 带详细信息

+ (MBProgressHUD *)showText:(NSString *)text {
    return [self showText:text toView:nil];
}

+ (MBProgressHUD *)showText:(NSString *)text hiddenAfterDelay:(CGFloat)second {
    return [self showText:text hiddenAfterDelay:second completionBlock:nil];
}

+ (MBProgressHUD *)showText:(NSString *)text hiddenAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block {
    return [self showText:text toView:nil hiddenAfterDelay:second completionBlock:block];
}

+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view {
    return [self showText:text toView:view hiddenAfterDelay:0];
}

+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view hiddenAfterDelay:(CGFloat)second {
    return [self showText:text toView:view hiddenAfterDelay:second completionBlock:nil];
}

+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view hiddenAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getHUDSuperViewWithInputView:view] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.completionBlock = block;
    hud.label.text = text;
    hud.label.textColor = [MBProgressHUDConfig shareInstance].textColor;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:second ?: [MBProgressHUDConfig shareInstance].hideAfterTimer];
    if([MBProgressHUDConfig shareInstance].hudColor) {
        hud.bezelView.color = [MBProgressHUDConfig shareInstance].hudColor;
    }
    if([MBProgressHUDConfig shareInstance].textColor) {
        hud.label.textColor = [MBProgressHUDConfig shareInstance].textColor;
    }
    if([MBProgressHUDConfig shareInstance].detailTextColor) {
        hud.detailsLabel.textColor = [MBProgressHUDConfig shareInstance].detailTextColor;
    }
    return hud;
}


#pragma mark - 环形的进度条

+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text {
    return [self showAnnularProgressWithText:text toView:nil];
}

+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock {
    return [self showAnnularProgressWithText:text toView:nil buttonTitle:title clickBlock:clickBlock];
}

+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text toView:(UIView *)view {
    return [self showAnnularProgressWithText:text toView:view buttonTitle:nil clickBlock:nil];
}

+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text toView:(UIView *)view buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getHUDSuperViewWithInputView:view] animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = text;
    if(title.length > 0) {
        [hud.button setTitle:title forState:UIControlStateNormal];
        [hud.button setTitleColor:[MBProgressHUDConfig shareInstance].detailTextColor forState:UIControlStateNormal];
        [hud.button addTarget:hud action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        hud.clickedBlock = clickBlock;
    }
    if([MBProgressHUDConfig shareInstance].hudColor) {
        hud.bezelView.color = [MBProgressHUDConfig shareInstance].hudColor;
    }
    if([MBProgressHUDConfig shareInstance].textColor) {
        hud.label.textColor = [MBProgressHUDConfig shareInstance].textColor;
    }
    return hud;
}


#pragma mark - 横向进度条

+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text {
    return [self showHorizontalProgressBarWithText:text toView:nil];
}

+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock {
    return [self showHorizontalProgressBarWithText:text toView:nil buttonTitle:title clickBlock:clickBlock];
}

+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text toView:(UIView *)view {
    return [self showHorizontalProgressBarWithText:text toView:view buttonTitle:nil clickBlock:nil];
}

+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text toView:(UIView *)view buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getHUDSuperViewWithInputView:view] animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = text;
    hud.label.textColor = [MBProgressHUDConfig shareInstance].textColor;
    if(title.length > 0) {
        [hud.button setTitle:title forState:UIControlStateNormal];
        [hud.button setTitleColor:[MBProgressHUDConfig shareInstance].detailTextColor forState:UIControlStateNormal];
        [hud.button addTarget:hud action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        hud.clickedBlock = clickBlock;
    }
    if([MBProgressHUDConfig shareInstance].hudColor) {
        hud.bezelView.color = [MBProgressHUDConfig shareInstance].hudColor;
    }
    if([MBProgressHUDConfig shareInstance].textColor) {
        hud.label.textColor = [MBProgressHUDConfig shareInstance].textColor;
    }
    return hud;
}

#pragma mark - 显示自定义view
+ (MBProgressHUD *)showWithCustomView:(UIView *)customView message:(NSString *)message toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getHUDSuperViewWithInputView:view] animated:YES];
    hud.minSize = CGSizeMake(100, 100);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    hud.label.text = message;
    if([MBProgressHUDConfig shareInstance].hudColor) {
        hud.bezelView.color = [MBProgressHUDConfig shareInstance].hudColor;
    }
    if([MBProgressHUDConfig shareInstance].textColor) {
        hud.label.textColor = [MBProgressHUDConfig shareInstance].textColor;
    }
    if([MBProgressHUDConfig shareInstance].detailTextColor) {
        hud.detailsLabel.textColor = [MBProgressHUDConfig shareInstance].detailTextColor;
    }
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

- (void)showMessage:(NSString *)message {
    [self showMessage:message detailMessage:nil];
}

- (void)showMessage:(NSString *)message detailMessage:(NSString *)detailMessage {
    self.mode = MBProgressHUDModeIndeterminate;
    self.label.text = message;
    self.detailsLabel.text = detailMessage;
}

- (void)showText:(NSString *)text {
    [self showText:text hideAfterDelay:0];
}

- (void)showText:(NSString *)text hideAfterDelay:(CGFloat)second {
    self.mode = MBProgressHUDModeText;
    self.label.text = text;
    self.detailsLabel.text = nil;
    [self hideAnimated:YES afterDelay:second ?: [MBProgressHUDConfig shareInstance].hideAfterTimer];
}

- (void)showSuccess:(NSString *)success {
    [self showSuccess:success hideAfterDelay:0];
}

- (void)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second {
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc] initWithImage:[MBProgressHUD bundleImage:@"success"]];
    self.label.text = success;
    [self hideAnimated:YES afterDelay:second ?: [MBProgressHUDConfig shareInstance].hideAfterTimer];
}

- (void)showError:(NSString *)error {
    [self showError:error hideAfterDelay:0];
}

- (void)showError:(NSString *)error hideAfterDelay:(CGFloat)second {
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc] initWithImage:[MBProgressHUD bundleImage:@"error"]];
    self.label.text = error;
    [self hideAnimated:YES afterDelay:second ?: [MBProgressHUDConfig shareInstance].hideAfterTimer];
}

- (void)showProgress:(CGFloat)progress {
    self.mode = MBProgressHUDModeAnnularDeterminate;
    self.progress = progress;
    self.detailsLabel.text = nil;
}

- (void)showProgress:(CGFloat)progress text:(NSString *)text {
    [self showProgress:progress];
    self.label.text = text;
}

- (void)showHorizontalProgress:(CGFloat)progress {
    self.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.progress = progress;
    self.detailsLabel.text = nil;
}

- (void)showHorizontalProgress:(CGFloat)progress text:(NSString *)text {
    [self showHorizontalProgress:progress];
    self.label.text = text;
}

@end


@implementation MBProgressHUDConfig

+ (instancetype)shareInstance {
    static MBProgressHUDConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[MBProgressHUDConfig alloc] init];
        config.hideAfterTimer = 1;
    });
    return config;
}

@end
