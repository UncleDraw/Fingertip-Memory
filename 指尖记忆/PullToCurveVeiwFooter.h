//
//  PullToCurveVeiwFooter.h
//  指尖记忆
//
//  Created by Comex on 16/2/19.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PullToCurveVeiwFooter : UIView

/**
 *  需要滑动多大距离才能松开
 */
@property(nonatomic,assign)CGFloat pullDistance;


/**
 *  初始化方法
 *
 *  @param scrollView 关联的滚动视图
 *
 *  @return self
 */
-(id)initWithAssociatedScrollView:(UIScrollView *)scrollView withNavigationBar:(BOOL)navBar;


/**
 *  present执行的具体操作
 *
 *  @param block 操作
 */
@property (nonatomic,copy) void (^presentBlock) (void);

@end
