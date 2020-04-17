//
//  NetworkDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/8/5.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "NetworkDemoVC.h"
#import "YLNetworkTools.h"
#import "AdvertisementModel.h"

@interface NetworkDemoVC ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation NetworkDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    UIButton *btn = [UIButton buttonWithTitle:@"加载" clickBlock:^(UIButton *button) {
        weakSelf.textView.text = nil;
        [weakSelf loadData];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, kNavTotalHeight, self.view.width - 20, 300)];
    self.textView.editable = NO;
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 1;
    [self.view addSubview:self.textView];
}

#pragma mark 获取网络数据
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    NSString        *url    = @"http://api.0101hr.com:8080/api-v/advertisement/selectAllByPaging";
    NSDictionary    *params = @{@"siteId"      :   @"1",
                                @"adType"      :   @"3"};
    [YLNetworkTools postWithURL:url params:params success:^(NSDictionary * _Nonnull resp) {

        weakSelf.textView.text = [NSString stringWithFormat:@"请求url : \n%@\n请求参数 : \n%@\n请求响应 : \n%@", url, params, resp];
        
        /*  返回的数据为对象数组时
            1.使用 MJExtension 进行数模转换, 可以不用判空, MJExtension 已经做了判空处理, 转换成的模型数组有可能会为nil, 使用时根据具体情况需要做判空处理
            2.直接读取数组信息时, 需要进行类型判断, 因为后台返回的数据有可能不是数组
         */
        NSArray *arr = [AdvertisementModel mj_objectArrayWithKeyValuesArray:resp[@"data"][@"list"]];
        if(arr.count) {
            
        }
        
        NSArray *arrM = resp[@"data"][@"list"];
        if([arrM isKindOfClass:[NSArray class]] && arrM.count) {
            // 如果 arrM 获取到的不是数组, 直接调用 arrM.count 会 crash
        }
        
        
        /*  返回的数据为对象的字典时
         1.使用 MJExtension 进行数模转换, 获取到的对象不会为nil, 但里面的属性值有可能会为nil, 所以使用前需要进行判断
         2.直接读取字典信息时, 需要进行类型判断, 因为后台返回的数据有可能不是字典, 从字典里取key对应的value有可能取不到
         */
        AdvertisementModel *ad = [AdvertisementModel mj_objectWithKeyValues:resp[@"data"]];
        if(ad.imagesUrl != nil) {
            // 如果 imagesUrl 未判nil, 此时有可能会crash
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:ad.imagesUrl];
        }
        
        NSDictionary *dict = resp[@"data"];
        if([dict isKindOfClass:[NSDictionary class]] && [dict[@"imagesUrl"] isKindOfClass:[NSString class]]) {
            // 如果 dict 不是字典类型, dict[@"imagesUrl"] 取到的值为nil, 此时再去对 key : "imagesUrl" 的 value 值做一些操作, 有可能会crash
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:dict[@"imagesUrl"]];
        }
     
        
        /*  返回的数据为字符串时
         1.如果需要对字符串进行某些操作, 需要做类型判断
         2.如果未做类型判断, 直接使用字符串所特有的方法时, 会crash
         */
        NSString *str = resp[@"data"];
        if([str isKindOfClass:[NSString class]]) {
            // 如果 str 不是字符串类型, 此时调用此方法会crash
            str = [str stringByAppendingString:@"abc"];
        }
        
        
        /*  返回的数据为数字时
         1.如果需要获取数字的值, 需要做类型判断
         2.如果未做类型判断, 直接使用intValue, 会crash
         */
        NSNumber *number = resp[@"data"];
        if([number isKindOfClass:[NSNumber class]]) {
            // 如果 number 不是数字类型, 此时调用此方法会crash
            int count = number.intValue;
        }
        
        
    } failure:^(NSString * _Nonnull error) {
        YLLog(@"error : %@", error);
    }];
}

@end
