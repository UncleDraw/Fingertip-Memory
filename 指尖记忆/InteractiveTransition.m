//
//  InteractiveTransition.m
//  指尖记忆
//
//  Created by Comex on 16/2/15.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "InteractiveTransition.h"

@interface InteractiveTransition () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIScrollView *scrollView;
/**手势方向*/
@property (nonatomic, assign) InteractiveTransitionGestureDirection direction;
/**手势类型*/
@property (nonatomic, assign) InteractiveTransitionType type;

@end

@implementation InteractiveTransition

+ (instancetype)interactiveTransitionWithTransitionType:(InteractiveTransitionType)type GestureDirection:(InteractiveTransitionGestureDirection)direction{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(InteractiveTransitionType)type GestureDirection:(InteractiveTransitionGestureDirection)direction{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    pan.delegate = self;
    [viewController.view addGestureRecognizer:pan];
}

- (void)addPanGestureForView:(UIView *)snapshot{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.view = snapshot;
//    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

- (void) getScrollViewInVC {
    
    NSArray *subViews = self.vc.view.subviews;
    
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
//            NSLog(@"Got it: %@", view);
            self.scrollView = (UIScrollView*)view;
            break;
        }
    }
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    
    //手势百分比
    CGFloat persent = 0;
    switch (_direction) {
        case InteractiveTransitionGestureDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case InteractiveTransitionGestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case InteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case InteractiveTransitionGestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.height;
        }
            break;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            
            [self getScrollViewInVC];
            
            if (_direction == InteractiveTransitionGestureDirectionDown && (persent < 0 || self.scrollView.contentOffset.y > 5)) break;
            
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            self.interation = NO;
//            NSLog(@"percent:%f", persent);
            if (persent > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture{
    switch (_type) {
        case InteractiveTransitionTypePresent:{
            if (_presentConifg) {
                _presentConifg();
            }
        }
            break;
            
        case InteractiveTransitionTypeDismiss:
//            [_vc dismissViewControllerAnimated:YES completion:nil];
            if (_dismissConifg) {
                _dismissConifg();
            }
            break;
        case InteractiveTransitionTypePush:{
            if (_pushConifg) {
                _pushConifg();
            }
        }
            break;
        case InteractiveTransitionTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
    }
}

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //NSLog(@"%i,%i",gestureRecognizer.view.tag,otherGestureRecognizer.view.tag);
    
    //注意，这里控制只有在UIImageView中才能向下传播，其他情况不允许
    //    if ([otherGestureRecognizer.view isKindOfClass:[UIImageView class]]) {
    //        return YES;
    //    }
    //    return NO;
    return YES;
}

@end
