//
//  ViewController.m
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/9/23.
//  Copyright © 2016年 cd. All rights reserved.
//


#import "ViewController.h"
#import "Cd_EmojiKeyboard.h"
#import "CommentView.h"



// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


//emoji键盘高度
#define Key_Height 200

//设备型号
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS [[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic, strong)CommentView *comment;
@property (nonatomic, assign)CGFloat keyHeight;//表情键盘高度
@property (nonatomic, assign)CGFloat commentHeight;//键盘总高度
@property (nonatomic, assign)CGFloat contentHeight;//评论内容高度
@property (nonatomic, assign)CGFloat keyTime;

@end

@implementation ViewController

-(CommentView *)comment
{
    NSLog(@"屏高：%f",[[UIScreen mainScreen] bounds].size.height);
    if (!_comment)
    {
        CGRect frame;
        if ([[UIScreen mainScreen] bounds].size.height == 736)
        {
            frame = CGRectMake(0, SCH - 40, SCW, 271 + 40);
            self.keyHeight = 271;
            self.commentHeight = 271 + 40;
        }
        else if(IS_IPHONE_6)
        {
            frame = CGRectMake(0,SCH - 40, SCW, 258 + 40);
            self.keyHeight = 258;
            self.commentHeight = 258 + 40;
        }
        else
        {
            frame = CGRectMake(0, SCH - 40, SCW, 253 + 40);
            self.keyHeight = 253;
            self.commentHeight = 253 + 40;
        }
        self.contentHeight = 40;
        _comment = [[CommentView alloc]initWithFrame:frame];
        __weak typeof(self) weakSelf = self;
        __weak typeof(_comment) weakCommet = _comment;
        _comment.showEmjKeyBlock = ^
        {
            [weakSelf.view endEditing:YES];
       
            [weakSelf setEmjKeyFrame];
             weakCommet.frame = CGRectMake(0, SCH - weakSelf.contentHeight, SCW, weakSelf.commentHeight);
            [UIView animateWithDuration:0.3 animations:^{
                weakCommet.frame = CGRectMake(0, SCH - weakSelf.commentHeight, SCW, weakSelf.commentHeight);
            } completion:^(BOOL finished) {
                
            }];

        };
        
        _comment.sendTextBlock = ^(NSString *str)
        {
            if (![weakSelf isEmpty:str])
            {
                weakSelf.contentLabel.text = str;
                [weakSelf.view endEditing:YES];
                [UIView animateWithDuration:0.3 animations:^{
                    weakCommet.frame = CGRectMake(0, SCH - 40, SCW, weakSelf.keyHeight + 40);
                } completion:^(BOOL finished) {
                    weakSelf.commentHeight = weakSelf.keyHeight + 40;
                    weakSelf.contentHeight = 40;
                    [weakSelf setEmjKeyFrame];
                    weakCommet.frame = CGRectMake(0, SCH - 40, SCW, weakSelf.keyHeight + 40);
                }];
                
            }
            
        };
        _comment.printEmjBlock = ^
        {
            [weakSelf changeText:weakCommet.commentView];
        };
    }
    return _comment;
}


//判断字符串是否为空
-(BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

-(void)setEmjKeyFrame
{
    self.comment.frame = CGRectMake(0, SCH - self.commentHeight, SCW, self.commentHeight);
    self.comment.commentView.frame = CGRectMake(45, 6 , SCW - 110, self.contentHeight - 12);
    self.comment.comV.frame = CGRectMake(0, 0, SCW, self.contentHeight);
    self.comment.emjKey.frame = CGRectMake(0, self.commentHeight - self.keyHeight + 10, SCW,self.keyHeight );
}

-(void)viewWillAppear:(BOOL)animated
{
    //注册键盘弹出时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardDidShowNotification object:nil];
    //注册键盘隐藏时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    //键盘弹出frame值改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    //textView文字内容改变，自适应高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI
{
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 100, SCW - 50, 40)];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.comment];
    
}


//弹出键盘时调用该方法
-(void)showKeyBoard:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"键盘高：%f",kbSize.height);
    [self.comment closeEmojiKeyBoard];
}

//隐藏键盘调用该方法
-(void)hiddenKeyBoard:(NSNotification *)notification
{

    
}

//键盘改变frame值响应
-(void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyTime = duration;
    if (self.contentHeight > 40)
    {
        [self setEmjKeyFrame];
    }
    else
    {
        [UIView animateWithDuration:duration animations:^{
            self.comment.frame = CGRectMake(0, SCH - self.keyHeight - 40, SCW, self.commentHeight + self.contentHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

//输入文字时调用 - 通知方法
-(void)textChanged:(NSNotification *)notification
{
    UITextView *textView = [notification object];
    [self changeText:textView];

}

-(void)changeText:(UITextView *)textView
{
    CGFloat height = textView.contentSize.height;
    static CGFloat tempH = 0;
    if (height > 28 && tempH > 28 && tempH != height)
    {
        self.commentHeight = height + 12 + self.keyHeight;
        self.contentHeight = height + 12;
        self.comment.frame = CGRectMake(0, SCH - self.commentHeight, SCW, self.commentHeight);
        self.comment.commentView.frame = CGRectMake(45, 6 , SCW - 110, height);
        self.comment.comV.frame = CGRectMake(0, 0, SCW, height + 12);
        self.comment.emjKey.frame = CGRectMake(0, self.commentHeight - self.keyHeight + 10, SCW,self.keyHeight );
    }
    tempH = height;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    CGFloat time = self.keyTime ? self.keyTime : 0.3;
    [UIView animateWithDuration:time animations:^{
        self.comment.frame = CGRectMake(0, SCH - self.contentHeight, SCW, self.commentHeight);
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
