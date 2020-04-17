//
//  PhotoPickerDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/8/20.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "PhotoPickerDemoVC.h"
#import "YLPhotoPicker.h"

@interface PhotoPickerDemoVC ()

@end

@implementation PhotoPickerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 150, self.view.width - 10, 300)];
    textView.font = Font(14);
    textView.layer.borderColor = GrayColor.CGColor;
    textView.layer.borderWidth = 0.5;
    [self.view addSubview:textView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, textView.bottom + 20, self.view.width - 10, 200)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    // UI 界面设置
    YLPhotoPickerUIConfig *config = [[YLPhotoPickerUIConfig alloc] init];
    config.themeColor = RedColor;
    config.cellSelectedTitleColor = BlueColor;
    config.selectedTitleColor = GreenColor;
    config.navigationTitleColor = OrangeColor;
    config.navBarBackgroudColor = GrayColor;
    [YLPhotoPicker setUIConfig:config];
    
    // 从相册选择1张或者多张照片, 可选择是否进行编辑
    __weak typeof(self) weakSelf = self;
    UIButton *photo = [UIButton buttonWithTitle:@"选择照片" backgroundImageCorlor:RGBA(70, 160, 248, 1) cornerRadius:5 clickBlock:^(UIButton *button) {
        [YLPhotoPicker showPhotoPickerWithPresentVc:nil maxImagesCount:3 editable:YES resultHandler:^(NSArray<HXPhotoModel *> * _Nonnull photoModelArr) {
            // 所有的图片存储路径
            NSString *str = @"";
            for (HXPhotoModel *model in photoModelArr) {
//                str = [str stringByAppendingString:model.fileURL.absoluteString];
//                str = [str stringByAppendingString:@"\n"];
            }
            textView.text = str;
            
            // 第一张照片
            NSArray *images = [YLPhotoPicker getImagesFromPhotoModes:photoModelArr size:CGSizeMake(300, 300)];
            if(images.count) imageView.image = images.firstObject;
        }];
    }];
    [photo setTitleColor:WhiteColor forState:UIControlStateNormal];
    photo.titleLabel.font = Font(14);
    [self.view addSubview:photo];
    
    
    
    // 从相机拍摄一张照片,可选择是否进行编辑
    UIButton *cameraPhoto = [UIButton buttonWithTitle:@"相机拍照" backgroundImageCorlor:RGBA(70, 160, 248, 1) cornerRadius:5 clickBlock:^(UIButton *button) {
        [YLPhotoPicker showCameraPhotoPickerWithPresentVc:weakSelf editable:NO resultHandler:^(UIImage * _Nonnull cameraImage, NSDictionary<UIImagePickerControllerInfoKey,id> * _Nonnull info) {
            // 拍摄的图片
            imageView.image = cameraImage;
        }];
    }];
    [cameraPhoto setTitleColor:WhiteColor forState:UIControlStateNormal];
    cameraPhoto.titleLabel.font = Font(14);
    [self.view addSubview:cameraPhoto];
    
    
    
    // 从相册选择一个或多个视频, 可限定时长, 可选择是否进行编辑
    UIButton *video = [UIButton buttonWithTitle:@"选择视频" backgroundImageCorlor:RGBA(70, 160, 248, 1) cornerRadius:5 clickBlock:^(UIButton *button) {
        
        // 改变UI界面
        YLPhotoPickerUIConfig *config = [[YLPhotoPickerUIConfig alloc] init];
        config.themeColor = RGBA(arc4random() % 255, arc4random() % 255, arc4random() % 255, 1);
        config.cellSelectedTitleColor = RGBA(arc4random() % 255, arc4random() % 255, arc4random() % 255, 1);
        config.selectedTitleColor = RGBA(arc4random() % 255, arc4random() % 255 , arc4random() % 255, 1);
        config.navigationTitleColor = RGBA(arc4random() % 255, arc4random() % 255, arc4random() % 255, 1);
        config.navBarBackgroudColor = RGBA(arc4random() % 255, arc4random() % 255, arc4random() % 255, 1);
        [YLPhotoPicker setUIConfig:config];
        
        
        [YLPhotoPicker showVideoPickerWithPresentVc:nil maxVideosCount:4 maxDuration:30 editable:YES resultHandler:^(NSArray<HXPhotoModel *> * _Nonnull videoModelArr) {
            // 所有选择的视频的路径
            NSString *str = @"";
            for (HXPhotoModel *model in videoModelArr) {
//                str = [str stringByAppendingString:model.fileURL.absoluteString];
//                str = [str stringByAppendingString:@"\n"];
            }
            textView.text = str;
//            imageView.image = [YLPhotoPicker getVideoPreviewImageWithPathUrl:videoModelArr.firstObject.fileURL];
        }];
    }];
    [video setTitleColor:WhiteColor forState:UIControlStateNormal];
    video.titleLabel.font = Font(14);
    [self.view addSubview:video];
    
    
    // 从相机拍摄一个视频,可限定时长, 可选择是否进行编辑
    UIButton *cameraVideo = [UIButton buttonWithTitle:@"相机录像" backgroundImageCorlor:RGBA(70, 160, 248, 1) cornerRadius:5 clickBlock:^(UIButton *button) {
        [YLPhotoPicker showCameraVideoPickerWithPresentVc:weakSelf maxDuration:10 editable:YES resultHandler:^(NSURL * _Nonnull cameraVideoUrl) {
            // 拍摄的录像的存储路径
            textView.text = cameraVideoUrl.absoluteString;
            imageView.image = [YLPhotoPicker getVideoPreviewImageWithPathUrl:cameraVideoUrl];
        }];
    }];
    [cameraVideo setTitleColor:WhiteColor forState:UIControlStateNormal];
    cameraVideo.titleLabel.font = Font(14);
    [self.view addSubview:cameraVideo];
    
    photo.size = cameraPhoto.size = video.size = cameraVideo.size = CGSizeMake(75, 35);
    CGFloat space = (self.view.width - photo.width * 4) / 5;
    photo.top = cameraPhoto.top = video.top = cameraVideo.top = 100;
    photo.left = space;
    cameraPhoto.left = photo.right + space;
    video.left = cameraPhoto.right + space;
    cameraVideo.left = video.right + space;
}

@end
