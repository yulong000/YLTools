//
//  PayDemoVC.m
//  YLTools
//
//  Created by weiyulong on 2019/8/7.
//  Copyright © 2019 weiyulong. All rights reserved.
//

#import "PayDemoVC.h"
#import "YLPaymentTools.h"

@interface PayDemoVC ()

@end

@implementation PayDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 支付宝支付的使用
    UITextView *ali = [[UITextView alloc] initWithFrame:CGRectMake(10, kNavTotalHeight, self.view.width - 20, 200)];
    ali.editable = NO;
    ali.font = [UIFont systemFontOfSize:13];
    ali.layer.borderColor = [UIColor blackColor].CGColor;
    ali.layer.borderWidth = 1;
    [self.view addSubview:ali];
    ali.text = @"alipay_sdk=alipay-sdk-java-3.7.1&app_id=2019072565934655&biz_content=%7B%22body%22%3A%22qmcsGoods%22%2C%22out_trade_no%22%3A%22c2eee9fb7e294c0b8d9d694c40ec4503%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%C8%AB%C3%F1%B2%E8%CA%D0%22%2C%22timeout_express%22%3A%2260m%22%2C%22total_amount%22%3A%2218.00%22%7D&charset=GBK&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fapi.0101hr.com%3A8080%2Fapi-or%2Forder%2Falipay_notify_url&sign=SQV6PIB91Ggcru3PGtswQKy9vfC88kYkWyhpBBc5yT62cViwDOMrciFRNnAd4MNr8c8D80Y3pRusI1Ox9TCuAlYvJRlnntJe5UN02eQPtWDTJut%2Fs2LpjhdG435VsPRqfl%2FhjIvdT4sktZ%2Fss5NHme9Wiejjmgu1sbWKzw%2B8dWG03nYqzMh4eN5DWm1BG7pfrd2t9dsfV%2FPG9aKz8BA7P%2Bq8%2B5xzjQjq%2FOQyHrofwCt%2FY8tsidzhuPOW9J9HLwhg3s%2B5Tik6xBpm%2B9DE4wdhNC6RXXUGEtEWiV%2FeO96pN3P5yWRWtOnvMGSs263G%2Bh1ddIqcD9Vfz3mTtynkTnSO7Q%3D%3D&sign_type=RSA2&timestamp=2019-08-07+15%3A07%3A58&version=1.0";
    
    UIButton *aliPay = [UIButton buttonWithTitle:@"支付宝支付" backgroundImageCorlor:RGBA(53, 191, 126, 1) cornerRadius:5 clickBlock:^(UIButton *button) {
        [YLPaymentTools payWithPayChargeParams:ali.text resultBlock:^(YLPaymentResult result, YLPaymentChannel channel) {
            switch (result) {
                case YLPaymentResultCancel: {
                    [MBProgressHUD showError:@"支付已取消"];
                    return ;
                }
                    break;
                case YLPaymentResultSuccess: {
                    [MBProgressHUD showSuccess:@"支付成功!"];
                    return;
                }
                case YLPaymentResultNetworkError: {
                    [MBProgressHUD showError:@"网络异常!"];
                    return;
                }
                case YLPaymentResultOtherError: {
                    [MBProgressHUD showError:@"未知错误!"];
                    return;
                }
                default:
                    break;
            }
        }];
    }];
    [aliPay setTitleColor:WhiteColor forState:UIControlStateNormal];
    aliPay.size = CGSizeMake(200, 40);
    aliPay.top = ali.bottom + 20;
    aliPay.centerX = ali.centerX;
    [self.view addSubview:aliPay];
    
    
    // 微信支付的使用
    UITextView *wx = [[UITextView alloc] initWithFrame:CGRectMake(10, aliPay.bottom + 50, ali.width, 200)];
    wx.editable = NO;
    wx.font = [UIFont systemFontOfSize:13];
    wx.layer.borderColor = [UIColor blackColor].CGColor;
    wx.layer.borderWidth = 1;
    [self.view addSubview:wx];
    NSDictionary *payCharge =  @{@"timestamp"    : @(1565161574),
                                 @"partnerid"    : @"1546853461",
                                 @"package"      : @"Sign=WXPay",
                                 @"noncestr"     : @"DBjzAD6WnXpObdDk",
                                 @"sign"         : @"811723D6AD758BCE54E1D84CD601E313",
                                 @"appid"        : @"wxeb5335a24d2af0c6",
                                 @"prepayid"     : @"wx0715061397981848f0b2fb111812962800",};
    wx.text = payCharge.description;
    
    UIButton *wxPay = [UIButton buttonWithTitle:@"微信支付" backgroundImageCorlor:RGBA(53, 191, 126, 1) cornerRadius:5 clickBlock:^(UIButton *button) {
        [YLPaymentTools payWithPayChargeParams:payCharge resultBlock:^(YLPaymentResult result, YLPaymentChannel channel) {
            switch (result) {
                case YLPaymentResultCancel: {
                    [MBProgressHUD showError:@"支付已取消"];
                    return ;
                }
                    break;
                case YLPaymentResultSuccess: {
                    [MBProgressHUD showSuccess:@"支付成功!"];
                    return;
                }
                case YLPaymentResultNetworkError: {
                    [MBProgressHUD showError:@"网络异常!"];
                    return;
                }
                case YLPaymentResultOtherError: {
                    [MBProgressHUD showError:@"未知错误!"];
                    return;
                }
                default:
                    break;
            }
        }];
    }];
    [wxPay setTitleColor:WhiteColor forState:UIControlStateNormal];
    wxPay.size = CGSizeMake(200, 40);
    wxPay.top = wx.bottom + 20;
    wxPay.centerX = wx.centerX;
    [self.view addSubview:wxPay];
    
}


