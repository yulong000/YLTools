//
//  YLWaterFlowLayout.m
//  YLWaterFlowLayout
//
//  Created by weiyulong on 2020/7/27.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLWaterFlowLayout.h"


@interface YLWaterFlowLayout ()

@property (nonatomic, assign) YLWaterFlowLayoutStyle layoutStyle;

/// 所有的布局属性
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> *attrArr;
/// 记录最后一行的值
@property (nonatomic, strong) NSMutableArray <NSNumber *> *maxArr;

@end

@implementation YLWaterFlowLayout

- (instancetype)initWithLayoutStyle:(YLWaterFlowLayoutStyle)layoutStyle {
    if(self = [super init]) {
        self.layoutStyle = layoutStyle;
        self.columnCount = 2;
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionMargin = 10;
        self.sectionEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.sectionFooterSize = CGSizeZero;
        self.sectionHeaderSize = CGSizeZero;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.attrArr removeAllObjects];
    [self.maxArr removeAllObjects];
    
    switch (self.layoutStyle) {
        case YLWaterFlowLayoutStyleVerticalEqualWidth:
            // 纵向
            for (int i = 0 ; i < self.columnCount; i ++) {
                [self.maxArr addObject:@(0)];
            }
            break;
        case YLWaterFlowLayoutStyleHorizontalEqualHeight:
            // 横向
            for (int i = 0 ; i < self.columnCount; i ++) {
                [self.maxArr addObject:@(0)];
            }
            break;
        default:
            break;
    }
    
    NSInteger sectionCount =  [self.collectionView numberOfSections];
    for(int section = 0; section < sectionCount; section ++){
        UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:NSNotFound inSection:section]];
        [self.attrArr addObject:headerAttr];
        
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < rowCount; row ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *itemAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrArr addObject:itemAttr];
        }
        
        UICollectionViewLayoutAttributes *footerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:NSNotFound inSection:section]];
        [self.attrArr addObject:footerAttr];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *itemAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame = CGRectZero;
    CGSize size = [self.delegate sizeForItemAtIndexPath:indexPath];
    switch (self.layoutStyle) {
        case YLWaterFlowLayoutStyleVerticalEqualWidth: {
            // 纵向
            CGFloat totalWidth = self.collectionView.frame.size.width;
            UIEdgeInsets insets = [self edgeInsetsInSection:indexPath.section];
            size.width = (totalWidth - insets.left - insets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
            frame.size = size;
            
            int colume = 0;
            CGFloat minY = [self.maxArr.firstObject floatValue];
            for (int i = 1; i < self.maxArr.count; i ++) {
                CGFloat max = [self.maxArr[i] floatValue];
                if(minY >= max) {
                    minY = max;
                    colume = i;
                }
            }
            frame.origin.x = insets.left + colume * (size.width + self.columnMargin);
            frame.origin.y = minY;
            if(indexPath.item >= self.columnCount) {
                // 不是第一排
                frame.origin.y = minY + self.rowMargin;
            } else {
                frame.origin.y = minY + insets.top;
            }
            self.maxArr[colume] = @(CGRectGetMaxY(frame));
        }
            break;
        case YLWaterFlowLayoutStyleHorizontalEqualHeight: {
            // 横向
            CGFloat totalHeight = self.collectionView.frame.size.height;
            UIEdgeInsets insets = [self edgeInsetsInSection:indexPath.section];
            size.height = (totalHeight - insets.top - insets.bottom - (self.columnCount - 1) * self.rowMargin) / self.columnCount;
            frame.size = size;
            
            int row = 0;
            CGFloat minX = [self.maxArr.firstObject floatValue];
            for (int i = 1; i < self.maxArr.count; i ++) {
                CGFloat max = [self.maxArr[i] floatValue];
                if(minX >= max) {
                    minX = max;
                    row = i;
                }
            }
            frame.origin.y = insets.top + row * (size.height + self.rowMargin);
            if(indexPath.item >= self.columnCount) {
                // 不是第一排
                frame.origin.x = minX + self.columnMargin;
            } else {
                frame.origin.x = minX + insets.left;
            }
            self.maxArr[row] = @(CGRectGetMaxX(frame));
        }
            break;
        default:
            break;
    }
    itemAttr.frame = frame;
    return itemAttr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    CGRect frame = CGRectZero;
    CGFloat max = 0;
    UIEdgeInsets insets = [self edgeInsetsInSection:indexPath.section];
    if(elementKind == UICollectionElementKindSectionHeader) {
        frame.size = [self headerSizeInSection:indexPath.section];
        if(indexPath.section > 0) {
            UICollectionViewLayoutAttributes *preFooterAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:NSNotFound inSection:indexPath.section - 1]];
            switch (self.layoutStyle) {
                case YLWaterFlowLayoutStyleVerticalEqualWidth:
                    // 纵向
                    frame.origin.y = CGRectGetMaxY(preFooterAttr.frame) + self.sectionMargin;
                    max = CGRectGetMaxY(frame);
                    break;
                case YLWaterFlowLayoutStyleHorizontalEqualHeight:
                    // 横向
                    frame.origin.x = CGRectGetMaxX(preFooterAttr.frame) + self.sectionMargin;
                    max = CGRectGetMaxX(frame);
                    break;
                default:
                    break;
            }
        } else {
            switch (self.layoutStyle) {
                case YLWaterFlowLayoutStyleVerticalEqualWidth:
                    // 纵向
                    max = CGRectGetMaxY(frame);
                    break;
                case YLWaterFlowLayoutStyleHorizontalEqualHeight:
                    // 横向
                    max = CGRectGetMaxX(frame);
                    break;
                default:
                    break;
            }
        }
    } else if (elementKind == UICollectionElementKindSectionFooter) {
        frame.size = [self footerSizeInSection:indexPath.section];
        switch (self.layoutStyle) {
            case YLWaterFlowLayoutStyleVerticalEqualWidth:
                // 纵向
                frame.origin.y = [self getItemsMaxYInSection:indexPath.section] + insets.bottom;
                max = CGRectGetMaxY(frame);
                break;
            case YLWaterFlowLayoutStyleHorizontalEqualHeight:
                // 横向
                frame.origin.x = [self getItemsMaxXInSection:indexPath.section] + insets.right;
                max = CGRectGetMaxX(frame);
                break;
            default:
                break;
        }
    }
    [self.maxArr removeAllObjects];
    for (int i = 0 ; i < self.columnCount; i ++) {
        [self.maxArr addObject:@(max)];
    }
    attr.frame = frame;
    return attr;
}

