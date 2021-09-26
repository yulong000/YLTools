#import "UIButton+block.h"
#import <objc/runtime.h>

static const char UIButtonClickedBlockKey = '\0';

@implementation UIButton (block)

#pragma mark - block
- (UIButtonClickedBlock)clickedBlock {
    return objc_getAssociatedObject(self, &UIButtonClickedBlockKey);
}

- (void)setClickedBlock:(UIButtonClickedBlock)clickedBlock {
    [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self willChangeValueForKey:@"clickBlock"];
    objc_setAssociatedObject(self, &UIButtonClickedBlockKey, clickedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"clickBlock"];
}

- (void)buttonClick {
    if(self.clickedBlock) {
        self.clickedBlock(self);
    }
}

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image backgroundImage:(UIImage *)backgroundImage clickBlock:(UIButtonClickedBlock)clickedBlock {
    UIButton *button =  [[UIButton alloc] init];
    if(title.length)    [button setTitle:title forState:UIControlStateNormal];
    if(image)           [button setImage:image forState:UIControlStateNormal];
    if(backgroundImage) [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    if(clickedBlock)    button.clickedBlock = clickedBlock;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:button action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image clickBlock:(UIButtonClickedBlock)clickedBlock {
    return [UIButton buttonWithTitle:title image:image backgroundImage:nil clickBlock:clickedBlock];
}

+ (instancetype)buttonWithTitle:(NSString *)title clickBlock:(UIButtonClickedBlock)clickedBlock {
    return [UIButton buttonWithTitle:title image:nil clickBlock:clickedBlock];
}

+ (instancetype)buttonWithImage:(UIImage *)image clickBlock:(UIButtonClickedBlock)clickedBlock {
    return [UIButton buttonWithTitle:nil image:image clickBlock:clickedBlock];
}

+ (instancetype)buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage clickBlock:(UIButtonClickedBlock)clickedBlock {
    UIButton *button = [UIButton buttonWithImage:image clickBlock:clickedBlock];
    [button setImage:selectedImage forState:UIControlStateSelected];
    return button;
}

+ (instancetype)buttonWithClickBlock:(UIButtonClickedBlock)clickedBlock {
    return [UIButton buttonWithTitle:nil clickBlock:clickedBlock];
}

+ (instancetype)buttonWithBackgroundImage:(UIImage *)backgroundImage clickBlock:(UIButtonClickedBlock)clickedBlock {
    return [UIButton buttonWithTitle:nil image:nil backgroundImage:backgroundImage clickBlock:clickedBlock];
}

+ (instancetype)buttonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickBlock:(UIButtonClickedBlock)clickedBlock {
    return [UIButton buttonWithTitle:title image:nil backgroundImage:backgroundImage clickBlock:clickedBlock];
}

+ (instancetype)buttonWithTitle:(NSString *)title
          backgroundImageCorlor:(UIColor *)bgImageColor
                   cornerRadius:(CGFloat)cornerRadius
                     clickBlock:(UIButtonClickedBlock)clickedBlock {
    UIImage *image = [self imageWithColor:bgImageColor size:CGSizeMake(10, 10)];
    UIImage *bgImage = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIButton *btn = [UIButton buttonWithTitle:title backgroundImage:bgImage clickBlock:clickedBlock];
    btn.layer.cornerRadius = cornerRadius;
    btn.clipsToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font clickedBlock:(UIButtonClickedBlock)clickedBlock {
    UIButton *btn = [self buttonWithTitle:title clickBlock:clickedBlock];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundImageCorlor:(UIColor *)bgImageColor cornerRadius:(CGFloat)cornerRadius clickedBlock:(UIButtonClickedBlock)clickedBlock {
    UIButton *btn = [self buttonWithTitle:title backgroundImageCorlor:bgImageColor cornerRadius:cornerRadius clickBlock:clickedBlock];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    return btn;
}

- (CGSize)sizeWithTitlePadding:(CGFloat)padding fixHeight:(CGFloat)fixHeight {
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(titleSize.width + padding * 2, titleSize.height);
    if(fixHeight > 0) {
        frame.size.height = fixHeight;
    }
    self.frame = frame;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    return frame.size;
}

#pragma mark 获取纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){CGPointZero, size});
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
