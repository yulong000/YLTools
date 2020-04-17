//
//  YLDashLineView.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLDashLineView.h"

@implementation YLDashLineView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.lineColor = kDashLineDefaultColor;
        self.lineWidth = 1;
        self.lineDash = 2;
        self.spaceDash = 2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.lineColor set];
    CGContextSetLineWidth(context, self.lineWidth);
    CGFloat lengths[] = {self.lineDash, self.spaceDash};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, rect.size.height - self.lineWidth / 2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - self.lineWidth / 2);
    CGContextStrokePath(context);
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setLineDash:(CGFloat)lineDash {
    _lineDash = lineDash;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setSpaceDash:(CGFloat)spaceDash {
    _spaceDash = spaceDash;
    [self setNeedsDisplay];
}

@end
