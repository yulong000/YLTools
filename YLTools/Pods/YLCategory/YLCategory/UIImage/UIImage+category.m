#import "UIImage+category.h"
#import <float.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (category)

#pragma mark - 根据边框宽度和颜色，裁剪出圆形图片
+ (instancetype)circleImage:(UIImage *)image
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor {
    // 1.开启上下文
    CGFloat imageW = image.size.width + 2 * borderWidth;
    CGFloat imageH = image.size.height + 2 * borderWidth;
    CGFloat minWH = MIN(imageW, imageH);//取最小的边
    CGSize imageSize = CGSizeMake(minWH, minWH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 2.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 3.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = minWH * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 4.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    CGFloat x;
    CGFloat y;
    if(imageW > imageH) {
        x = bigRadius - imageW * 0.5;
        y = borderWidth;
    } else {
        x = borderWidth;
        y = bigRadius - imageH * 0.5;
    }
    [image drawInRect:CGRectMake(x, y, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 裁剪圆形图片
- (instancetype)circleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [UIImage circleImage:self borderWidth:borderWidth borderColor:borderColor];
}

#pragma mark - 获取图片上某个点的颜色
- (UIColor *)colorAtPixel:(CGPoint)point {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - 高斯模糊
- (UIImage *)croppedImageAtFrame:(CGRect)frame {
    frame = CGRectMake(frame.origin.x * self.scale, frame.origin.y * self.scale, frame.size.width * self.scale, frame.size.height * self.scale);
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, frame);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[self scale] orientation:[self imageOrientation]];
    CGImageRelease(newImageRef);
    return newImage;
}

#pragma mark Marge two Images
- (UIImage *)addImageToImage:(UIImage *)img atRect:(CGRect)cropRect {
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    CGPoint pointImg1 = CGPointMake(0,0);
    [self drawAtPoint:pointImg1];
    
    CGPoint pointImg2 = cropRect.origin;
    [img drawAtPoint: pointImg2];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)applyLightEffectAtFrame:(CGRect)frame {
    UIImage *blurredFrame = [[self croppedImageAtFrame:frame] applyLightEffect];
    return [self addImageToImage:blurredFrame atRect:frame];
}

- (UIImage *)applyExtraLightEffectAtFrame:(CGRect)frame {
    UIImage *blurredFrame = [[self croppedImageAtFrame:frame] applyExtraLightEffect];
    return [self addImageToImage:blurredFrame atRect:frame];
}

- (UIImage *)applyDarkEffectAtFrame:(CGRect)frame {
    UIImage *blurredFrame = [[self croppedImageAtFrame:frame] applyDarkEffect];
    return [self addImageToImage:blurredFrame atRect:frame];
}

- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor atFrame:(CGRect)frame {
    UIImage *blurredFrame = [[self croppedImageAtFrame:frame] applyTintEffectWithColor:tintColor];
    return [self addImageToImage:blurredFrame atRect:frame];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage
                         atFrame:(CGRect)frame {
    return [self applyBlurWithRadius:blurRadius iterationsCount:3 tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:maskImage atFrame:frame];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                 iterationsCount:(NSInteger)iterationsCount
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage
                         atFrame:(CGRect)frame {
    UIImage *blurredFrame = [[self croppedImageAtFrame:frame] applyBlurWithRadius:blurRadius iterationsCount:iterationsCount tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:maskImage];
    return [self addImageToImage:blurredFrame atRect:frame];
}

- (UIImage *)applyLightEffect {
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyExtraLightEffect {
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyDarkEffect {
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor {
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount = (int)CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage {
    return [self applyBlurWithRadius:blurRadius iterationsCount:3 tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:maskImage];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                 iterationsCount:(NSInteger)iterationsCount
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage {
    // check pre-conditions
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = {CGPointZero, self.size};
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        BOOL resultImageAtInputBuffer = YES;
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            for (int i = 0; i+1 < iterationsCount; i+=2) {
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            }
            if (iterationsCount % 2) {
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
                resultImageAtInputBuffer = NO;
            }
        }
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur ^ resultImageAtInputBuffer) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            } else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!resultImageAtInputBuffer)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (resultImageAtInputBuffer)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // set up output context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // draw base image
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // draw effect image
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // add in color tint
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // output image is ready
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}
#pragma mark - 获取网络图片的 size
+ (CGSize)imageSizeWithURL:(id)imageURL {
    NSURL *URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]) {
        URL = imageURL;
    } else if([imageURL isKindOfClass:[NSString class]]) {
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil) {
        return CGSizeZero;
    }
    
#ifdef dispatch_main_sync_safe
    // 引入了 SDWebImage, 检测是否有缓存
    NSString *absoluteString = URL.absoluteString;
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString]) {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image) {
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:absoluteString];
        }
        if(image) {
            return image.size;
        }
    }
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString *pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    // 下载文件头，获取文件大小
    if([pathExtendsion isEqualToString:@"png"]) {
        size = [self PNGImageSizeWithRequest:request];
    } else if([pathExtendsion isEqual:@"gif"]) {
        size = [self GIFImageSizeWithRequest:request];
    } else {
        size = [self JPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size)) {
        // 获取失败，下载整个图片
        NSData  *data  = [NSData dataWithContentsOfURL:URL];
        UIImage *image = [UIImage imageWithData:data];
        if(image) {
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    return size;
}

+ (NSData *)dataWithRequest:(NSMutableURLRequest *)request {
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:NULL];
//    #define kGetImageDataHeaderFieldTimeoutInterval 1   // 超时时间 1s
//    __block NSData *data = nil;
//    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable dataRespose, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        if(error == nil && dataRespose.length)
//        {
//            data = dataRespose;
//        }
//        dispatch_semaphore_signal(semaphore);
//    }];
//    [dataTask resume];
//    dispatch_semaphore_wait(semaphore, kGetImageDataHeaderFieldTimeoutInterval);
    return data;
}

+ (CGSize)PNGImageSizeWithRequest:(NSMutableURLRequest *)request {
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData *data = [self dataWithRequest:request];
    if(data.length == 8) {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+ (CGSize)GIFImageSizeWithRequest:(NSMutableURLRequest *)request {
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData *data = [self dataWithRequest:request];
    if(data.length == 4) {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+ (CGSize)JPGImageSizeWithRequest:(NSMutableURLRequest *)request {
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData *data = [self dataWithRequest:request];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {
        // 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {
                // 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {
                // 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

#pragma mark 获取纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){CGPointZero, size});
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 获取可拉伸的纯色图片
+ (instancetype)stretchableImageWithColor:(UIColor *)color {
    UIImage *image = [self imageWithColor:color size:CGSizeMake(4, 4)];
    return [image stretchableImageWithLeftCapWidth:2 topCapHeight:2];
}

#pragma mark 对某个view截图
+ (instancetype)imageWithView:(UIView *)view {
    if(view == nil) return [[UIImage alloc] init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    [[UIColor clearColor] setFill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 截屏
+ (instancetype)screenImage {
    return [self imageWithView: [UIApplication sharedApplication].keyWindow];
}

@end
