//
//  PageCollectionViewCell.m
//  CdKeyboardDemo
//
//  Created by 顾泠轩 on 16/9/29.
//  Copyright © 2016年 cd. All rights reserved.
//

#import "PageCollectionViewCell.h"
#import "CollectionViewCell.h"
#import "deleteCell.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@interface PageCollectionViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *pageCV;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, assign)NSInteger emojiNumH;
@property (nonatomic, assign)NSInteger emojiNumV;

@end

@implementation PageCollectionViewCell

-(UICollectionView*)pageCV
{
    if (!_pageCV)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(30, 30);
         layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
        float xOffset = (Width - self.emojiNumH * 30 - (self.emojiNumH - 1) * 10)/2;
        float yOffset = (Height - self.emojiNumV * 30 - (self.emojiNumV - 1) * 10)/2;
        layout.sectionInset = UIEdgeInsetsMake(yOffset, xOffset, yOffset, xOffset);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        _pageCV = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];

        [_pageCV registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"EmojiCell"];
        [_pageCV registerClass:[deleteCell class] forCellWithReuseIdentifier:@"DeleteCell"];
        _pageCV.dataSource = self;
        _pageCV.delegate = self;
        _pageCV.backgroundColor = [UIColor whiteColor];
        
    }
    return _pageCV;
}

-(void)setDataArr:(NSArray *)dataArr withEmojiNumH:(NSInteger)emojiNumH withEmojiNumV:(NSInteger)emojiNumV
{
    self.dataArr = dataArr;
    self.emojiNumV = emojiNumV;
    self.emojiNumH = emojiNumH;
    [self addSubview:self.pageCV];
    [self.pageCV reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr ? self.dataArr.count+1 : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArr.count)
    {
        CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCell" forIndexPath:indexPath];
        cell.label.font = [UIFont systemFontOfSize:25];
        cell.label.text = self.dataArr[indexPath.row];
        return cell;

    }
    else
    {
        deleteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeleteCell" forIndexPath:indexPath];
        cell.imgView.image = [UIImage imageNamed:@"faceDelete"];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.dataArr.count)
    {
        NSString *str = self.dataArr[indexPath.row];
        if (self.emojiBlock)
        {
            self.emojiBlock(str);
        }
    }
    else
    {
        if (self.deleteBlock)
        {
            self.deleteBlock();
        }
    }
    
}

@end