- (CGSize)collectionViewContentSize {
    NSInteger sectionCount = [self.collectionView numberOfSections];
    UIEdgeInsets insets = [self edgeInsetsInSection:sectionCount - 1];
    CGSize footerSize = [self footerSizeInSection:sectionCount - 1];
    CGFloat maxContent = [self.maxArr.firstObject floatValue];
    for (int i = 1; i < self.maxArr.count; i ++) {
        CGFloat max = [self.maxArr[i] floatValue];
        if(maxContent < max) {
            maxContent = max;
        }
    }
    switch (self.layoutStyle) {
        case YLWaterFlowLayoutStyleVerticalEqualWidth: {
            // 纵向
            return CGSizeMake(0, maxContent + insets.bottom + footerSize.height);
        }
            break;
        case YLWaterFlowLayoutStyleHorizontalEqualHeight: {
            // 横向
            return CGSizeMake(maxContent + insets.right + footerSize.width, 0);
        }
            break;
        default:
            break;
    }
    return CGSizeZero;
}

#pragma mark 设置列数
- (void)setColumnCount:(NSUInteger)columnCount {
    _columnCount = MAX(1, columnCount);
}

#pragma mark 获取分组内，item的Y的最大值
- (CGFloat)getItemsMaxYInSection:(NSInteger)section {
    NSInteger count = 0;
    for (int i = 0; i <= section; i ++) {
        count += [self.collectionView numberOfItemsInSection:i] + 2;
    }
    count -= 1;
    
    if(self.attrArr.count >= count) {
        // 取最后一行，进行比较
        NSArray <UICollectionViewLayoutAttributes *> *arr = [self.attrArr subarrayWithRange:NSMakeRange(count - self.columnCount, self.columnCount)];
        CGFloat maxY = CGRectGetMaxY(arr.firstObject.frame);
        for (UICollectionViewLayoutAttributes *attr in arr) {
            maxY = MAX(maxY, CGRectGetMaxY(attr.frame));
        }
        return maxY;
    }
    return 0;
}

#pragma mark 获取分组内，item的X的最大值
- (CGFloat)getItemsMaxXInSection:(NSInteger)section {
    NSInteger count = 0;
    for (int i = 0; i <= section; i ++) {
        count += [self.collectionView numberOfItemsInSection:i] + 2;
    }
    count -= 1;
    
    if(self.attrArr.count >= count) {
        // 取最后一行，进行比较
        NSArray <UICollectionViewLayoutAttributes *> *arr = [self.attrArr subarrayWithRange:NSMakeRange(count - self.columnCount, self.columnCount)];
        CGFloat maxX = CGRectGetMaxX(arr.firstObject.frame);
        for (UICollectionViewLayoutAttributes *attr in arr) {
            maxX = MAX(maxX, CGRectGetMaxX(attr.frame));
        }
        return maxX;
    }
    return 0;
}

#pragma mark 头部视图的size
- (CGSize)headerSizeInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(sizeForHeaderInSection:)]) {
        return [self.delegate sizeForHeaderInSection:section];
    }
    return self.sectionHeaderSize;
}

#pragma mark 底部视图的size
- (CGSize)footerSizeInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(sizeForFooterInSection:)]) {
        return [self.delegate sizeForFooterInSection:section];
    }
    return self.sectionFooterSize;
}

#pragma mark 分组的边距
- (UIEdgeInsets)edgeInsetsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(edgeInsetsInSection:)]) {
        return [self.delegate edgeInsetsInSection:section];
    }
    return self.sectionEdgeInsets;
}


#pragma mark - lazy load

- (NSMutableArray *)attrArr {
    if(_attrArr == nil) {
        _attrArr = [NSMutableArray array];
    }
    return _attrArr;
}

- (NSMutableArray *)maxArr {
    if(_maxArr == nil) {
        _maxArr = [NSMutableArray array];
    }
    return _maxArr;
}

@end
