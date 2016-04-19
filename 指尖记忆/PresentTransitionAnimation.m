
//
//  PresentTransitionAnimation.m
//  指尖记忆
//
//  Created by Comex on 16/2/15.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "PresentTransitionAnimation.h"

@interface PresentTransitionAnimation () 

@property (nonatomic, assign) PresentTransitionType type;

@end

@implementation PresentTransitionAnimation

+ (instancetype)transitionWithTransitionType:(PresentTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(PresentTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning
//动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return _type == PresentTransitionTypePresent ? 0.9 : 0.5;
}

//动画过程
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //为了将两种动画的逻辑分开，变得更加清晰
    switch (_type) {
        case PresentTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
            
        case PresentTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
    }
}

#pragma mark 实现present和dismiss动画
/**
 *  实现present动画
 */
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
  
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *snapshot = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = fromVC.view.frame;
    
    fromVC.view.hidden = YES;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:snapshot];
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    
    toVC.view.transform = CGAffineTransformMakeScale(0.85, 0.85);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        
        snapshot.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT - 80);
        toVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {

            fromVC.view.hidden = NO;
            [snapshot removeFromSuperview];
        }
    }];
}

/**
 *  实现dimiss动画
 */
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
   
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSArray *subviewsArray = containerView.subviews;
    UIView *snapshot = subviewsArray[MIN(subviewsArray.count, MAX(0, subviewsArray.count - 1))];
//    UIView *snapshot = subviewsArray[subviewsArray.count-1];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
       
        snapshot.transform = CGAffineTransformIdentity;
        fromVC.view.transform = CGAffineTransformMakeScale(0.85, 0.85);
        
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            [snapshot removeFromSuperview];
        }
    }];
}
@end
