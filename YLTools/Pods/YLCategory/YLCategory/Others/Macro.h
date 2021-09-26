//
//  Macro.h
//  YLCategory
//
//  Created by weiyulong on 2018/10/30.
//  Copyright © 2018 WYL. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

/****************************************  尺寸  ***********************************/

//屏幕宽、高
#ifndef kScreenWidth
#define kScreenWidth                        [UIScreen mainScreen].bounds.size.width
#endif

#ifndef kScreenHeight
#define kScreenHeight                       [UIScreen mainScreen].bounds.size.height
#endif

#ifndef kStatusBarHeight
#define kStatusBarHeight                    [UIApplication sharedApplication].statusBarFrame.size.height
#endif

#ifndef kIsPad
#define kIsPad                              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

// 自然分辨率
#define kScreenScale                        [[UIScreen mainScreen] scale]
// 全面屏的安全区域
#define kSafeAreaInsets                     ^UIEdgeInsets {if (@available(iOS 11.0, *)) return [UIApplication sharedApplication].delegate.window.safeAreaInsets; else return UIEdgeInsetsZero;}()
// 上面的安全区域
#define kTopSafeAreaHeight                  kSafeAreaInsets.top
// 下面的安全区域
#define kBottomSafeAreaHeight               kSafeAreaInsets.bottom
// 是否是全面屏
#define kIsFullScreen                       (kBottomSafeAreaHeight > 0)

#define kTabbarHeight                       (kIsFullScreen ? 83.0f : 49.0f)         // 下面tabbar的高度
#define kNavTotalHeight                     (kStatusBarHeight + 44.0f)              // 上面导航栏总高度


/****************************************  颜色  ***********************************/


// 纯白色
#define WhiteColor                  [UIColor whiteColor]
// 纯黑色
#define BlackColor                  [UIColor blackColor]
// 透明色
#define ClearColor                  [UIColor clearColor]
// 灰色
#define GrayColor                   [UIColor grayColor]
// 深灰色
#define DarkGrayColor               [UIColor darkGrayColor]   // 0.333 white
// 亮灰色
#define LightGrayColor              [UIColor lightGrayColor]  // 0.667 white
// 红色
#define RedColor                    [UIColor redColor]
// 绿色
#define GreenColor                  [UIColor greenColor]
// 橙色
#define OrangeColor                 [UIColor orangeColor]
// 黄色
#define YellowColor                 [UIColor yellowColor]
// 蓝色
#define BlueColor                   [UIColor blueColor]
// r, g, b ,a 颜色
#define RGBA(r, g, b, a)            [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
// 随机颜色
#define RandomColor                 [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1]
// 十六进制获取颜色
#define UIColorFromHex(s)           [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]
// 半透明黑
#define BlackColorAlpha(a)          [UIColor colorWithWhite:0 alpha:a]
// 半透明白
#define WhiteColorAlpha(a)          [UIColor colorWithWhite:1 alpha:a]
// 自定义灰色
#define GrayColorComponent(w)       [UIColor colorWithWhite:w alpha:1]

/****************************************  数据类型转换  ***********************************/

// int float -> string
#define NSStringFromInt(int)            [NSString stringWithFormat:@"%d", int]
#define NSStringFromUInt(int)           [NSString stringWithFormat:@"%u", int]
#define NSStringFromInteger(integer)    [NSString stringWithFormat:@"%zd", integer]
#define NSStringFromUInteger(integer)   [NSString stringWithFormat:@"%tu", integer]
#define NSStringFromFloat(float)        [NSString stringWithFormat:@"%f", float]
#define NSStringFromFloatPrice(float)   [NSString stringWithFormat:@"%.2f", float]



/****************************************  字体  ***********************************/

// 字体大小
#define Font(size)                      [UIFont systemFontOfSize:size]
#define BoldFont(size)                  [UIFont boldSystemFontOfSize:size]


/****************************************  快捷方法  ***********************************/

// weakself
#define WeakObject(obj)                 __weak typeof(obj) weak##obj = obj;

// 根据图片名字构建image
#define ImageWithName(imageName)        [UIImage imageNamed:imageName]
// 从中心拉伸图片
#define StretchImageName(imageName)     [ImageWithName(imageName) \
                                        stretchableImageWithLeftCapWidth:ImageWithName(imageName).size.width * 0.5 \
                                        topCapHeight:ImageWithName(imageName).size.height * 0.5]
#define StretchImage(image)             [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 \
                                        topCapHeight:image.size.height * 0.5]
// 从指定位置拉伸图片
#define StretchImageNameWith(imageName, left, top)  [ImageWithName(imageName) \
                                                    stretchableImageWithLeftCapWidth:left topCapHeight:top]
#define StretchImageWith(image, left, top)          [image stretchableImageWithLeftCapWidth:left topCapHeight:top]


// 文件路径
#define kDocumentPath                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define kCachePath                      [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define kBundlePath(file)               [[NSBundle mainBundle] pathForResource:file ofType:nil]

// app版本号
#define kAPP_Version                     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// building 号
#define kAPP_Build_Number                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// app Name
#define kAPP_Name                        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// 系统版本号
#define kSystem_version                  [[UIDevice currentDevice].systemName stringByAppendingFormat:@" %@", [UIDevice currentDevice].systemVersion]

//  appDelegate
#define kAppDelegate                    [UIApplication sharedApplication].delegate
//  keyWindow
#define kAppKeyWindow                   ^UIWindow * { \
                                            if (@available(iOS 13.0, *)) { \
                                                    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) { \
                                                        if (scene.activationState == UISceneActivationStateForegroundActive) { \
                                                            for (UIWindow *window in scene.windows) { \
                                                                if (window.isKeyWindow) { \
                                                                    return window; \
                                                                } \
                                                            } \
                                                        } \
                                                    } \
                                                return [UIApplication sharedApplication].delegate.window; \
                                            } else { \
                                                return [UIApplication sharedApplication].keyWindow; \
                                            } \
                                        }()

#endif /* Macro_h */
