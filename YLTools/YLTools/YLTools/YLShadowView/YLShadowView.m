//
//  YLShadowView.m
//  TaoZhao
//
//  Created by weiyulong on 2020/6/28.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLShadowView.h"

@interface YLShadowView ()

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation YLShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.shadowView = [[UIView alloc] init];
        self.shadowView.layer.shadowOffset = CGSizeMake(3, 3);
        self.shadowView.layer.shadowColor = BlackColor.CGColor;
        self.shadowView.layer.shadowOpacity = 0.1;
        self.shadowView.layer.shadowRadius = 3;
        [self addSubview:self.shadowView];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = WhiteColor;
        [self.contentView setBorderColor:RGBA(249, 249, 249, 1) borderWidth:1 cornerRadius:5];
        [self.shadowView addSubview:self.contentView];
        
        self.edgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shadowView.size = CGSizeMake(self.width - self.edgeInsets.left - self.edgeInsets.right, self.height - self.edgeInsets.top - self.edgeInsets.bottom);
    self.shadowView.origin = CGPointMake(self.edgeInsets.left, self.edgeInsets.top);
    self.contentView.frame = self.shadowView.bounds;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self setNeedsLayout];
}

@end
