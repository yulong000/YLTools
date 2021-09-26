//
//  UIViewController+category.m
//  YLCategory
//
//  Created by Apple on 2020/4/7.
//  Copyright © 2020 WYL. All rights reserved.
//

#import "UIViewController+category.h"

@implementation UIViewController (category)

#pragma mark - 返回

- (void)returnBack {
    if([self isKindOfClass:[UINavigationController class]]) {
        // 本身是导航控制器
        UINavigationController *nav = (UINavigationController *)self;
        if(nav.viewControllers.count == 1) {
            if(nav.presentingViewController) {
                [nav dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [nav popViewControllerAnimated:YES];
        }
    } else if (self.navigationController) {
        // 有导航控制器
        [self.navigationController returnBack];
    } else {
        // 没有导航控制器
        if(self.presentationController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)pushVc:(UIViewController *)vc {
    if(vc == nil)   return;
    if([self isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)self) pushViewController:vc animated:YES];
    } else if (self.navigationController) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (UINavigationController *)rootNavController {
    if(self.navigationController) {
        return self.navigationController;
    }
    UIView *superView = self.view.superview;
    do {
        UIResponder *responder = [self.view nextResponder];
        UIViewController *superVc = nil;
        while (responder) {
            if([responder isKindOfClass:[UIViewController class]]) {
                superVc = (UIViewController *)responder;
                break;
            }
            responder = [responder nextResponder];
        }
        if(superVc == nil) {
            return nil;
        }
        UINavigationController *nav = superVc.navigationController;
        if(nav) {
            return nav;
        } else {
            superView = superView.superview;
        }
    } while (superView);
    return nil;
}

@end
