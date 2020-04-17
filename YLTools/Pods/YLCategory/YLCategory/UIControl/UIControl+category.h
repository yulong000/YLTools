//
//  UIControl+category.h
//  YLCategory
//
//  Created by weiyulong on 2018/7/24.
//  Copyright © 2018年 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIControlClickedBlock)(UIControl *control);

@interface UIControl (category)

/**
 点击回调
 */
@property (nonatomic, copy)   UIControlClickedBlock clickedBlock;

/**  扩大点击区域  */
- (void)addClickArea:(UIEdgeInsets)insets;
@end
