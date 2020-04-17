//
//  AdvertisementModel.h
//  LiveShoppingApp
//
//  Created by weiyulong on 2019/6/5.
//  Copyright © 2019 JiaFuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdvertisementModel : NSObject

/**  主键id  */
@property (nonatomic, assign) int id;

/**  1.引导图, 2.广告图, 3.开屏广告  */
@property (nonatomic, assign) int adType;

/**  站点id  */
@property (nonatomic, assign) int siteId;

/**  栏目id  */
@property (nonatomic, assign) int columnId;

/**  图片url  */
@property (nonatomic, copy)   NSString *imagesUrl;

/**  点击广告后跳转的地方  */
@property (nonatomic, assign) int jumpType;

/**  跳转的id  */
@property (nonatomic, assign) int jumpId;

/**  跳转的链接  */
@property (nonatomic, copy)   NSString *jumpUrl;

@end

NS_ASSUME_NONNULL_END
