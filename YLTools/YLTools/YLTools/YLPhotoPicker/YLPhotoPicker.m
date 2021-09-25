//
//  YLPhotoPicker.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLPhotoPicker.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface YLPhotoPicker () <   UINavigationControllerDelegate,
                                UIImagePickerControllerDelegate,
                                HXCustomCameraViewControllerDelegate,
                                UIVideoEditorControllerDelegate,
                                HXCustomNavigationControllerDelegate>

@property (nonatomic, copy  ) YLCameraPhotoPickerResultHandler cameraPhotoHandler;
@property (nonatomic, copy  ) YLCameraVideoPickerResultHandler cameraVideoHandler;
@property (nonatomic, copy  ) YLPhotoPickerResultHandler photoHandler;
@property (nonatomic, copy  ) YLVideoPickerResultHandler videoHandler;
@property (nonatomic, strong) UIViewController *presentVc;
@property (nonatomic, assign) unsigned maxVideoDuration;
/**  拍摄的视频编辑后存放的路径, 为了解决 didSaveEditedVideoToPath 代理方法调用2次的问题  */
@property (nonatomic, copy)   NSString *cameraEditedVideoPath;
/**  设置UI界面  */
@property (nonatomic, strong) YLPhotoPickerUIConfig *UIConfig;

@end

@implementation YLPhotoPicker

#pragma mark 获取推出照片/视频选择的控制器
- (UIViewController *)presentVc {
    return _presentVc ?: [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (HXPhotoConfiguration *)getPhotoUIConfig {
    HXPhotoConfiguration *config = [[HXPhotoConfiguration alloc] init];
    config.supportRotation = NO;
    if(self.UIConfig) {
        config.supportRotation = self.UIConfig.supportRotation;
        if(self.UIConfig.cellSelectedTitleColor)    config.cellSelectedTitleColor = self.UIConfig.cellSelectedTitleColor;
        if(self.UIConfig.selectedTitleColor)        config.selectedTitleColor = self.UIConfig.selectedTitleColor;
        if(self.UIConfig.navigationTitleColor)      config.navigationTitleColor = self.UIConfig.navigationTitleColor;
        if(self.UIConfig.navBarBackgroudColor)      config.navBarBackgroudColor = self.UIConfig.navBarBackgroudColor;
        if(self.UIConfig.themeColor)                config.themeColor = self.UIConfig.themeColor;
    }
    return config;
}

+ (instancetype)shareInstacne {
    static dispatch_once_t onceToken = 0;
    static YLPhotoPicker *picker = nil;
    dispatch_once(&onceToken, ^{
        picker = [[YLPhotoPicker alloc] init];
    });
    return picker;
}

+ (void)setUIConfig:(YLPhotoPickerUIConfig *)config {
    [YLPhotoPicker shareInstacne].UIConfig = config;
}

+ (void)requestPremissForCameraWithPresentVc:(UIViewController *)presentVc resultBlock:(void (^)(BOOL premiss))resultBlock {
    // 打开相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"相机已损坏" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:sure];
        [[YLPhotoPicker shareInstacne].presentVc presentViewController:alert animated:YES completion:nil];
        return;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            // 无权限
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否打开相机权限?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            [alert addAction:sure];
            [alert addAction:cancel];
            [[YLPhotoPicker shareInstacne].presentVc presentViewController:alert animated:YES completion:nil];
        }
            break;
        case AVAuthorizationStatusAuthorized: {
            // 已授权
            if(resultBlock) {
                resultBlock(YES);
            }
        }
            break;
        case AVAuthorizationStatusNotDetermined: {
            // 请求权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(resultBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        resultBlock(granted);
                    });
                }
            }];
        }
            break;
        default:
            break;
    }
}


#pragma mark 从相册选取多张照片
+ (void)showPhotoPickerWithPresentVc:(UIViewController *)presentVc
                      maxImagesCount:(unsigned int)maxImagesCount
                            editable:(BOOL)editable
                       resultHandler:(YLPhotoPickerResultHandler)resultHandler {
    [YLPhotoPicker shareInstacne].photoHandler = resultHandler;
    [YLPhotoPicker shareInstacne].videoHandler = nil;
    [YLPhotoPicker shareInstacne].cameraVideoHandler = nil;
    [YLPhotoPicker shareInstacne].cameraPhotoHandler = nil;
    [YLPhotoPicker shareInstacne].presentVc = presentVc;
    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    HXPhotoConfiguration *config = [[YLPhotoPicker shareInstacne] getPhotoUIConfig];
    config.photoMaxNum = maxImagesCount;
    config.singleSelected = maxImagesCount <= 1;
    config.photoCanEdit = editable;
    config.movableCropBox = YES;
    config.movableCropBoxEditSize = YES;
    config.openCamera = YES;
    config.albumShowMode = HXPhotoAlbumShowModePopup;
    manager.configuration = config;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithManager:manager delegate:[YLPhotoPicker shareInstacne] doneBlock:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL original, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        if([YLPhotoPicker shareInstacne].photoHandler && photoList.count) {
            [YLPhotoPicker shareInstacne].photoHandler(photoList);
        }
    } cancelBlock:^(UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        YLLog(@"取消选择图片");
    }];
    [[YLPhotoPicker shareInstacne].presentVc presentViewController:nav animated:YES completion:nil];
}

