
#import "MBProgressHUD.h"

#define kHUDHiddenAfterSecond 0.7
typedef void (^MBProgressHUDButtonClickedBlock)(UIButton *button);

// 通过设置 属性值 square = YES 可以让hud对象保持正方形

@interface MBProgressHUD (YL)

/**
 设置了button时 点击回调
 */
@property (nonatomic, copy) MBProgressHUDButtonClickedBlock clickedBlock;

/**
 *  显示成功信息
 *
 *  @param success 文本信息
 *  @param view    要显示到的view
 */
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示错误信息
 *
 *  @param error 文本信息
 *  @param view  要显示到的view
 */
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示成功信息到 最后一个UIWindow 窗口上
 *
 *  @param success 文本信息
 */
+ (MBProgressHUD *)showSuccess:(NSString *)success;

/**
 *  显示错误信息到 最后一个UIWindow 窗口上
 *
 *  @param error 文本信息
 */
+ (MBProgressHUD *)showError:(NSString *)error;

/**
 显示成功信息 到指定的UIView上, 默认时间后隐藏, 结束后回调

 @param success 成功的提示信息
 @param view 要显示到的UIView
 @param block 结束后回调
 @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block;

/**
 显示失败信息 到指定的UIView上,默认时间后隐藏, 结束后回调

 @param error 失败的提示信息
 @param view 要显示到的UIView
 @param block 结束后回调
 @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block;

/**
 显示成功信息 到UIWindow上, 默认时间后隐藏
 
 @param success 成功的提示信息
 @param block 结束后回调
 @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showSuccess:(NSString *)success completionBlock:(MBProgressHUDCompletionBlock)block;

/**
 显示失败信息 到UIWindow上,默认时间后隐藏
 
 @param error 失败的提示信息
 @param block 结束后回调
 @return MBProgressHUD实例
 */

+ (MBProgressHUD *)showError:(NSString *)error completionBlock:(MBProgressHUDCompletionBlock)block;

/**
 *  显示提示信息,带菊花状态,需手动隐藏
 *
 *  @param message 提示信息
 *  @param detailMessage 详情信息
 *  @param view    要显示到的view
 *  @param dimBackground 是否显示蒙板
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showMessage:(NSString *)message detailMessage:(NSString *)detailMessage toView:(UIView *)view dimBackground:(BOOL)dimBackground;

/**
 *  显示提示信息,带菊花状态,需手动隐藏
 *
 *  @param message 提示信息
 *  @param view    要显示到的view
 *  @param dimBackground 是否显示蒙版
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view dimBackground:(BOOL)dimBackground;
/**
 *  显示提示信息,带菊花状态,需手动隐藏, 默认关闭蒙板
 *
 *  @param message 提示信息
 *  @param view    要显示到的view
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  显示提示信息到 最后一个UIWindow 窗口上,带菊花状态,需手动隐藏
 *
 *  @param message 提示信息
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;

/**
 *  隐藏HUD
 *
 *  @param view 需要隐藏HUD的view
 */
+ (void)hideHUDForView:(UIView *)view;
/**
 *  隐藏 最后一个UIWindow 窗口上的HUD
 */
+ (void)hideHUD;

/**
 *  显示文本提示信息, 带详细信息, 不带菊花
 *
 *  @param text       文本提示
 *  @param detailText 详细信息
 *  @param view       要显示到的view
 *  @param square     是否显示正方形的样式
 *  @param delay      delay秒后自动隐藏
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showText:(NSString *)text detailText:(NSString *)detailText toView:(UIView *)view square:(BOOL)square hiddenAfterDelay:(CGFloat)delay;

/**
 *  显示文本提示信息, 带详细信息, 不带菊花, square = YES, delay = kHUDHiddenAfterSecond
 *
 *  @param text       文本提示
 *  @param detailText 详细信息
 *  @param view       要显示到的view
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showText:(NSString *)text detailText:(NSString *)detailText toView:(UIView *)view;

/**
 *  显示文本提示信息, 不带菊花
 *
 *  @param text   文本信息
 *  @param view   要显示到的view
 *  @param square 是否显示正方形的样式
 *  @param delay  delay秒后自动隐藏
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view square:(BOOL)square hiddenAfterDelay:(CGFloat)delay;

/**
 *  显示文本提示信息, 不带菊花
 *
 *  @param text  文本信息
 *  @param view  要显示到的view
 *  @param delay delay秒后自动隐藏
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view hiddenAfterDelay:(CGFloat)delay;

/**
 *  显示文本提示信息到 最后一个UIWindow 窗口上, 不带菊花
 *
 *  @param text  文本信息
 *  @param delay delay秒后自动隐藏
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showText:(NSString *)text hiddenAfterDelay:(CGFloat)delay;

/**
 显示文本提示信息到最后一个UIWindow 窗口上, 不带菊花,隐藏后调用block

 @param text 文本信息
 @param delay delay秒后自动隐藏
 @param block 结束后回调
 @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showText:(NSString *)text hiddenAfterDelay:(CGFloat)delay completionBlock:(MBProgressHUDCompletionBlock)block;

/**
 显示文本提示信息到指定的UIView上, 不带菊花,隐藏后调用block

 @param text 文本信息
 @param view 指定的UIView
 @param delay delay秒后自动隐藏
 @param block 结束后回调
 @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view hiddenAfterDelay:(CGFloat)delay completionBlock:(MBProgressHUDCompletionBlock)block;

/**
 *  显示文本提示信息到 最后一个UIWindow 窗口上,延时默认时间后隐藏, 不带菊花
 *
 *  @param text 文本信息
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showText:(NSString *)text;

/**
 *  环形的进度条, progress 取值范围 0 ~ 1
 *
 *  @param text   文本信息
 *  @param view   要显示到的view
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text toView:(UIView *)view;

/**
 带按钮的环形进度条, progress 取值范围 0 ~ 1
 
 @param text 文本信息
 @param view 要显示到的view
 @param title button的title
 @param clickBlock 回调block
 @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showAnnularProgressWithText:(NSString *)text toView:(UIView *)view buttonTitle:(NSString *)title clickBlock:(MBProgressHUDButtonClickedBlock)clickBlock;

/**
 *  显示自定义view
 *
 *  @param customView 自定义的view
 *  @param message    文本信息
 *  @param view       要显示到的view
 *
 *  @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showWithCustomView:(UIView *)customView  message:(NSString *)message toView:(UIView *)view;

/**
 显示横向进度条

 @param text 文本信息
 @param view 要显示到的view
 @return MBProgressHUD实例
 */
+ (MBProgressHUD *)showHorizontalProgressBarWithText:(NSString *)text toView:(UIView *)view;




@end
