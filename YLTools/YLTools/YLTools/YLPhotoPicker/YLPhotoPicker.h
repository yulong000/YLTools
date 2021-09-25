//
//  YLPhotoPicker.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXPhotoPicker.h"


/*
 若要使用相册和相机功能, 需要在info里配置以下信息,否则会crash
 Privacy - Photo Library Usage Description                  为了给您提供更好的服务, 需要使用您的相册 (可自定义)
 Privacy - Photo Library Additions Usage Description        为了给您提供更好的服务, 需要使用您的相册 (可自定义)
 Privacy - Camera Usage Description                         为了给您提供更好的服务, 需要使用您的相机 (可自定义)
 Privacy - Microphone Usage Description                     为了给您提供更好的服务, 需要使用您的麦克风 (可自定义)
 */

NS_ASSUME_NONNULL_BEGIN


/**  从相册选择照片回调  */
typedef void (^YLPhotoPickerResultHandler)(NSArray <HXPhotoModel *> *photoModelArr);
/**  从相机拍摄照片回调  */
typedef void (^YLCameraPhotoPickerResultHandler)(UIImage *cameraImage, NSDictionary<UIImagePickerControllerInfoKey,id> *info);


/**  从相册选择视频回调  */
typedef void (^YLVideoPickerResultHandler)(NSArray <HXPhotoModel *> *videoModelArr);
/**  从相机拍摄视频回调  */
typedef void (^YLCameraVideoPickerResultHandler)(NSURL *cameraVideoUrl);


@class YLPhotoPickerUIConfig;
@interface YLPhotoPicker : NSObject



/**
 设置 UI 界面

 @param config UI的配置信息
 */
+ (void)setUIConfig:(YLPhotoPickerUIConfig *)config;

/**
 从相册选取多张照片

 @param presentVc 要推出选择页面的控制器
 @param maxImagesCount 最大的照片数量
 @param editable 是否可以编辑
 @param resultHandler 确认选择后的回调
 */
+ (void)showPhotoPickerWithPresentVc:(UIViewController * _Nullable)presentVc
                      maxImagesCount:(unsigned)maxImagesCount
                            editable:(BOOL)editable
                       resultHandler:(YLPhotoPickerResultHandler _Nullable)resultHandler;


/**
 从相机拍一张照片

 @param presentVc 要推出相机界面的控制器
 @param resultHandler 拍照确认后的回调
 */
+ (void)showCameraPhotoPickerWithPresentVc:(UIViewController * _Nullable)presentVc
                                  editable:(BOOL)editable
                             resultHandler:(YLCameraPhotoPickerResultHandler _Nullable)resultHandler;


/**
 从相册选择多个视频

 @param presentVc 要推出选择页面的控制器
 @param maxVideosCount 最大的视频数量
 @param maxDuration 视频最长的秒数
 @param editalbe 是否可以编辑
 @param resultHandler 确认选择后的回调
 */
+ (void)showVideoPickerWithPresentVc:(UIViewController * _Nullable)presentVc
                      maxVideosCount:(unsigned)maxVideosCount
                         maxDuration:(unsigned)maxDuration
                            editable:(BOOL)editalbe
                       resultHandler:(YLVideoPickerResultHandler _Nullable)resultHandler;



/**
 从相机拍摄一段视频

 @param presentVc 要推出相机界面的控制器
 @param maxDuration 录制的时长, 传入0 则默认为 10分钟
 @param resultHandler 录像确认后的回调
 */
+ (void)showCameraVideoPickerWithPresentVc:(UIViewController * _Nullable)presentVc
                               maxDuration:(unsigned)maxDuration
                                  editable:(BOOL)editalbe
                             resultHandler:(YLCameraVideoPickerResultHandler _Nullable)resultHandler;



/**
 从获取到的模型数组中提取出照片

 @param photoModes 图片的模型数组
 @param size 图片的大小
 @return 返回的图片
 */
+ (NSArray <UIImage *> *)getImagesFromPhotoModes:(NSArray <HXPhotoModel *> *)photoModes size:(CGSize)size;


/**
 从获取到的模型中提取照片

 @param photoMode 图片模型
 @param size 图片的大小
 @return 返回的图片
 */
+ (nullable UIImage *)getImageWithMode:(HXPhotoModel*)photoMode size:(CGSize)size;


/// 获取本地视频的URL
/// @param photoMode 视频模型
+ (nullable NSURL *)getVideoUrlWithMode:(HXPhotoModel *)photoMode;


/**
 获取拍摄的缓存视频的尺寸

 @param videoUrl 拍摄的视频存放的本地缓存路径
 @return 视频的尺寸
 */
+ (CGSize)getVideoSizeWithPathUrl:(NSURL *)videoUrl;



/**
 获取本地视频的第一帧

 @param videoUrl 视频的本地路径
 @return 第一帧图片
 */
+ (nullable UIImage *)getVideoPreviewImageWithPathUrl:(NSURL *)videoUrl;


@end


#pragma mark -  选择视频/图片时的 UI 界面设置
@interface YLPhotoPickerUIConfig : NSObject

/**
 主题颜色  默认 tintColor
 */
@property (strong, nonatomic) UIColor *themeColor;

/**
 导航栏标题颜色
 */
@property (strong, nonatomic) UIColor *navigationTitleColor;

/**
 导航栏背景颜色
 */
@property (strong, nonatomic) UIColor *navBarBackgroudColor;

/**
 cell选中时的文字颜色
 */
@property (strong, nonatomic) UIColor *cellSelectedTitleColor;

/**
 选中时数字的颜色
 */
@property (strong, nonatomic) UIColor *selectedTitleColor;

/**
 是否支持旋转  默认NO
 */
@property (assign, nonatomic) BOOL supportRotation;

@end

NS_ASSUME_NONNULL_END
