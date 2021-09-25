//
//  WaterFlowDemoVC.m
//  YLTools
//
//  Created by 魏宇龙 on 2021/9/25.
//  Copyright © 2021 weiyulong. All rights reserved.
//

#import "WaterFlowDemoVC.h"
#import "YLWaterFlowLayout.h"

@interface WaterFlowDemoVC () <UICollectionViewDelegate, UICollectionViewDataSource, YLWaterFlowLayoutDelegate>

@end

@implementation WaterFlowDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionView *collectionView = [self createCollectionView];
    [self.view addSubview:collectionView];
    
}

#pragma mark - 创建collectionView
- (UICollectionView *)createCollectionView {
    YLWaterFlowLayout *flow = [[YLWaterFlowLayout alloc] initWithLayoutStyle:YLWaterFlowLayoutStyleVerticalEqualWidth];
    flow.delegate = self;
    flow.sectionEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    flow.columnCount = 3;
    flow.columnMargin = 10;
    flow.rowMargin = 20;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flow];
    collectionView.backgroundColor = WhiteColor;
    collectionView.alwaysBounceVertical = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    return collectionView;
}

#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    item.backgroundColor = RandomColor;
    return item;
}

#pragma mark collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark YLWaterFlowLayoutDelegate

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(0, arc4random() % 100 + 50);
}



@end