#pragma mark 从相机拍摄一张照片
+ (void)showCameraPhotoPickerWithPresentVc:(UIViewController *)presentVc
                                  editable:(BOOL)editable
                             resultHandler:(YLCameraPhotoPickerResultHandler)resultHandler {
    [YLPhotoPicker requestPremissForCameraWithPresentVc:presentVc resultBlock:^(BOOL premiss) {
        if(premiss) {
            [YLPhotoPicker shareInstacne].videoHandler = nil;
            [YLPhotoPicker shareInstacne].cameraVideoHandler = nil;
            [YLPhotoPicker shareInstacne].photoHandler = nil;
            [YLPhotoPicker shareInstacne].cameraPhotoHandler = resultHandler;
            [YLPhotoPicker shareInstacne].presentVc = presentVc;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.showsCameraControls = YES;
            picker.delegate = [YLPhotoPicker shareInstacne];
            picker.allowsEditing = editable;
            [[YLPhotoPicker shareInstacne].presentVc presentViewController:picker animated:YES completion:nil];
        }
    }];
}

#pragma mark 从相册选择多个视频
+ (void)showVideoPickerWithPresentVc:(UIViewController *)presentVc
                      maxVideosCount:(unsigned int)maxVideosCount
                         maxDuration:(unsigned int)maxDuration
                            editable:(BOOL)editalbe
                       resultHandler:(YLVideoPickerResultHandler)resultHandler {
    [YLPhotoPicker shareInstacne].videoHandler = resultHandler;
    [YLPhotoPicker shareInstacne].cameraVideoHandler = nil;
    [YLPhotoPicker shareInstacne].photoHandler = nil;
    [YLPhotoPicker shareInstacne].cameraPhotoHandler = nil;
    [YLPhotoPicker shareInstacne].presentVc = presentVc;
    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypeVideo];
    HXPhotoConfiguration *config = [[YLPhotoPicker shareInstacne] getPhotoUIConfig];
    config.videoMaxNum = maxVideosCount;
    config.videoCanEdit = editalbe;
    config.videoMaximumSelectDuration = maxDuration;
    config.maxVideoClippingTime = maxDuration;
    config.openCamera = YES;
    config.singleSelected = maxVideosCount <= 1;
    config.albumShowMode = HXPhotoAlbumShowModePopup;
    manager.configuration = config;
    HXCustomNavigationController *nav = [[HXCustomNavigationController alloc] initWithManager:manager delegate:[YLPhotoPicker shareInstacne] doneBlock:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL original, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        if([YLPhotoPicker shareInstacne].videoHandler && videoList.count) {
            [YLPhotoPicker shareInstacne].videoHandler(videoList);
        }
    } cancelBlock:^(UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        YLLog(@"取消选择视频");
    }];
    [[YLPhotoPicker shareInstacne].presentVc presentViewController:nav animated:YES completion:nil];
}

#pragma mark 从相机拍摄一个视频
+ (void)showCameraVideoPickerWithPresentVc:(UIViewController *)presentVc
                               maxDuration:(unsigned)maxDuration
                                  editable:(BOOL)editalbe
                             resultHandler:(YLCameraVideoPickerResultHandler)resultHandler {
    [YLPhotoPicker requestPremissForCameraWithPresentVc:presentVc resultBlock:^(BOOL premiss) {
        if(premiss) {
            [YLPhotoPicker shareInstacne].videoHandler = nil;
            [YLPhotoPicker shareInstacne].cameraVideoHandler = resultHandler;
            [YLPhotoPicker shareInstacne].photoHandler = nil;
            [YLPhotoPicker shareInstacne].cameraPhotoHandler = nil;
            [YLPhotoPicker shareInstacne].presentVc = presentVc;
            [YLPhotoPicker shareInstacne].maxVideoDuration = maxDuration;
            [YLPhotoPicker shareInstacne].cameraEditedVideoPath = nil;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
            picker.mediaTypes = @[(NSString *)kUTTypeMovie];
            picker.delegate = [YLPhotoPicker shareInstacne];
            picker.allowsEditing = editalbe;
            [[YLPhotoPicker shareInstacne].presentVc presentViewController:picker animated:YES completion:nil];
        }
    }];
}

