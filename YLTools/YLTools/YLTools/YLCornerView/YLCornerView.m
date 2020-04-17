//
//  YLCornerView.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLCornerView.h"

@interface YLCornerView () <CALayerDelegate>

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation YLCornerView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.maskLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.maskLayer];
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if(layer == self.maskLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.rectCorner cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
        self.maskLayer.frame = self.bounds;
        self.maskLayer.path = path.CGPath;
        self.layer.mask = self.maskLayer;
    }
}

- (void)setRectCorner:(UIRectCorner)rectCorner {
    _rectCorner = rectCorner;
    [self layoutSublayersOfLayer:self.maskLayer];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self layoutSublayersOfLayer:self.maskLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutSublayersOfLayer:self.maskLayer];
}

@end
