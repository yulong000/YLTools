#import "UIAlertController+block.h"

@implementation UIAlertActionModel

+ (instancetype)actionModelWithTitle:(NSString *)title actionStyle:(UIAlertActionStyle)style handler:(UIAlertActionHandler)handler {
    UIAlertActionModel *model = [[UIAlertActionModel alloc] init];
    model.title = title;
    model.style = style;
    model.handler = handler;
    return model;
}

+ (instancetype)cancelAction {
    UIAlertActionModel *model = [[UIAlertActionModel alloc] init];
    model.title = @"取消";
    model.style = UIAlertActionStyleCancel;
    model.handler = nil;
    return model;
}

@end

@implementation UIAlertController (block)

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                             cancelBlock:(void (^)(UIAlertAction *))cancelBlock
                        otherButtonTitle:(NSString *)otherButtonTitle
                        otherButtonblock:(void (^)(UIAlertAction *))otherButtonBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:cancelBlock];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:otherButtonBlock];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    return alertController;
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title
                                        message:(NSString *)message
                                    buttonTitle:(NSString *)buttonTitle
                                    handleBlock:(void (^)(UIAlertAction *))handleBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:buttonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:handleBlock];
    [alertController addAction:cancelAction];
    return alertController;
}

+ (UIAlertController *)actionSheetControllerWithTitle:(NSString *)title
                                              message:(NSString *)message
                                         actionModels:(NSArray<UIAlertActionModel *> *)actionModels {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertActionModel *model in actionModels) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:model.title
                                                         style:model.style
                                                       handler:model.handler];
        [alertController addAction:action];
    }
    return alertController;
}

- (void)showWithController:(UIViewController *)controller {
    [self showWithController:controller completion:nil];
}

- (void)showWithController:(UIViewController *)controller completion:(void (^)(void))completion {
    if(controller) {
        [controller presentViewController:self animated:YES completion:completion];
    }
}

@end
