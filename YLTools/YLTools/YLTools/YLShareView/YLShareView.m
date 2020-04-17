//
//  YLShareView.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLShareView.h"
#import <UMShare/UMShare.h>

static NSString *YLShareItemID = @"YLShareItemID";


@interface YLShareItem : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) UMSocialPlatformType type;

@end

@implementation YLShareItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = Font(12);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imgWH = 60;
    self.imageView.frame = CGRectMake((self.frame.size.width - imgWH) / 2, 0, imgWH, imgWH);
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
}

- (void)setType:(UMSocialPlatformType)type {
    switch (type) {
        case UMSocialPlatformType_WechatSession:
            // 微信好友
            self.imageView.image = [UIImage imageNamed:@"share_wechat"];
            self.titleLabel.text = @"微信好友";
            break;
        case UMSocialPlatformType_WechatTimeLine:
            // 微信朋友圈
            self.imageView.image = [UIImage imageNamed:@"share_circle"];
            self.titleLabel.text = @"微信朋友圈";
            break;
        case UMSocialPlatformType_QQ:
            // QQ好友
            self.imageView.image = [UIImage imageNamed:@"share_qq"];
            self.titleLabel.text = @"QQ好友";
            break;
        case UMSocialPlatformType_Sina:
            // 新浪
            self.imageView.image = [UIImage imageNamed:@"share_sina"];
            self.titleLabel.text = @"新浪";
            break;
        case UMSocialPlatformType_Qzone:
            // QQ空间
            self.imageView.image = [UIImage imageNamed:@"share_qqZone"];
            self.titleLabel.text = @"QQ空间";
            break;
        case UMSocialPlatformType_UserDefine_Begin:
            // 复制
            self.imageView.image = [UIImage imageNamed:@"share_link"];
            self.titleLabel.text = @"复制";
            break;
        default:
            break;
    }
}

@end

@interface YLShareView ()  <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy)   YLShareResultHandler resultHandler;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *desc;
@property (nonatomic, copy)   id thumbImage;
@property (nonatomic, copy)   NSString *webUrl;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIControl *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation YLShareView

+ (void)shareWithTitle:(NSString *)title
                  desc:(NSString *)desc
            thumbImage:(id)thumbImage
            webpageUrl:(NSString *)webpageUrl
         resultHandler:(YLShareResultHandler)resultHandler {
    YLShareView *shareView = [[YLShareView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    shareView.title = title;
    shareView.desc = desc;
    shareView.thumbImage = thumbImage;
    shareView.webUrl = webpageUrl;
    shareView.resultHandler = resultHandler;
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shareView show];
    });
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIControl alloc] init];
        [self addSubview:self.bgView];
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = WhiteColor;
        [self addSubview:self.contentView];
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake(80, 90);
        CGFloat space = (kScreenWidth - flow.itemSize.width * 3) / 4;
        flow.sectionInset = UIEdgeInsetsMake(20, space, 20, space);
        flow.minimumInteritemSpacing = space;
        flow.minimumLineSpacing = 20;
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        self.collectionView.backgroundColor = RGBA(241, 245, 248, 1);
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[YLShareItem class] forCellWithReuseIdentifier:YLShareItemID];
        [self.contentView addSubview:self.collectionView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGBA(220, 220, 220, 220);
        [self.contentView addSubview:self.lineView];
        
        __weak typeof(self) weakSelf = self;
        self.cancelBtn = [UIButton buttonWithTitle:@"取消" clickBlock:^(UIButton *button) {
            [weakSelf hide];
        }];
        self.cancelBtn.titleLabel.font = Font(14);
        self.cancelBtn.backgroundColor = WhiteColor;
        [self.contentView addSubview:self.cancelBtn];
        
        self.bgView.clickedBlock = ^(UIControl *control) {
            [weakSelf hide];
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    
    self.contentView.size = CGSizeMake(self.width, kBottomSafeAreaHeight + 280);
    self.contentView.top = self.height;
    
    self.collectionView.size = CGSizeMake(self.contentView.width, 240);
    
    self.lineView.size = CGSizeMake(self.contentView.width, 1);
    self.lineView.top = self.collectionView.bottom;
    
    self.cancelBtn.size = CGSizeMake(self.contentView.width, self.contentView.height - self.lineView.bottom);
    self.cancelBtn.top = self.lineView.bottom;
}

- (NSArray *)dataArr {
    if(_dataArr == nil) {
        _dataArr = @[@(UMSocialPlatformType_WechatSession),
                     @(UMSocialPlatformType_WechatTimeLine),
                     @(UMSocialPlatformType_QQ),
                     @(UMSocialPlatformType_Qzone),
                     @(UMSocialPlatformType_Sina),
                     @(UMSocialPlatformType_UserDefine_Begin)];
    }
    return _dataArr;
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.contentView.bottom = self.height;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.backgroundColor = ClearColor;
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YLShareItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:YLShareItemID forIndexPath:indexPath];
    item.type = [self.dataArr[indexPath.item] intValue];
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UMSocialPlatformType type = [self.dataArr[indexPath.item] intValue];
    UMShareWebpageObject *shareObj = [UMShareWebpageObject shareObjectWithTitle:self.title descr:self.desc thumImage:self.thumbImage];
    shareObj.webpageUrl = self.webUrl;
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.shareObject = shareObj;
    switch (type) {
        case UMSocialPlatformType_WechatSession:
        case UMSocialPlatformType_WechatTimeLine: {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] == NO) {
                // 未安装微信客户端
                [self hide];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您未安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:sure];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                return ;
            }
        }
            break;
        case UMSocialPlatformType_QQ:
        case UMSocialPlatformType_Qzone: {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]] == NO) {
                // 未安装QQ客户端
                [self hide];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您未安装QQ客户端" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:sure];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                return ;
            }
        }
            break;
        case UMSocialPlatformType_Sina:
            messageObject.title = [NSString stringWithFormat:@"%@ %@", self.title, self.webUrl];
            break;
        case UMSocialPlatformType_UserDefine_Begin: {
            // 复制链接
            if(self.webUrl.length) {
                UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
                pastboard.string = self.webUrl;
                [MBProgressHUD showSuccess:@"复制链接成功!"];
                if (self.resultHandler)  self.resultHandler(YES);
            } else {
                [MBProgressHUD showError:@"复制链接失败!"];
                if (self.resultHandler)  self.resultHandler(NO);
            }
            [self hide];
            return;
        }
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if(error) {
            if ((int)error.code == 2009) {
                if (weakSelf.resultHandler) {
                    weakSelf.resultHandler(NO);
                }
                [MBProgressHUD showError:@"分享已取消!"];
            }else{
                if (weakSelf.resultHandler) {
                    weakSelf.resultHandler(NO);
                }
                [MBProgressHUD showError:@"分享失败!"];
            }
        } else {
            if (weakSelf.resultHandler) {
                weakSelf.resultHandler(YES);
            }
            [MBProgressHUD showSuccess:@"分享成功!"];
            [weakSelf hide];
        }
    }];
}

@end