#pragma mark 从图片的模型中获取图片
+ (UIImage *)getImageWithMode:(HXPhotoModel *)photoMode size:(CGSize)size {
    if(size.width == 0 || size.height == 0 || photoMode == nil) return nil;
    if(photoMode.type == HXPhotoModelMediaTypeCameraPhoto) {
        // 相机拍的照片
        return photoMode.thumbPhoto;
    }
    if(photoMode.type == HXPhotoModelMediaTypePhoto) {
        __block UIImage *image = nil;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.synchronous = YES;
        options.networkAccessAllowed = YES;
        [[PHCachingImageManager defaultManager] requestImageForAsset:photoMode.asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if(result) {
                image = result;
            }
        }];
        return image;
    }
    return nil;
}

#pragma mark 从图片的模型数组中获取图片数组
+ (NSArray<UIImage *> *)getImagesFromPhotoModes:(NSArray<HXPhotoModel *> *)photoModes size:(CGSize)size {
    __block NSMutableArray *arr = [NSMutableArray array];
    for (HXPhotoModel *model in photoModes) {
        UIImage *image = [YLPhotoPicker getImageWithMode:model size:size];
        if(image) {
            [arr addObject:image];
        }
    }
    return arr;
}


#pragma mark 从视频模型中获取视频的URL
+ (NSURL *)getVideoUrlWithMode:(HXPhotoModel *)photoMode {
    if(photoMode.asset) {
        __block NSURL *videoUrl = nil;
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        [[PHImageManager defaultManager] requestAVAssetForVideo:photoMode.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            if([asset isKindOfClass:[AVURLAsset class]]) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                videoUrl = urlAsset.URL;
            }
            dispatch_semaphore_signal(sem);
        }];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        return videoUrl;
    } else {
        return photoMode.videoURL;
    }
}

#pragma mark 获取本地视频的尺寸
+ (CGSize)getVideoSizeWithPathUrl:(NSURL *)videoUrl {
    if(videoUrl == nil || [videoUrl isKindOfClass:[NSURL class]])   return CGSizeZero;
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    CGSize size = CGSizeZero;
    for (AVAssetTrack *track in asset.tracks) {
        if([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            CGAffineTransform affi = track.preferredTransform;
            CGSize tmp = CGSizeApplyAffineTransform(track.naturalSize, affi);
            size = CGSizeMake(fabs(tmp.width), fabs(tmp.height));
        }
    }
    return size;
}

#pragma mark 获取本地视频的第一帧
+ (UIImage *)getVideoPreviewImageWithPathUrl:(NSURL *)videoUrl {
    if(videoUrl == nil || [videoUrl isKindOfClass:[NSURL class]] == NO) return nil;
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark 相机代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image;
        if(picker.allowsEditing == YES) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
        if(self.cameraPhotoHandler && image) {
            self.cameraPhotoHandler(image, info);
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        if(picker.allowsEditing && [UIVideoEditorController canEditVideoAtPath:url.path]) {
            // 允许编辑
            [picker dismissViewControllerAnimated:YES completion:^{
                UIVideoEditorController *editor = [[UIVideoEditorController alloc] init];
                editor.videoPath = url.path;
                editor.videoQuality = UIImagePickerControllerQualityTypeHigh;
                if([YLPhotoPicker shareInstacne].maxVideoDuration > 0)
                    editor.videoMaximumDuration = [YLPhotoPicker shareInstacne].maxVideoDuration;
                editor.delegate = self;
                [[YLPhotoPicker shareInstacne].presentVc presentViewController:editor animated:YES completion:nil];
            }];
        } else {
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)) {
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, NULL);
            }
            [picker dismissViewControllerAnimated:YES completion:^{
                if([YLPhotoPicker shareInstacne].cameraVideoHandler) {
                    [YLPhotoPicker shareInstacne].cameraVideoHandler(url);
                }
            }];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 视频编辑 delegate
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    if([YLPhotoPicker shareInstacne].cameraEditedVideoPath.length == 0) {
        NSLog(@"视频编辑成功 :%@", editedVideoPath);
        [YLPhotoPicker shareInstacne].cameraEditedVideoPath = editedVideoPath;
        if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(editedVideoPath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(editedVideoPath, nil, nil, NULL);
        }
        [editor dismissViewControllerAnimated:YES completion:^{
            if([YLPhotoPicker shareInstacne].cameraVideoHandler) {
                [YLPhotoPicker shareInstacne].cameraVideoHandler([NSURL fileURLWithPath:editedVideoPath]);
            }
        }];
    }
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    [editor dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"视频编辑发生错误!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:sure];
        [[YLPhotoPicker shareInstacne].presentVc presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    [editor dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation YLPhotoPickerUIConfig


@end
