//
//  YLWaterFlowLayout.h
//  YLWaterFlowLayout
//
//  Created by weiyulong on 2020/7/27.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YLWaterFlowLayoutStyle) {
    YLWaterFlowLayoutStyleVerticalEqualWidth,           // 纵向等宽
    YLWaterFlowLayoutStyleHorizontalEqualHeight,        // 横向等高
};

#pragma mark - YLWaterFlowLayout delegate

@protocol YLWaterFlowLayoutDelegate <NSObject>


/// 返回item的大小，纵向时，width随便传，横向时height随便传
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGSize)sizeForHeaderInSection:(NSInteger)section;
- (CGSize)sizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)edgeInsetsInSection:(NSInteger)section;

@end

#pragma mark - layout

@interface YLWaterFlowLayout : UICollectionViewLayout

/// 代理
@property (nonatomic, weak)   id <YLWaterFlowLayoutDelegate> delegate;

/// 列数/行数, default = 2
@property (nonatomic, assign) NSUInteger columnCount;
/// 列间距, default = 10
@property (nonatomic, assign) CGFloat columnMargin;
/// 行间距，default = 10
@property (nonatomic, assign) CGFloat rowMargin;
/// 上下左右间距，default = UIEdgeInsetsMake(10, 10, 10, 10)
@property (nonatomic, assign) UIEdgeInsets sectionEdgeInsets;

/// 头部视图大小，default = CGSizeZero
@property (nonatomic, assign) CGSize sectionHeaderSize;
/// 尾部视图大小，default = CGSizeZero
@property (nonatomic, assign) CGSize sectionFooterSize;
/// 分组间的间距，default = 10
@property (nonatomic, assign) CGFloat sectionMargin;


- (instancetype)initWithLayoutStyle:(YLWaterFlowLayoutStyle)layoutStyle;

@end

NS_ASSUME_NONNULL_END
