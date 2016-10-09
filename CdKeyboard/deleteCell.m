//
//  deleteCell.m
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/10/2.
//  Copyright © 2016年 cd. All rights reserved.
//

#import "deleteCell.h"

@implementation deleteCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imgView];
    }
    return self;
}

@end
