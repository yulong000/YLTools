#import "UIView+Frame.h"

@implementation UIView (Frame)

- (YLSingleValueIs)x_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.x = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)y_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.y = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)width_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.width = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)height_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.height = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)top_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.x = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)left_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.y = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)bottom_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.bottom = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)right_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.right = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)centerX_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.centerX = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)centerY_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.centerY = value;
        return weakSelf;
    };
}

- (YLDoubleValueIs)origin_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value1, CGFloat value2) {
        weakSelf.x = value1;
        weakSelf.y = value2;
        return weakSelf;
    };
}

- (YLDoubleValueIs)size_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value1, CGFloat value2) {
        weakSelf.width = value1;
        weakSelf.height = value2;
        return weakSelf;
    };
}

- (YLDoubleValueIs)center_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value1, CGFloat value2) {
        weakSelf.centerX = value1;
        weakSelf.centerY = value2;
        return weakSelf;
    };
}

- (YLFrameIs)frame_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
        weakSelf.frame = CGRectMake(x, y, width, height);
        return weakSelf;
    };
}

- (YLOffset)offsetX_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat x) {
        weakSelf.x += x;
        return weakSelf;
    };
}

- (YLOffset)offsetY_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat y) {
        weakSelf.y += y;
        return weakSelf;
    };
}

- (YLEqualToView)x_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.x = otherView.x;
        return weakSelf;
    };
}

- (YLEqualToView)y_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.y = otherView.y;
        return weakSelf;
    };
}

- (YLEqualToView)origin_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.origin = otherView.origin;
        return weakSelf;
    };
}

- (YLEqualToView)top_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.top = otherView.top;
        return weakSelf;
    };
}

- (YLEqualToView)left_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.left = otherView.left;
        return weakSelf;
    };
}

- (YLEqualToView)bottom_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.bottom = otherView.bottom;
        return weakSelf;
    };
}

- (YLEqualToView)right_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.right = otherView.right;
        return weakSelf;
    };
}

- (YLEqualToView)width_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.width = otherView.width;
        return weakSelf;
    };
}

- (YLEqualToView)height_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.height = otherView.height;
        return weakSelf;
    };
}

- (YLEqualToView)size_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.size = otherView.size;
        return weakSelf;
    };
}

- (YLEqualToView)centerX_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.centerX = otherView.centerX;
        return weakSelf;
    };
}

- (YLEqualToView)centerY_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.centerY = otherView.centerY;
        return weakSelf;
    };
}

- (YLEqualToView)center_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView) {
        weakSelf.center = otherView.center;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)x_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat offset) {
        weakSelf.x = otherView.x + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)y_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat offset) {
        weakSelf.y = otherView.y + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)top_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat offset) {
        weakSelf.top = otherView.top + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)left_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat offset) {
        weakSelf.left = otherView.left + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)bottom_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat offset) {
        weakSelf.bottom = otherView.bottom + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)right_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat offset) {
        weakSelf.right = otherView.right + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)centerX_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat offset) {
        weakSelf.centerX = otherView.centerX + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)centerY_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat offset) {
        weakSelf.centerY = otherView.centerY + offset;
        return weakSelf;
    };
}

- (YLEqualToSuperView)right_equalToSuper{
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.right = weakSelf.superview.width;
        return weakSelf;
    };
}

- (YLEqualToSuperView)bottom_equalToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.bottom = weakSelf.superview.height;
        return weakSelf;
    };
}

- (YLEqualToSuperView)centerX_equalToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.centerX = weakSelf.superview.width / 2;
        return weakSelf;
    };
}

- (YLEqualToSuperView)centerY_equalToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.centerY = weakSelf.superview.height / 2;
        return weakSelf;
    };
}

- (YLSpaceToSuperView)right_spaceToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat space) {
        weakSelf.right = weakSelf.superview.width - space;
        return weakSelf;
    };
}

- (YLSpaceToSuperView)bottom_spaceToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat space) {
        weakSelf.bottom = weakSelf.superview.height - space;
        return weakSelf;
    };
}

- (YLSpaceToView)top_spaceTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat space) {
        weakSelf.top = otherView.bottom + space;
        return weakSelf;
    };
}

- (YLSpaceToView)left_spaceTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat space) {
        weakSelf.left = otherView.right + space;
        return weakSelf;
    };
}

- (YLSpaceToView)bottom_spaceTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat space) {
        weakSelf.bottom = otherView.top - space;
        return weakSelf;
    };
}

- (YLSpaceToView)right_spaceTo {
    __weak typeof(self) weakSelf = self;
    return ^ (UIView *otherView, CGFloat space) {
        weakSelf.right = otherView.left - space;
        return weakSelf;
    };
}

- (YLEdgeToSuperView)edgeToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ (UIEdgeInsets insets) {
        weakSelf.left = insets.left;
        weakSelf.top = insets.top;
        weakSelf.size = CGSizeMake(weakSelf.superview.width - insets.left - insets.right, weakSelf.superview.height - insets.top - insets.bottom);
        return weakSelf;
    };
}


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
