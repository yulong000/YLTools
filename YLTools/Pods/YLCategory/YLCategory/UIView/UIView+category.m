#import "UIView+category.h"

@implementation UIView (category)

#pragma mark 移除所有子控件
- (void)removeAllSubviews {
    if([self isKindOfClass:[UIView class]] == NO)   return;
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
}

#pragma mark 移除某一类子控件
- (void)removeSubviewsWithClass:(Class)classRemove {
    if([self isKindOfClass:[UIView class]] == NO)   return;
    if(classRemove == nil)  return;
    for (UIView *sub in self.subviews) {
        if([sub isKindOfClass:classRemove]) {
            [sub removeFromSuperview];
        }
    }
}

#pragma mark 添加一组子控件
- (void)addSubViewsFromArray:(NSArray *)subViews {
    [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIView class]]) {
            [self addSubview:obj];
        }
    }];
}

#pragma mark 获取view所在的controller
- (UIViewController *)vc {
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark 设置边框
- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

#pragma mark 设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark 设置边框和圆角
- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    [self setBorderColor:borderColor borderWidth:borderWidth];
    [self setCornerRadius:cornerRadius];
}

@end
