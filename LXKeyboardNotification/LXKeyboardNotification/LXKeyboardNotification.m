//
//  LXKeyboardNotification.m
//  LXKeyboardNotification
//
//  Created by gkoudai_xl on 15/10/6.
//  Copyright © 2015年 longxdragon. All rights reserved.
//

#import "LXKeyboardNotification.h"

@interface LXKeyboardNotification () {
    UIView  *_superView;
    CGRect  _superOriginFrame;
    CGFloat _superViewTopMargin;
}
@end

@implementation LXKeyboardNotification

+ (instancetype)defaultNotification {
    static LXKeyboardNotification *notifi = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        notifi = [[LXKeyboardNotification alloc] init];
    });
    return notifi;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideNotify:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Private Methods

- (void)keyboardShowNotify:(NSNotification *)notify {
    // 键盘高度
    NSDictionary *info = [notify userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGSize keyboardSize = [value CGRectValue].size;
    
    UIView *firstResponderView = [self getFirstResponderAtView:_superView];
    if (firstResponderView) {
        CGFloat bottomY = [self caculateAbsoluteBottomY:firstResponderView];
        if (bottomY + keyboardSize.height > [UIScreen mainScreen].bounds.size.height) {
            CGFloat length = [UIScreen mainScreen].bounds.size.height - (bottomY + keyboardSize.height);
            
            [UIView animateWithDuration:duration animations:^{
                CGRect frame = _superView.frame;
                frame.origin.y = _superOriginFrame.origin.y + length;
                _superView.frame = frame;
            }];
        }
    }
}

- (void)keyboardHideNotify:(NSNotification *)notify {
    NSDictionary *info = [notify userInfo];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        _superView.frame = _superOriginFrame;
    }];
}

- (UIView *)getFirstResponderAtView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if (subView.isFirstResponder) {
            return subView;
        }
    }
    // 没有找到，继续子view寻找
    for (UIView *subView in view.subviews) {
        UIView *firstResponderView = [self getFirstResponderAtView:subView];
        if (firstResponderView && firstResponderView.isFirstResponder) {
            return firstResponderView;
        }
    }
    return nil;
}

- (CGFloat)caculateAbsoluteBottomY:(UIView *)view {
    CGFloat bottomY = CGRectGetMaxY(view.frame);
    
    UIView *subView = view;
    while (subView.superview != _superView) {
        subView = subView.superview;
        // 如果是滚动视图，应该计算偏移量
        if ([subView isKindOfClass:[UIScrollView class]]) {
            bottomY -= ((UIScrollView *)subView).contentOffset.y;
        }
        bottomY += subView.frame.origin.y;
    }
    //
    // 这边添加 _superViewTopMargin 为 传入的 _superView 距离整个屏幕的上边距
    // 因为此处的计算是否上移，是根整个屏幕的高度进行比较的
    // 并且 _superView 的原始Y位置也有可能不为0
    // 还有可能 _superView 还有好几层的superView
    // 这边也需要考虑是否是滚动视图
    //
    bottomY += _superViewTopMargin;
    if ([_superView isKindOfClass:[UIScrollView class]]) {
        bottomY -= ((UIScrollView *)_superView).contentOffset.y;
    }
    
    return bottomY;
}

#pragma mark - Public Methods

- (void)addKeyboardNotificationForSuperView:(UIView *)view
                         superViewTopMargin:(CGFloat)topMargin {
    _superView = view;
    _superOriginFrame = view.frame;
    _superViewTopMargin = topMargin;
}

@end
