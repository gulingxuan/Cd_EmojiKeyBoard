//
//  CommentView.h
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/10/7.
//  Copyright © 2016年 cd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cd_EmojiKeyboard.h"

@interface CommentView : UIView

//输入框
@property (nonatomic, strong)UITextView *commentView;
//输入框及表情、发送按钮父视图（用于调整frame实现自适应）
@property (nonatomic, strong)UIView *comV;
//表情键盘
@property (nonatomic, strong)Cd_EmojiKeyboard *emjKey;
//显示表情键盘，点击表情按钮时响应（用于收起系统键盘，推出表情键盘）
@property (nonatomic, copy)void(^showEmjKeyBlock)();
//
@property (nonatomic, copy)void(^sendTextBlock)(NSString *str);
@property(nonatomic,copy)void(^printEmjBlock)();

-(void)showEmojiKeyBoard;
-(void)closeEmojiKeyBoard;

@end
