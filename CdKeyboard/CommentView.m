//
//  CommentView.m
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/10/7.
//  Copyright © 2016年 cd. All rights reserved.
//

#import "CommentView.h"


#define Width self.frame.size.width
#define Height self.frame.size.height

//设备型号
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )

@interface CommentView()



@end

@implementation CommentView

-(Cd_EmojiKeyboard *)emjKey
{
    if (!_emjKey)
    {
         NSLog(@"创建键盘的高度为：%f",self.frame.size.height);
        _emjKey = [[Cd_EmojiKeyboard alloc]initWithFrame:CGRectMake(0, 40, SCW, Height - 45)];
        __weak typeof (self) weakSelf = self;
        _emjKey.selectEmjBlock = ^(NSString *emjStr)
        {
            weakSelf.commentView.text = [NSString stringWithFormat:@"%@%@",weakSelf.commentView.text,emjStr];
            NSLog(@"%@",emjStr);
            if (weakSelf.printEmjBlock)
            {
                weakSelf.printEmjBlock();
            }
        };
        _emjKey.deleteEmjBlock = ^
        {
            //调用键盘删除功能
            [weakSelf.commentView deleteBackward];
        };
    
        if (IS_IPHONE_6_PLUS)
        {
            _emjKey.frame = CGRectMake(0, self.frame.size.height - 271, SCW, 271);
        }
        else if(IS_IPHONE_6)
        {
            _emjKey.frame = CGRectMake(0, self.frame.size.height - 258, SCW, 258);
        }
        else
        {
            _emjKey.frame = CGRectMake(0, self.frame.size.height - 243, SCW, 253);
        }

    }
    return _emjKey;
}

-(UITextView *)commentView
{
    if (!_commentView) {
        
        _commentView = [[UITextView alloc]initWithFrame:CGRectMake(45, 6 , SCW - 110, 28)];
        _commentView.layer.masksToBounds = NO;
        _commentView.layer.borderWidth = 0.5;
        _commentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _commentView.layer.cornerRadius = 4;
        _commentView.font = [UIFont systemFontOfSize:12];
    
    }
    return _commentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.comV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCW, 40)];
        self.comV.layer.masksToBounds = YES;
        self.comV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.comV.layer.borderWidth = 0.5;
        [self addSubview:self.comV];
        
        UIButton *emjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emjBtn.frame = CGRectMake(10, 10, 25, 25);
        [emjBtn setImage:[UIImage imageNamed:@"emj"] forState:UIControlStateNormal];
        [emjBtn setImage:[UIImage imageNamed:@"selectEmj"] forState:UIControlStateSelected];
        [emjBtn addTarget:self action:@selector(showEmojiKeyBoard) forControlEvents:UIControlEventTouchUpInside];
       
        
        [self.comV addSubview:emjBtn];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(SCW - 55, 8, 45, 24);
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.backgroundColor = [UIColor colorWithRed:0.40 green:0.79 blue:0.98 alpha:1.00];
        [sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
         sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sendBtn.layer.masksToBounds = YES;
        sendBtn.layer.cornerRadius = 4;
        [self.comV addSubview:sendBtn];
        [self.comV addSubview: self.commentView];
        NSLog(@"frame 高：%f",frame.size.height);
        [self addSubview:self.emjKey];
    }
    return self;
}


-(void)showEmojiKeyBoard
{
    if (self.showEmjKeyBlock)
    {
        self.showEmjKeyBlock();
    }
    [self.emjKey showEmojiKey];
}

-(void)closeEmojiKeyBoard
{
    [self.emjKey closeEmojiKey];
}


-(void)sendComment
{
    if (self.sendTextBlock)
    {
        self.sendTextBlock(self.commentView.text);
        self.commentView.text = nil;
    }
}

@end
