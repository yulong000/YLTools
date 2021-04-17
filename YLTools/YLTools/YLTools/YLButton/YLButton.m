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
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageViewRatio = 0.5;
        self.seperateGap = 3;
    }
    return self;
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

- (void)setImageViewRatio:(CGFloat)imageViewRatio {
    _imageViewRatio = imageViewRatio;
    [self setNeedsLayout];
}

- (void)setSeperateGap:(CGFloat)seperateGap {
    _seperateGap = seperateGap;
    [self setNeedsLayout];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width, height, x, y;
    switch (self.layoutMode) {
        case YLButtonLayoutModeDefault: {
            height = contentRect.size.height;
            width =  contentRect.size.width * (1 - self.imageViewRatio) - self.seperateGap;
            x = contentRect.size.width - width;
            y = 0;
        }
            break;
        case YLButtonLayoutModeImageViewRight: {
            height = contentRect.size.height;
            width =  contentRect.size.width * (1 - self.imageViewRatio) - self.seperateGap;
            x = 0;
            y = 0;
        }
            break;
        case YLButtonLayoutModeImageViewTop: {
            height = contentRect.size.height * (1 - self.imageViewRatio) - self.seperateGap;
            width = contentRect.size.width;
            x = 0;
            y = contentRect.size.height - height;
        }
            break;
        case YLButtonLayoutModeImageViewBottom: {
            height = contentRect.size.height * (1 - self.imageViewRatio) - self.seperateGap;
            width = contentRect.size.width;
            x = 0;
            y = 0;
        }
            break;
        default:
            break;
    }
    return CGRectMake(x, y, width, height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width, height, x, y;
    switch (self.layoutMode) {
        case YLButtonLayoutModeDefault: {
            height = contentRect.size.height;
            width = contentRect.size.width * self.imageViewRatio;
            x = y = 0;
        }
            break;
        case YLButtonLayoutModeImageViewRight: {
            height = contentRect.size.height;
            width = contentRect.size.width * self.imageViewRatio;
            x = contentRect.size.width - width;
            y = 0;
        }
            break;
        case YLButtonLayoutModeImageViewTop: {
            height = contentRect.size.height * self.imageViewRatio;
            width = contentRect.size.width;
            x = 0;
            y = 0;
        }
            break;
        case YLButtonLayoutModeImageViewBottom: {
            height = contentRect.size.height * self.imageViewRatio;
            width = contentRect.size.width;
            x = 0;
            y = contentRect.size.height - height;
        }
            break;
        default:
            break;
    }
    return CGRectMake(x, y, width, height);
}

@end
