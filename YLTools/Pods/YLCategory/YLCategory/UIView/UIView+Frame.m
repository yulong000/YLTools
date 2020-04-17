#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGFloat centerY = self.center.y;
    self.center = CGPointMake(centerX, centerY);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGFloat centerX = self.center.x;
    self.center = CGPointMake(centerX, centerY);
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    self.y = top;
}

- (CGFloat)left {
    return self.x;
}

- (void)setLeft:(CGFloat)left {
    self.x = left;
}

- (CGFloat)bottom {
    return self.maxY;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.height;
    self.frame = frame;
}

- (CGFloat)right {
    return self.maxX;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.width;
    self.frame = frame;
}

- (CGPoint)centerPoint {
    return CGPointMake(self.width * 0.5, self.height * 0.5);
}

- (void)setWidthFixRight:(CGFloat)widthFixRight {
    CGFloat maxX = self.maxX;
    self.width = widthFixRight;
    self.right = maxX;
}

- (void)setHeightFixBottom:(CGFloat)heightFixBottom {
    CGFloat maxY = self.maxY;
    self.height = heightFixBottom;
    self.bottom = maxY;
}

@end
