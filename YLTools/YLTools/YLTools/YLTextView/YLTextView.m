//
//  YLTextView.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLTextView.h"

@interface YLTextView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation YLTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.textColor = [UIColor grayColor];
        [self addSubview:self.placeholderLabel];
        
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.textColor = [UIColor grayColor];
        self.countLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.countLabel];
        
        self.textView = [[UITextView alloc] init];
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textView];
        self.maxLength = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.countLabel.hidden) {
        self.textView.frame = CGRectMake(self.layer.borderWidth,
                                         self.layer.borderWidth,
                                         self.bounds.size.width - self.layer.borderWidth * 2,
                                         self.bounds.size.height - self.layer.borderWidth * 2);
    } else {
        self.textView.frame = CGRectMake(self.layer.borderWidth,
                                         self.layer.borderWidth,
                                         self.bounds.size.width - self.layer.borderWidth * 2,
                                         self.bounds.size.height - 20 - self.layer.borderWidth * 2);
        self.countLabel.frame = CGRectMake(self.layer.borderWidth,
                                           self.bounds.size.height - 20 - self.layer.borderWidth,
                                           self.bounds.size.width - self.layer.borderWidth * 2 - 3,
                                           20);
    }
    CGFloat x = self.textView.textContainerInset.left + self.layer.borderWidth + 5;
    CGFloat y = self.textView.textContainerInset.top + self.layer.borderWidth;
    CGSize s = [self.placeholderLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.placeholderLabel.frame = CGRectMake(x, y, s.width, s.height);
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textView.font = self.placeholderLabel.font = self.countLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textView.textColor = textColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = _placeholder;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = [attributedPlaceholder copy];
    self.placeholderLabel.attributedText = _attributedPlaceholder;
}

- (void)setShowTextLength:(BOOL)showTextLength {
    _showTextLength = showTextLength;
    self.countLabel.hidden = !(_maxLength > 0 && _showTextLength);
    [self setNeedsLayout];
}

- (void)setMaxLength:(NSInteger)maxLength {
    _maxLength = maxLength;
    self.countLabel.text = [NSString stringWithFormat:@"0/%d", (int)maxLength];
    self.countLabel.hidden = !(_maxLength > 0 && _showTextLength);
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    self.textView.text = [text copy];
    [self textViewDidChange:self.textView];
}

- (NSString *)text {
    return self.textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
    if(self.maxLength > 0 && textView.markedTextRange == nil) {
        if(textView.text.length > self.maxLength) {
            textView.text = [textView.text substringToIndex:self.maxLength];
        }
        if(self.showTextLength) {
            self.countLabel.text = [NSString stringWithFormat:@"%d/%d", (int)textView.text.length, (int)self.maxLength];
        }
    }
}

@end
