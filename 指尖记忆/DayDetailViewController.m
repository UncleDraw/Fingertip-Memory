//
//  DayDetailViewController.m
//  旅行记忆
//
//  Created by Comex on 16/2/3.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "DayDetailViewController.h"
#import "WBlockCollectionViewCell.h"
#import "CollectionViewHeader.h"
#import "CollectionViewFooter.h"
#import "SummaryViewController.h"
#import "DayBriefViewController.h"
#import "PresentTransitionAnimation.h"
#import "InteractiveTransition.h"
#import "PullToCurveVeiwFooter.h"
#import <POP.h>

#define WBLOCK_NUM 12
#define PADING_LINE 5
#define PADING_INTER 5
#define PADING_HOR 10
#define PADING_VER 5


static NSString * const reusedIdentifier = @"DBlockCell";
static NSString * const reusedHeader = @"CollectionViewHeader";
static NSString * const reusedFooter = @"CollectionViewFooter";

@interface DayDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIViewControllerTransitioningDelegate, DayBriefViewControllerDelegate>

@property (nonatomic, strong) InteractiveTransition *interactivePresent;
@property (nonatomic, strong) InteractiveTransition *interactiveDismiss;
@property (nonatomic, strong) NSArray *quesList;
@property (nonatomic, strong) PullToCurveVeiwFooter *footerView;
@property (nonatomic, assign) BOOL toolViewAnimationSwitch;

@end

@implementation DayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //using for launchimage display
    [NSThread sleepForTimeInterval:2.0];
    
//    if (SCREEN_HEIGHT == 736.0) { // 6plus
//        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0);
//    } else if (SCREEN_HEIGHT == 667.0) { //6
//        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -80, 0);
//    } else if (SCREEN_HEIGHT == 568.0) { //5
//        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -70, 0);
//    } else {  //4
//        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -100, 0);
//    }
    
    //初始化 interactivePeresent
    _interactivePresent = [InteractiveTransition interactiveTransitionWithTransitionType:InteractiveTransitionTypePresent GestureDirection:InteractiveTransitionGestureDirectionDown];
    typeof(self) weakSelf = self;
    _interactivePresent.presentConifg = ^(){
        [weakSelf present];
    };
    [_interactivePresent addPanGestureForViewController:self];
    
    //添加footer
    _footerView = [[PullToCurveVeiwFooter alloc]initWithAssociatedScrollView:self.collectionView withNavigationBar:NO];
}

- (void)present{

    DayBriefViewController *_dayBriefVC = [[UIStoryboard storyboardWithName:@"DayBrief" bundle:nil] instantiateViewControllerWithIdentifier:@"DayBrief"];
    
    _dayBriefVC.backBlock = ^(DayBriefViewController *vc) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
//    _interactiveDismiss = [InteractiveTransition interactiveTransitionWithTransitionType:InteractiveTransitionTypeDismiss GestureDirection:InteractiveTransitionGestureDirectionUp];
//    typeof(_dayBriefVC) weakDayBriefVC = _dayBriefVC;
//    _interactiveDismiss.dismissConifg = ^(){
//        [weakDayBriefVC dismissViewControllerAnimated:YES completion:nil];
//    };
//    [_interactiveDismiss addPanGestureForViewController:self];
    
    _dayBriefVC.transitioningDelegate = self;
    
    [self presentViewController:_dayBriefVC animated:YES completion:nil];
}


- (IBAction)homeBtnClick:(id)sender {
    
    [self present];
}

- (IBAction)summaryBtnClick:(id)sender {
    
    SummaryViewController *vc = [[UIStoryboard storyboardWithName:@"Summary" bundle:nil] instantiateViewControllerWithIdentifier:@"Summary"];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark Lazyload
- (NSArray *) quesList {
    
    if (!_quesList) {
        _quesList = @[@"今天我完成了什么？",
                      @"今天我锻炼身体了吗？",
                      @"今天我为家人做了什么？",
                      @"今天我关心朋友了吗？",
                      @"今天花了多少钱？",
                      @"今天吃什么好吃的了？",
                      @"我让明天更美好了吗？",
                      @"今天我美吗？",
                      @"今天开心吗？",
                      @"今天几点起的床？",
                      @"今天的任务达成了吗？",
                      @"今天最好的三件事是什么？"];
    }
    return _quesList;
}

#pragma mark UICollectionView DataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.quesList.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WBlockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedIdentifier forIndexPath:indexPath];
    
    cell.blockTitle.text = self.quesList[indexPath.row];
    [cell layoutIfNeeded];
    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    
        CollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusedHeader forIndexPath:indexPath];
        return header;
//    }
    
