//
//  YLRichTextView.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLRichTextView : UIView

/**  富文本内容  */
@property (nonatomic, copy)   NSString *content;

/**  高度发生变化后会回调  */
@property (nonatomic, copy  ) void (^heightChangedBlock)(CGFloat height, YLRichTextView *textView);


@end

NS_ASSUME_NONNULL_END
