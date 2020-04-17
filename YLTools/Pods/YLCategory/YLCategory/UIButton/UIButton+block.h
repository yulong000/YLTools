#import <UIKit/UIKit.h>

typedef void (^UIButtonClickedBlock)(UIButton *button);

@interface UIButton (block)

/**
 点击回调
 */
@property (nonatomic, copy)   UIButtonClickedBlock clickedBlock;

+ (instancetype)buttonWithClickBlock:(UIButtonClickedBlock)clickedBlock;
+ (instancetype)buttonWithTitle:(NSString *)title clickBlock:(UIButtonClickedBlock)clickedBlock;
+ (instancetype)buttonWithImage:(UIImage *)image clickBlock:(UIButtonClickedBlock)clickedBlock;
+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image clickBlock:(UIButtonClickedBlock)clickedBlock;
+ (instancetype)buttonWithBackgroundImage:(UIImage *)backgroundImage clickBlock:(UIButtonClickedBlock)clickedBlock;
+ (instancetype)buttonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickBlock:(UIButtonClickedBlock)clickedBlock;
+ (instancetype)buttonWithTitle:(NSString *)title backgroundImageCorlor:(UIColor *)bgImageColor cornerRadius:(CGFloat)cornerRadius clickBlock:(UIButtonClickedBlock)clickedBlock;
@end
