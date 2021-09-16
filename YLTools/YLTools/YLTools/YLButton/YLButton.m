//
//  YLButton.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLButton.h"

@implementation YLButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.adjustsFontSizeToFitWidth = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.layoutMode = YLButtonLayoutModeDefault;
    }
    return self;
}

- (instancetype)initWithLayout:(YLButtonLayoutMode)layout imgViewSize:(CGSize)size {
    if(self = [super init]) {
        self.layoutMode = layout;
        self.imgViewSize = size;
    }
    return self;
}

+ (instancetype)buttonWithLayout:(YLButtonLayoutMode)layout imgViewSize:(CGSize)size {
    return [[YLButton alloc] initWithLayout:layout imgViewSize:size];
}

- (void)setLayoutMode:(YLButtonLayoutMode)layoutMode {
    _layoutMode = layoutMode;
    switch (_layoutMode) {
        case YLButtonLayoutModeDefault: {
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case YLButtonLayoutModeImageViewRight: {
            self.titleLabel.textAlignment = NSTextAlignmentRight;
        }
            break;
        case YLButtonLayoutModeImageViewTop:
        case YLButtonLayoutModeImageViewBottom: {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        default:
            break;
    }
    [self setNeedsLayout];
}

- (void)setImgViewSize:(CGSize)imgViewSize {
    _imgViewSize = imgViewSize;
    [self setNeedsLayout];
}

- (CGFloat)insetsWidth {
    return self.imageEdgeInsets.left + self.imageEdgeInsets.right + self.titleEdgeInsets.left + self.titleEdgeInsets.right;
}

- (CGFloat)insetsHeight {
    return self.imageEdgeInsets.top + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width, height, x, y;
    switch (self.layoutMode) {
        case YLButtonLayoutModeDefault: {
            height = contentRect.size.height;
            width = contentRect.size.width - self.imgViewSize.width - [self insetsWidth];
            x = self.imageEdgeInsets.left + self.imageEdgeInsets.right + self.imgViewSize.width + self.titleEdgeInsets.left;
            y = 0;
        }
            break;
        case YLButtonLayoutModeImageViewRight: {
            height = contentRect.size.height;
            width = contentRect.size.width - self.imgViewSize.width - [self insetsWidth];
            x = self.titleEdgeInsets.left;
            y = 0;
        }
            break;
        case YLButtonLayoutModeImageViewTop: {
            height = contentRect.size.height - self.imgViewSize.height - [self insetsHeight];
            width = contentRect.size.width;
            x = 0;
            y = self.imageEdgeInsets.top + self.imgViewSize.height + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top;
        }
            break;
        case YLButtonLayoutModeImageViewBottom: {
            height = contentRect.size.height - self.imgViewSize.height - [self insetsHeight];
            width = contentRect.size.width;
            x = 0;
            y = self.titleEdgeInsets.top;
        }
            break;
        default:
            break;
    }
    return CGRectMake(x, y, width, height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x, y;
    switch (self.layoutMode) {
        case YLButtonLayoutModeDefault: {
            x = self.imageEdgeInsets.left;
            y = (self.frame.size.height - self.imgViewSize.height) / 2;
        }
            break;
        case YLButtonLayoutModeImageViewRight: {
            x = contentRect.size.width - self.imageEdgeInsets.right - self.imgViewSize.width;
            y = (self.frame.size.height - self.imgViewSize.height) / 2;
        }
            break;
        case YLButtonLayoutModeImageViewTop: {
            x = (self.frame.size.width - self.imgViewSize.width) / 2;
            y = self.imageEdgeInsets.top;
        }
            break;
        case YLButtonLayoutModeImageViewBottom: {
            x = (self.frame.size.width - self.imgViewSize.width) / 2;
            y = contentRect.size.height - self.imageEdgeInsets.bottom - self.imgViewSize.height;
        }
            break;
        default:
            break;
    }
    return CGRectMake(x, y, self.imgViewSize.width, self.imgViewSize.height);
}

@end
