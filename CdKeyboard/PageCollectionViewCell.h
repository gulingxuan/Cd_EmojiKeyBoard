//
//  PageCollectionViewCell.h
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/9/29.
//  Copyright © 2016年 cd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy)void(^emojiBlock)(NSString *str);
@property (nonatomic,copy)void(^deleteBlock)();

-(void)setDataArr:(NSArray *)dataArr withEmojiNumH:(NSInteger)emojiNumH withEmojiNumV:(NSInteger)emojiNumV;



@end
