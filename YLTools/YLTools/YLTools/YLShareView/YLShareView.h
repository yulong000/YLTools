//
//  YLShareView.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^YLShareResultHandler)(BOOL success);

@interface YLShareView : UIView

/**
 分享到社交平台, 需要在AppDelegate对友盟进行注册

 @param title 分享的标题
 @param desc 分享的内容
 @param thumbImage 分享的图片 image or url
 @param webpageUrl 分享的跳转链接
 @param resultHandler 分享后的回调
 */
+ (void)shareWithTitle:(NSString *)title
                  desc:(NSString *)desc
            thumbImage:(id)thumbImage
            webpageUrl:(NSString *)webpageUrl
         resultHandler:(YLShareResultHandler _Nullable)resultHandler;

@end

NS_ASSUME_NONNULL_END
