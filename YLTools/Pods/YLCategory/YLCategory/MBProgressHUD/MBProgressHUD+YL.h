
#import "MBProgressHUD.h"

typedef void (^MBProgressHUDButtonClickedBlock)(UIButton *button);

@interface MBProgressHUD (YL)


/*
 ############################################################
 温馨提示：未传入view时，显示在最上层的window上
 ############################################################
 */

/// 设置了button时 点击回调
@property (nonatomic, copy) MBProgressHUDButtonClickedBlock clickedBlock;

/// 显示成功信息，自动隐藏

+ (MBProgressHUD *)showSuccess:(NSString *)success;
+ (MBProgressHUD *)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second;
+ (MBProgressHUD *)showSuccess:(NSString *)success completionBlock:(MBProgressHUDCompletionBlock)block;
+ (MBProgressHUD *)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block;
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view;
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view hideAfterDelay:(CGFloat)second;
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block;
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view hideAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block;


/// 显示错误信息，自动隐藏

+ (MBProgressHUD *)showError:(NSString *)error;
+ (MBProgressHUD *)showError:(NSString *)error hideAfterDelay:(CGFloat)second;
+ (MBProgressHUD *)showError:(NSString *)error completionBlock:(MBProgressHUDCompletionBlock)block;
+ (MBProgressHUD *)showError:(NSString *)error hideAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block;
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view;
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view hideAfterDelay:(CGFloat)second;
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block;
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view hideAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block;


/// 显示带文字的loading信息， 需手动隐藏

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message detailMessage:(NSString *)detailMessage;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message detailMessage:(NSString *)detailMessage toView:(UIView *)view;

/// 隐藏HUD

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;


/// 显示文字信息，自动隐藏

+ (MBProgressHUD *)showText:(NSString *)text;
+ (MBProgressHUD *)showText:(NSString *)text hiddenAfterDelay:(CGFloat)second;
+ (MBProgressHUD *)showText:(NSString *)text hiddenAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block;
+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view;
+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view hiddenAfterDelay:(CGFloat)second;
+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view hiddenAfterDelay:(CGFloat)second completionBlock:(MBProgressHUDCompletionBlock)block;


/// 显示进度

/// 环形的进度条, progress 取值范围 0 ~ 1
+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text;
+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock;
+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text toView:(UIView *)view;
+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text toView:(UIView *)view buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock;


/// 横向进度条, progress 取值范围 0 ~ 1
+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text;
+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock;
+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text toView:(UIView *)view;
+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text toView:(UIView *)view buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock;

/// 显示自定义view
+ (MBProgressHUD *)showWithCustomView:(UIView *)customView message:(NSString *)message toView:(UIView *)view;


/// 切换模式

- (void)showMessage:(NSString *)message;
- (void)showText:(NSString *)text;
- (void)showSuccess:(NSString *)success;
- (void)showError:(NSString *)error;
- (void)showProgress:(CGFloat)progress;
- (void)showHorizontalProgress:(CGFloat)progress;

- (void)showMessage:(NSString *)message detailMessage:(NSString *)detailMessage;
- (void)showText:(NSString *)text hideAfterDelay:(CGFloat)second;
- (void)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second;
- (void)showError:(NSString *)error hideAfterDelay:(CGFloat)second;
- (void)showProgress:(CGFloat)progress text:(NSString *)text;
- (void)showHorizontalProgress:(CGFloat)progress text:(NSString *)text;

@end

@interface MBProgressHUDConfig : NSObject

+ (instancetype)shareInstance;

/// 提示框的背景色
@property (nonatomic, strong) UIColor *hudColor;
/// 文本的颜色, 默认黑色
@property (nonatomic, strong) UIColor *textColor;
/// 详细文本的颜色, 默认黑色
@property (nonatomic, strong) UIColor *detailTextColor;
/// 默认显示的时间, default = 1
@property (nonatomic, assign) CGFloat hideAfterTimer;
/// 成功时的图片
@property (nonatomic, strong) UIImage *successImage;
/// 失败时的图片
@property (nonatomic, strong) UIImage *errorImage;

@end
