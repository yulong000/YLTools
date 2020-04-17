#import <UIKit/UIKit.h>

@interface UIImage (category)

/**
 *  裁剪圆形图片 (已最小的边长为直径, 裁剪中间部位)
 *
 *  @param image       原始图片, 最好是方形图片
 *  @param borderWidth 边框的宽度
 *  @param borderColor 边框的颜色
 *
 *  @return 裁剪后的图片
 */
+ (instancetype)circleImage:(UIImage *)image
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor;

/**
 *  裁剪圆形图片 （以宽度最大边界）
 *
 *  @param borderWidth 边框的宽度
 *  @param borderColor 边框的颜色
 *
 *  @return 裁剪后的图片
 */
- (instancetype)circleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 获取纯色的图片
 
 @param color 图片颜色
 @param size 图片大小
 @return 图片
 */
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 获取可拉伸的纯色图片

 @param color 图片颜色
 @return 图片
 */
+ (instancetype)stretchableImageWithColor:(UIColor *)color;

/**
 全屏截图
 */
+ (instancetype)screenImage;

/**
 对某个view截图
 */
+ (instancetype)imageWithView:(UIView *)view;


/**
 *  获取网络图片的 size
 *
 *  @param imageURL 图片的 url 地址 (NSSring / NSURL)
 *
 */
+ (CGSize)imageSizeWithURL:(id)imageURL;



/**
 *  获取图片上某个点的颜色
 *
 *  @param point 点坐标
 *
 *  @return 获取到的颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;




/// ------------------------------------
/// @name 高斯模糊
/// ------------------------------------
- (UIImage *)applyLightEffectAtFrame:(CGRect)frame;
- (UIImage *)applyExtraLightEffectAtFrame:(CGRect)frame;
- (UIImage *)applyDarkEffectAtFrame:(CGRect)frame;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor atFrame:(CGRect)frame;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage
                         atFrame:(CGRect)frame;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                 iterationsCount:(NSInteger)iterationsCount
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage
                         atFrame:(CGRect)frame;

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                 iterationsCount:(NSInteger)iterationsCount
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;



@end
