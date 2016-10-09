//
//  Cd_EmojiKeyboard.h
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/9/23.
//  Copyright © 2016年 cd. All rights reserved.
//

#import <UIKit/UIKit.h>

//屏幕宽高
#define SCH [[UIScreen mainScreen]bounds].size.height
#define SCW [[UIScreen mainScreen]bounds].size.width

@interface Cd_EmojiKeyboard : UIView

@property(nonatomic,copy)void(^selectEmjBlock)(NSString *emjStr);
@property(nonatomic,copy)void(^deleteEmjBlock)();

-(void)showEmojiKey;
-(void)closeEmojiKey;

@end
