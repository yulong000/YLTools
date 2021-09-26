
#import <UIKit/UIKit.h>

// 手势回调
typedef void (^UIViewTapGestureHandler)(id view, UITapGestureRecognizer *tap);
typedef void (^UIViewPanGestureHandler)(id view, UIPanGestureRecognizer *pan);
typedef void (^UIViewLongPressGestureHandler)(id view, UILongPressGestureRecognizer *longPress);

@interface UIView (gesture)

- (void)addTapGestureWithHandler:(UIViewTapGestureHandler)handler;
- (void)addPanGestureWithHandler:(UIViewPanGestureHandler)handler;
- (void)addLongPressGestureWithHandler:(UIViewLongPressGestureHandler)handler;

- (void)addTapGestureWithDelegate:(id)delegate handler:(UIViewTapGestureHandler)handler;
- (void)addPanGestureWithDelegate:(id)delegate handler:(UIViewPanGestureHandler)handler;
- (void)addLongPressGestureWithDelegate:(id)delegate handler:(UIViewLongPressGestureHandler)handler;

@end
