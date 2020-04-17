//
//  YLTextView.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLTextView : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, copy)   NSString *text;

@property (nonatomic, strong, readonly) UITextView *textView;

@property (nonatomic, copy, nullable)   NSString *placeholder;
@property (nonatomic, copy, nullable)   NSAttributedString *attributedPlaceholder;

/**  文本内容的最大长度, 默认不限制  */
@property (nonatomic, assign) NSInteger maxLength;
/**  是否显示内容长度统计, maxLength > 0 是有效  */
@property (nonatomic, assign) BOOL showTextLength;

@end

NS_ASSUME_NONNULL_END
