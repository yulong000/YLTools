
#import "UIView+gesture.h"
#import <objc/runtime.h>

static const char UIViewPanGestureBlockKey = '\0';
static const char UIViewTapGestureBlockKey = '\0';

@implementation UIView (gesture)

- (void)setTapGestureBlock:(UIViewTapGestureBlock)tapGestureBlock {
    [self willChangeValueForKey:@"tapGestureBlock"];
    objc_setAssociatedObject(self, &UIViewTapGestureBlockKey, tapGestureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"tapGestureBlock"];
}

- (UIViewTapGestureBlock)tapGestureBlock {
    return objc_getAssociatedObject(self, &UIViewTapGestureBlockKey);
}

- (void)setPanGestureBlock:(UIViewPanGestureBlock)panGestureBlock {
    [self willChangeValueForKey:@"panGestureBlock"];
    objc_setAssociatedObject(self, &UIViewPanGestureBlockKey, panGestureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"panGestureBlock"];
}

- (UIViewPanGestureBlock)panGestureBlock {
    return objc_getAssociatedObject(self, &UIViewPanGestureBlockKey);
}

- (void)addTapGestureWithDelegate:(id)delegate handleBlock:(UIViewTapGestureBlock)handle {
    self.userInteractionEnabled = YES;
    self.tapGestureBlock = [handle copy];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    if(delegate) tap.delegate = delegate;
    [self addGestureRecognizer:tap];
}

- (void)addTapGestureHandleBlock:(UIViewTapGestureBlock)handle {
    [self addTapGestureWithDelegate:nil handleBlock:handle];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if(self.tapGestureBlock) {
        self.tapGestureBlock(self, tap);
    }
}

- (void)addPanGestureWithDelegate:(id)delegate handleBlock:(UIViewPanGestureBlock)handle {
    self.userInteractionEnabled = YES;
    self.panGestureBlock = [handle copy];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    if(delegate) pan.delegate = delegate;
    [self addGestureRecognizer:pan];
}

- (void)addPanGestureHandleBlock:(UIViewPanGestureBlock)handle {
    [self addPanGestureWithDelegate:nil handleBlock:handle];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if(self.panGestureBlock) {
        self.panGestureBlock(self, pan);
    }
}
@end
