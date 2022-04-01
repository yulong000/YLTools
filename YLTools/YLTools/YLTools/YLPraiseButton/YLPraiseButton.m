//
//  YLPraiseButton.m
//  YLTools
//
//  Created by 魏宇龙 on 2022/2/10.
//  Copyright © 2022 weiyulong. All rights reserved.
//

#import "YLPraiseButton.h"

#pragma mark - 连续点赞次数显示

#define kPraiseCountImageScaleRatio      0.8

@interface YLPraiseCountLabel : UILabel

@property (nonatomic, assign) int count;

@end

@implementation YLPraiseCountLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

/**
 隐藏点赞文字
 */
- (void)hide {
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = @1;
    anima.toValue = @0;
    anima.duration = 0.5;
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anima forKey:@"opacityAniamtion"];
}

/**
 显示点赞文字
 */
- (void)show {
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = @0;
    anima.toValue = @1;
    anima.duration = 0.2;
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anima forKey:@"opacityAniamtion"];
}

- (void)setCount:(int)count {
    _count = count;
    self.attributedText = [self getAttributedString:count];
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anima.values = @[@1, @1.1, @0.95, @1];
    anima.calculationMode = kCAAnimationPaced;
    anima.duration = 0.2;
    anima.removedOnCompletion = YES;
    anima.fillMode = kCAFillModeBackwards;
    [self.layer addAnimation:anima forKey:@"scale"];
}

/**
 富文本设置label的图片内容
 
 @param num 当前赞的个数
 @return 要显示的富文本
 */
- (NSMutableAttributedString *)getAttributedString:(NSInteger)num {
    if(num >= 1000) return nil;
    
    NSMutableAttributedString * mutStr = [[NSMutableAttributedString alloc] init];
    if(num >= 100) {
        // 百位
        NSTextAttachment *count = [[NSTextAttachment alloc] init];
        count.image = [UIImage imageNamed:[NSString stringWithFormat:@"praise_num_%zd", num / 100]];
        count.bounds = CGRectMake(0, 0, count.image.size.width * kPraiseCountImageScaleRatio, count.image.size.height * kPraiseCountImageScaleRatio);
        [mutStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:count]];
    }
    
    if(num >= 10) {
        // 十位
        NSTextAttachment *count = [[NSTextAttachment alloc] init];
        count.image = [UIImage imageNamed:[NSString stringWithFormat:@"praise_num_%zd", num % 100 / 10]];
        count.bounds = CGRectMake(0, 0, count.image.size.width * kPraiseCountImageScaleRatio, count.image.size.height * kPraiseCountImageScaleRatio);
        [mutStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:count]];
    }
    
    // 个位
    NSTextAttachment *count = [[NSTextAttachment alloc] init];
    count.image = [UIImage imageNamed:[NSString stringWithFormat:@"praise_num_%zd", num % 10]];
    count.bounds = CGRectMake(0, 0, count.image.size.width * kPraiseCountImageScaleRatio, count.image.size.height * kPraiseCountImageScaleRatio);
    [mutStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:count]];
    
    // 等级
    NSString *levelImageName = num < 3 ? @"praise_level_1" : num <=10 ? @"praise_level_2" : @"praise_level_3";
    NSTextAttachment *level = [[NSTextAttachment alloc] init];
    level.image = [UIImage imageNamed:levelImageName];
    level.bounds = CGRectMake(0, 0, level.image.size.width * kPraiseCountImageScaleRatio, level.image.size.height * kPraiseCountImageScaleRatio);
    [mutStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:level]];

    return mutStr;
    
}

@end



@interface YLPraiseButton ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) YLPraiseCountLabel *countLabel;

@property (nonatomic, strong) NSMutableArray *emojiArr;
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@end

@implementation YLPraiseButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = [UIImage imageNamed:@"praise_thumb_normal"];
        self.iconView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.iconView];
        
        self.countLabel = [[YLPraiseCountLabel alloc] init];
        self.countLabel.count = 4;
        [self addSubview:self.countLabel];
        
//        [self.layer addSublayer:self.emitterLayer];
        
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.frame = self.bounds;
    self.countLabel.size_is(150, 30).bottom_is(-30).centerX_equalToSuper();
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.iconView.image = selected ? [UIImage imageNamed:@"praise_thumb_select"] : [UIImage imageNamed:@"praise_thumb_normal"];
}

#pragma mark 单击
- (void)btnClick:(UIControl *)btn {
    btn.selected = !btn.selected;
    self.countLabel.count += 1;
    if(btn.selected) {
        // 选中,
        [self impactFeedback];
        [self emojiAnimation];
    } else {
//        [self emojiAnimation];
    }
    
    if(self.selectBlock) {
        self.selectBlock(self, self.selected);
    }
}

