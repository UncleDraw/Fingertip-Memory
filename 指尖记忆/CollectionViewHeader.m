//
//  CollectionViewHeader.m
//  旅行记忆
//
//  Created by Comex on 16/2/3.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "CollectionViewHeader.h"

@implementation CollectionViewHeader

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan");
}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesMoved");
//}
//
//- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesEnd");
//}

@end
