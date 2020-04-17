#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize  size;
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat left;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;

@property (assign, readonly, nonatomic) CGFloat maxX;
@property (assign, readonly, nonatomic) CGFloat maxY;
@property (assign, readonly, nonatomic) CGPoint centerPoint;

/**  保持最大X值不变,更改宽度  */
- (void)setWidthFixRight:(CGFloat)widthFixRight;
/**  保持最大Y值不变,更改高度  */
- (void)setHeightFixBottom:(CGFloat)heightFixBottom;

@end
