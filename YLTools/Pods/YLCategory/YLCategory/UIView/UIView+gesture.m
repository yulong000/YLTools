
#import "UIView+gesture.h"
#import <objc/runtime.h>

static const char UIViewTapGestureHandlerKey = '\0';
static const char UIViewPanGestureHandlerKey = '\0';
static const char UIViewLongPressGestureHandlerKey = '\0';

@implementation UIView (gesture)

#pragma mark - 点击手势

- (void)setTapGestureHandler:(UIViewTapGestureHandler)tapGestureHandler {
    [self willChangeValueForKey:@"tapGestureHandler"];
    objc_setAssociatedObject(self, &UIViewTapGestureHandlerKey, tapGestureHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"tapGestureHandler"];
}

- (UIViewTapGestureHandler)tapGestureHandler {
    return objc_getAssociatedObject(self, &UIViewTapGestureHandlerKey);
}

- (void)addTapGestureWithDelegate:(id)delegate handler:(UIViewTapGestureHandler)handler {
    self.userInteractionEnabled = YES;
    self.tapGestureHandler = [handler copy];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    if(delegate) tap.delegate = delegate;
    [self addGestureRecognizer:tap];
}

- (void)addTapGestureWithHandler:(UIViewTapGestureHandler)handler {
    [self addTapGestureWithDelegate:nil handler:handler];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if(self.tapGestureHandler) {
        self.tapGestureHandler(self, tap);
    }
}

#pragma mark - 拖动手势

- (void)setPanGestureHandler:(UIViewPanGestureHandler)panGestureHandler {
    [self willChangeValueForKey:@"panGestureHandler"];
    objc_setAssociatedObject(self, &UIViewPanGestureHandlerKey, panGestureHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"panGestureHandler"];
}

- (UIViewPanGestureHandler)panGestureHandler {
    return objc_getAssociatedObject(self, &UIViewPanGestureHandlerKey);
}

- (void)addPanGestureWithDelegate:(id)delegate handler:(UIViewPanGestureHandler)handler {
    self.userInteractionEnabled = YES;
    self.panGestureHandler = [handler copy];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    if(delegate) pan.delegate = delegate;
    [self addGestureRecognizer:pan];
}

- (void)addPanGestureWithHandler:(UIViewPanGestureHandler)handler {
    [self addPanGestureWithDelegate:nil handler:handler];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if(self.panGestureHandler) {
        self.panGestureHandler(self, pan);
    }
}

#pragma mark - 长按手势

- (void)setLongPressGestureHandler:(UIViewLongPressGestureHandler)longPressGestureHandler {
    [self willChangeValueForKey:@"longPressGestureHandler"];
    objc_setAssociatedObject(self, &UIViewLongPressGestureHandlerKey, longPressGestureHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"longPressGestureHandler"];
}

- (UIViewLongPressGestureHandler)longPressGestureHandler {
    return objc_getAssociatedObject(self, &UIViewLongPressGestureHandlerKey);
}

- (void)addLongPressGestureWithDelegate:(id)delegate handler:(UIViewLongPressGestureHandler)handler {
    self.userInteractionEnabled = YES;
    self.longPressGestureHandler = [handler copy];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    if(delegate) longPress.delegate = delegate;
    [self addGestureRecognizer:longPress];
}

- (void)addLongPressGestureWithHandler:(UIViewLongPressGestureHandler)handler {
    [self addLongPressGestureWithDelegate:nil handler:handler];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if(self.longPressGestureHandler) {
        self.longPressGestureHandler(self, longPress);
    }
}


@end
