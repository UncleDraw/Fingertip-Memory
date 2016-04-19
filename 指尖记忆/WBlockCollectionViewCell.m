//
//  WBlockCollectionViewCell.m
//  旅行记忆
//
//  Created by Comex on 16/2/3.
//  Copyright © 2016年 Comex. All rights reserved.
//

#import "WBlockCollectionViewCell.h"

@implementation WBlockCollectionViewCell

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
}

@end