/*
 订单生成后,根据订单获取支付信息
 
 微信支付信息
response :     {
    data =     {
        timestamp = 1565161574,
        partnerid = "1546853461",
        package = "Sign=WXPay",
        noncestr = "DBjzAD6WnXpObdDk",
        sign = "811723D6AD758BCE54E1D84CD601E313",
        appid = "wxeb5335a24d2af0c6",
        prepayid = "wx0715061397981848f0b2fb111812962800",
    },
    msg = "SUCCESS",
    clientMsg = <null>,
    ret = 200,
}

 支付宝支付信息
response :     {
    data = "alipay_sdk=alipay-sdk-java-3.7.1&app_id=2019072565934655&biz_content=%7B%22body%22%3A%22qmcsGoods%22%2C%22out_trade_no%22%3A%22c2eee9fb7e294c0b8d9d694c40ec4503%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%C8%AB%C3%F1%B2%E8%CA%D0%22%2C%22timeout_express%22%3A%2260m%22%2C%22total_amount%22%3A%2218.00%22%7D&charset=GBK&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fapi.0101hr.com%3A8080%2Fapi-or%2Forder%2Falipay_notify_url&sign=SQV6PIB91Ggcru3PGtswQKy9vfC88kYkWyhpBBc5yT62cViwDOMrciFRNnAd4MNr8c8D80Y3pRusI1Ox9TCuAlYvJRlnntJe5UN02eQPtWDTJut%2Fs2LpjhdG435VsPRqfl%2FhjIvdT4sktZ%2Fss5NHme9Wiejjmgu1sbWKzw%2B8dWG03nYqzMh4eN5DWm1BG7pfrd2t9dsfV%2FPG9aKz8BA7P%2Bq8%2B5xzjQjq%2FOQyHrofwCt%2FY8tsidzhuPOW9J9HLwhg3s%2B5Tik6xBpm%2B9DE4wdhNC6RXXUGEtEWiV%2FeO96pN3P5yWRWtOnvMGSs263G%2Bh1ddIqcD9Vfz3mTtynkTnSO7Q%3D%3D&sign_type=RSA2&timestamp=2019-08-07+15%3A07%3A58&version=1.0",
    msg = "SUCCESS",
    clientMsg = <null>,
    ret = 200,
}
 
 */

@end