//    CollectionViewFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reusedFooter forIndexPath:indexPath];
//    return footer;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellNum = self.quesList.count;
        
    if (cellNum == 1) {
        
        return CGSizeMake(SCREEN_WIDTH - PADING_HOR*2, SCREEN_HEIGHT - 80 - 50);
        
    } else if (cellNum > 1 && cellNum < 9) {

        NSInteger rowNum = ceil(cellNum / 2.0); NSLog(@"rowNum:%ld", rowNum);
        
        return CGSizeMake((SCREEN_WIDTH - PADING_INTER - PADING_HOR*2) / 2, (SCREEN_HEIGHT - 80 - 50 - PADING_LINE*rowNum - PADING_VER*2) / rowNum);
        
    } else if (cellNum >= 9) {
        
        return CGSizeMake((SCREEN_WIDTH - PADING_INTER - PADING_HOR*2) / 2, (SCREEN_HEIGHT - 80 - 50 - PADING_LINE*5 - PADING_VER*2) / 5);
    }

//    NSLog(@"cellH:%f",cellH);
    return CGSizeMake(0, 0);
}

/**
 * Section中每个Cell的上下边距
 */
- (CGFloat)collectionView: (UICollectionView *)collectionView
                   layout: (UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex: (NSInteger)section{
    return PADING_LINE;
}

/**
 * Section中每个Cell的左右边距
 */
- (CGFloat)collectionView: (UICollectionView *)collectionView
                   layout: (UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex: (NSInteger)section{
    return PADING_INTER;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(PADING_VER, PADING_HOR, PADING_VER, PADING_HOR);
}


#pragma mark UICollectionViewDelegate
/**
 * Cell是否可以选中
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *selectedCell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        
        if ([cell isEqual:selectedCell]) {
            
            //选中的cell的放大
            POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.duration = 0.5;
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.05, 1.05)];
            [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.duration = 0.5;
            alphaAnimation.toValue = @1.0;
            [cell pop_addAnimation:alphaAnimation forKey:nil];
            
            [alphaAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                
                //                if (finished) {
                //
                //                    ZFMainTabBarController *mainTabBarVC = [[ZFMainTabBarController alloc] init];
                //                    mainTabBarVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                //                    mainTabBarVC.transitioningDelegate = self;
                //
                //                    self.interactionViewController = [ZFInteractiveTransition new];
                //                    [self presentViewController:mainTabBarVC animated:YES completion:NULL];
                //                }
                
            }];
        }
        else{
            
            //未选中的可视cell的缩放
            POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnimation.duration = 0.5;
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
            [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.duration = 0.5;
            alphaAnimation.toValue = @0.7;
            [cell pop_addAnimation:alphaAnimation forKey:nil];
            
        }
    }

}

/**
 * headerView或者footerView出现后调用该方法
 */
- (void)collectionView: (UICollectionView *)collectionView
didEndDisplayingSupplementaryView: (UICollectionReusableView *)view
      forElementOfKind: (NSString *)elementKind
           atIndexPath: (NSIndexPath *)indexPath{
    
    //    NSLog(@"第%ld个Section上第%ld个扩展View已经出现",indexPath.section ,indexPath.row);
    
}

#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [PresentTransitionAnimation transitionWithTransitionType:PresentTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [PresentTransitionAnimation transitionWithTransitionType:PresentTransitionTypeDismiss];
}

//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    InteractiveTransition *_interactiveDismiss = [_delegate interactiveTransitionForDismiss];
//    return _interactiveDismiss.interation ? _interactiveDismiss : nil;
//}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _interactivePresent.interation ? _interactivePresent : nil;
}

#pragma mark UIScorllViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    NSLog(@"scrollView.contentSize.height:%f", scrollView.contentSize.height);
//    NSLog(@"scrollView.contentOffset.y:%f", scrollView.contentOffset.y);
//    NSLog(@"scale:%f", (scrollView.contentSize.height - scrollView.contentOffset.y));
    
    if ((scrollView.contentSize.height - scrollView.contentOffset.y) < (SCREEN_HEIGHT - 50)) {
        
        if (!_toolViewAnimationSwitch) {
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                //隐藏toolview
                self.toolView.transform = CGAffineTransformMakeTranslation(0, 50);
                
            } completion:^(BOOL finished) {
                
                _toolViewAnimationSwitch = true;
            }];
        }
        
    } else {
        
        if (_toolViewAnimationSwitch) {
            
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.toolView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                _toolViewAnimationSwitch = false;
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (((SCREEN_HEIGHT - 50) - (scrollView.contentSize.height - scrollView.contentOffset.y)) > 80) {
        [self summaryBtnClick:nil];
    }
}

//#pragma mark DayBriefViewControllerDelegate
//- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent {
//    return _interactivePresent;
//}

#pragma mark MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