#pragma mark 长按
- (void)longPress:(UILongPressGestureRecognizer *)ges {
    
}

#pragma mark 震动反馈
- (void)impactFeedback {
    if(@available(iOS 10.0, *)) {
        [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
    }
}

#pragma mark 表情动画
- (void)emojiAnimation {
    
    [self createEmitterLayer];
    
//    [self.emitterLayer removeFromSuperlayer];
//    self.emitterLayer = nil;
//    [self.layer addSublayer:self.emitterLayer];
//
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSString *icon in self.emojiArr) {
//        [arr addObject:[self cellWithIcon:[UIImage imageNamed:icon] name:icon]];
//    }
//
//
//    self.emitterLayer.emitterCells = arr;
//    self.emitterLayer.emitterPosition = self.centerPoint;
//    self.emitterLayer.beginTime = CACurrentMediaTime();
//    [self begin];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self stop];
//    });
}

- (void)begin {
    for (NSString *icon in self.emojiArr) {
        [self.emitterLayer setValue:@10 forKeyPath:[NSString stringWithFormat:@"emitterCells.%@.birthRate", icon]];
    }
//    self.emitterLayer.birthRate = 1;
}

- (void)stop {
    for (NSString *icon in self.emojiArr) {
        [self.emitterLayer setValue:@0 forKeyPath:[NSString stringWithFormat:@"emitterCells.%@.birthRate", icon]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.emitterLayer removeFromSuperlayer];
    });
//    self.emitterLayer.birthRate = 0;
}

- (CAEmitterLayer *)createEmitterLayer {
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.renderMode = kCAEmitterLayerBackToFront;
    layer.emitterSize = CGSizeMake(100, 100);
    layer.masksToBounds = NO;
    layer.birthRate = 1;
    [self.layer addSublayer:layer];
    
    // 表情
    NSMutableArray *emojiArr = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        // 随机选6个表情
        [emojiArr addObject:[NSString stringWithFormat:@"emoji_%d", arc4random() % 66 + 1]];
        
//        NSString *icon = [NSString stringWithFormat:@"emoji_%d", arc4random() % 66 + 1];
//        [emojiArr addObject:[self cellWithIcon:[UIImage imageNamed:icon] name:icon]];
    }
    
    // cells
    NSMutableArray *cellArr = [NSMutableArray array];
    for (NSString *icon in emojiArr) {
        [cellArr addObject:[self cellWithIconName:icon]];
    }
    layer.emitterCells = cellArr;
    layer.emitterPosition = self.centerPoint;
    layer.beginTime = CACurrentMediaTime();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSString *icon in emojiArr) {
            [layer setValue:@0 forKeyPath:[NSString stringWithFormat:@"emitterCells.%@.birthRate", icon]];
        }
    });
    [layer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:2];
    
    return layer;
}

//- (void)stop:(CAEmitterLayer *)layer {
//    for (NSString *icon in self.emojiArr) {
//        [layer setValue:@0 forKeyPath:[NSString stringWithFormat:@"emitterCells.%@.birthRate", icon]];
//    }
//}

- (CAEmitterCell *)cellWithIconName:(NSString *)name {
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    
    cell.contents = (__bridge id _Nullable)([UIImage imageNamed:name].CGImage);
    cell.name = name;
    
    cell.birthRate = 6;     // 每秒创建的发射粒子个数
    cell.lifetime = 2;      // 粒子的生命周期
    cell.lifetimeRange = 1;
    cell.scale = 0.35;       // 缩放比例
    
    cell.alphaRange = 1;
    cell.alphaSpeed = -1;

    cell.yAcceleration = 300;      // 下落效果
    cell.velocity = 500;
    cell.velocityRange = 10;
    cell.emissionLongitude = - M_PI_2;
    cell.emissionRange = M_PI_2;
    cell.spin = M_PI;
    cell.spinRange = M_PI;
    
    return cell;
}

#pragma mark - lazy load

- (NSMutableArray *)emojiArr {
    if(_emojiArr == nil) {
        _emojiArr = [NSMutableArray array];
        for (int i = 0; i < 6; i ++) {
            // 随机选6个表情
            [_emojiArr addObject:[NSString stringWithFormat:@"emoji_%d", arc4random() % 66 + 1]];
        }
    }
    return _emojiArr;
}

- (CAEmitterLayer *)emitterLayer {
    if(_emitterLayer == nil) {
        _emitterLayer = [CAEmitterLayer layer];
        _emitterLayer.renderMode = kCAEmitterLayerAdditive;
//        _emitterLayer.emitterShape = kCAEmitterLayerCircle;
//        _emitterLayer.emitterMode = kCAEmitterLayerOutline;
        _emitterLayer.emitterSize = CGSizeMake(100, 100);
        _emitterLayer.masksToBounds = NO;
    }
    return _emitterLayer;
}

@end
