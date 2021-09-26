
#import "UILabel+category.h"
#import <objc/runtime.h>

static const char UILabelClickedBlockKey = '\0';

@implementation UILabel (category)
#pragma mark - 获取label的size 文字自适应
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth {
    return [self sizeWithMaxWidth:maxWidth attributes:nil];
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)lines {
    return [self sizeWithMaxWidth:maxWidth numberOfLines:lines attributes:nil];
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth attributes:(NSDictionary *)attributes {
    return [self sizeWithMaxWidth:maxWidth numberOfLines:0 attributes:attributes];
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)lines attributes:(NSDictionary *)attributes {
    if(attributes) {
        self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    }
    self.numberOfLines = lines;
    CGSize size = [self sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    if(lines == 1) {
        // 单行
        size.width = MIN(maxWidth, size.width);
    }
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    return size;
}

- (CGSize)sizeWithSingleLineMaxWidth:(CGFloat)maxWidth fixedHeight:(CGFloat)fixedHeight {
    CGSize size = [self sizeWithSingleLineFixedHeight:fixedHeight];
    if(size.width > maxWidth) {
        size.width = maxWidth;
        CGRect frame = self.frame;
        frame.size = size;
        self.frame = frame;
    }
    return size;
}

- (CGSize)sizeWithSingleLineFixedHeight:(CGFloat)fixedHeight {
    return [self sizeWithSingleLineAutoWidthWithPadding:0 fixedHeight:fixedHeight];
}

- (CGSize)sizeWithSingleLineAutoWidthWithPadding:(CGFloat)padding fixedHeight:(CGFloat)fixedHeight {
    return [self sizeWithSingleLineAutoWidthWithPadding:padding minWidth:padding * 2 fixedHeight:fixedHeight];
}

- (CGSize)sizeWithSingleLineAutoWidthWithPadding:(CGFloat)padding minWidth:(CGFloat)minWidth fixedHeight:(CGFloat)fixedHeight {
    self.textAlignment = NSTextAlignmentCenter;
    self.numberOfLines = 1;
    CGSize size = [self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    size.width = MAX(minWidth, size.width + padding * 2);
    size.height = fixedHeight;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    return size;
}

+ (instancetype)labelWithFont:(UIFont *)font {
    return [self labelWithFont:font textColor:[UIColor blackColor]];
}

+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    return [self labelWithFont:font textColor:textColor alignment:NSTextAlignmentLeft];
}

+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment {
    return [self labelWithText:@"" textColor:textColor alignment:alignment font:font];
}

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    return [self labelWithText:text textColor:textColor alignment:NSTextAlignmentLeft font:font];
}

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.font = font;
    return label;
}

#pragma mark - 添加单击操作
- (void)setClickedBlock:(UILabelClickedBlock)clickedBlock {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    [self willChangeValueForKey:@"clickedBlock"];
    objc_setAssociatedObject(self, &UILabelClickedBlockKey, clickedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"clickedBlock"];
}
- (UILabelClickedBlock)clickedBlock {
    return objc_getAssociatedObject(self, &UILabelClickedBlockKey);
}

- (void)tap {
    if(self.clickedBlock) {
        self.clickedBlock(self);
    }
}
#pragma mark -

@end
