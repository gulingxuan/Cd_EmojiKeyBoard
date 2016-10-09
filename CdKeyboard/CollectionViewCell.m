//
//  CollectionViewCell.m
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/9/28.
//  Copyright © 2016年 cd. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.label = [[UILabel alloc]initWithFrame:self.bounds];
        [self addSubview:self.label];
    }
    return self;
}

@end
