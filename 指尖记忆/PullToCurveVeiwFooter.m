
//
//  PullToCurveVeiwFooter.m
//  指尖记忆
//
//  Created by Comex on 16/2/19.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "PullToCurveVeiwFooter.h"
#import "UIView+Convenient.h"
#import "CurveView.h"

@interface PullToCurveVeiwFooter()

@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,weak) UIScrollView *associatedScrollView;


@end

@implementation PullToCurveVeiwFooter {

    CurveView *curveView;
    CGSize contentSize;
    CGFloat originOffset;
    BOOL willEnd;
    BOOL notTracking;
    BOOL loading;
}

#pragma mark -- Public Method

-(id)initWithAssociatedScrollView:(UIScrollView *)scrollView withNavigationBar:(BOOL)navBar{
    
    self = [super initWithFrame:CGRectMake(0, scrollView.contentSize.height - 10, 0, 0)];
    if (self) {
        if (navBar) {
            originOffset = 64.0f;
        }else{
            originOffset = 0.0f;
        }
        self.associatedScrollView = scrollView;
        [self setUp];
        [self.associatedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.associatedScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.hidden = YES;
        [self.associatedScrollView insertSubview:self atIndex:0];
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)setProgress:(CGFloat)progress{
    curveView.progress = progress;
}


#pragma mark -- Helper Method

-(void)setUp{
    //一些默认参数
    self.pullDistance = 99;
    curveView = [[CurveView alloc]initWithFrame:CGRectMake(self.center.x-40, 0, 40, 40)];
//    [curveView setBackgroundColor:[UIColor redColor]];
    [self insertSubview:curveView atIndex:0];
}

#pragma mark -- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        contentSize = [[change valueForKey:NSKeyValueChangeNewKey]CGSizeValue];
        if (contentSize.height > 0.0) {
            self.hidden = NO;
        }
        self.frame = CGRectMake(self.associatedScrollView.width/2-200/2, contentSize.height, 200, 100);
    }
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey]CGPointValue];

        if (contentOffset.y >= (contentSize.height - self.associatedScrollView.height)) {
            
            self.center = CGPointMake(self.center.x, contentSize.height + (contentOffset.y - (contentSize.height - self.associatedScrollView.height))/2);
    
            self.progress = MAX(0.0, MIN((contentOffset.y - (contentSize.height - self.associatedScrollView.height)) / self.pullDistance, 1.0));
        }
    }
   
}

#pragma dealloc

-(void)dealloc{
    [self.associatedScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.associatedScrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
