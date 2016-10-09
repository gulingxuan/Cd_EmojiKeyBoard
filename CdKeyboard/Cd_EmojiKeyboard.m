//
//  Cd_EmojiKeyboard.m
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/9/23.
//  Copyright © 2016年 cd. All rights reserved.
//

#import "Cd_EmojiKeyboard.h"
#import "PageCollectionViewCell.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@interface Cd_EmojiKeyboard()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, copy)NSArray *emjDataArr;//emoji数据源
@property (nonatomic, strong)UICollectionView *emjCollection;//展示emoji
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, assign)NSInteger emojiNumH;//每行有多少个表情
@property (nonatomic, assign)NSInteger emojiNumV;//有多少列
@property (nonatomic, assign)NSInteger pageNum;//每页有多少个表情


@end


@implementation Cd_EmojiKeyboard


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, Height, Width, Height)];
        [self addSubview:self.bgView];
        self.emojiNumH = (Width - 10)/40;
        self.emojiNumV = (Height - 10)/40;
        NSLog(@"表情高度：%f",Height);
        CGFloat numV = (Height - 10)/(float)40;
        self.pageNum = self.emojiNumH * self.emojiNumV;
//        NSLog(@"h:%ld, v = %ld , sum = %ld",self.emojiNumH,self.emojiNumV,self.pageNum);
        [self loadEmjData];

        [self createCollection];
    }
    return self;
}

//获取表情符号数组（unicode）
-(void)loadEmjData
{
    NSDictionary *emojiDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"]];

    
    if (emojiDic)
    {
        NSMutableArray *mArr = [emojiDic[@"People"] mutableCopy];
        for (NSString *str in emojiDic[@"Nature"])
        {
            [mArr addObject:str];
        }
        NSMutableArray *emojiArr = [NSMutableArray array];
        NSMutableArray *temp;
        NSInteger pageTemp = 0;
        for (int i = 0; i < mArr.count;i++)
        {
            if (!((i+pageTemp)%self.pageNum))
            {
                temp = [NSMutableArray array];
                [emojiArr addObject:temp];
                pageTemp++;
            }
            [temp addObject:mArr[i]];
        }
        self.emjDataArr = emojiArr;
    }

}

-(void)createCollection
{
    //分页控制器
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, Height - 30, Width, 20)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.emjDataArr.count;
    self.pageControl.backgroundColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.pageControl];
    //collectionView布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //水平布局
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //设置每个表情页面的大小
    layout.itemSize=CGSizeMake(Width, Height - 30);
    //设置分区的内容偏移
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.emjCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,Width, Height-30) collectionViewLayout:layout];
    [self.emjCollection registerClass:[PageCollectionViewCell class] forCellWithReuseIdentifier:@"EmojiCell"];
    //打开分页效果
    self.emjCollection.pagingEnabled = YES;
    self.emjCollection.showsHorizontalScrollIndicator = NO;
    //设置行列间距
    layout.minimumLineSpacing=0;
    layout.minimumInteritemSpacing=0;
    
    self.emjCollection.delegate=self;
    self.emjCollection.dataSource=self;
    self.emjCollection.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.emjCollection];
}

//有self.emjDataArr.count页表情
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"表情页数：%ld",self.emjDataArr.count);
    return self.emjDataArr ? self.emjDataArr.count : 0;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setDataArr:self.emjDataArr[indexPath.row] withEmojiNumH:self.emojiNumH withEmojiNumV:self.emojiNumV];
    __weak typeof(self) weakSelf = self;
    cell.emojiBlock = ^(NSString *str)
    {
        if (weakSelf.selectEmjBlock)
        {
            weakSelf.selectEmjBlock(str);
        }
    };
    cell.deleteBlock = ^
    {
        if (weakSelf.deleteEmjBlock)
        {
            weakSelf.deleteEmjBlock();
        }
    };
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSString * str = self.emjDataArr[indexPath.section*28+indexPath.row];
//    NSLog(@"点击的表情：%@",str);
    //这里手动将表情符号添加到textField上
    
}
//翻页后对分页控制器进行更新
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contenOffset = scrollView.contentOffset.x;
    int page = contenOffset/scrollView.frame.size.width+((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
    self.pageControl.currentPage = page;
    
}

-(void)showEmojiKey
{
    self.bgView.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.frame = self.bounds;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)closeEmojiKey
{
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.frame = CGRectMake(0, Height, Width, Height);
    } completion:^(BOOL finished) {
        self.bgView.alpha = 0;
    }];
}

@end




