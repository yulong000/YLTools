
#import <UIKit/UIKit.h>

typedef void (^UILabelClickedBlock)(UILabel *label);

@interface UILabel (category)

/**  添加点击事件  */
@property (nonatomic, copy) UILabelClickedBlock clickedBlock;

/**
 获取label的size, 文字自适应, 不限高度

 @param maxWidth 最大的宽度
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth;

/**
 获取label的size, 文字自适应
 
 @param maxWidth 最大的宽度
 @param lines 行数
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)lines;

/**
 获取label的size, 文字自适应, 不限高度 
 
 @param maxWidth 最大的宽度
 @param attributes 文字属性
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth attributes:(NSDictionary *)attributes;


/**
 获取label的size, 文字自适应

 @param maxWidth 最大的宽度
 @param lines 行数
 @param attributes 文字属性
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)lines attributes:(NSDictionary *)attributes;




@end
