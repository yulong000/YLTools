//
//  YLPraiseButton.h
//  YLTools
//
//  Created by 魏宇龙 on 2022/2/10.
//  Copyright © 2022 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPraiseButton : UIControl

@property (nonatomic, copy)   void (^selectBlock)(YLPraiseButton *btn, BOOL selected);

@end

NS_ASSUME_NONNULL_END
