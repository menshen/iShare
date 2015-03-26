//
//  IS_SenceTemplatePanView.m
//  iShare
//
//  Created by 伍松和 on 15/1/22.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditTemplateActionView.h"
#import "IS_SenceTemplatePanModel.h"
#import "IS_SenceTemplateModel.h"


#import "IS_TempateCollectionCell.h"
#import "IS_CommonLayout.h"
#import "IS_CollectionView.h"

#define IS_SenceCreateViewDidChangeTemplate @"IS_SenceCreateViewDidChangeTemplate"


@interface IS_EditTemplateActionView()


@end

@implementation IS_EditTemplateActionView

-(void)dealloc{[[NSNotificationCenter defaultCenter]removeObserver:self];}
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
   
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
     
        [self setup];
        
    }
    return self;
    
}
- (void)setup{
    //0.
    self.backgroundColor = IS_SYSTEM_WHITE_COLOR;
    
    //1.默认
    [self addDefault];

}
- (void)setupCollectionView{

    [super setupCollectionView];
    
    self.commonLayout.sectionInset = UIEdgeInsetsMake(30, 35, 5,35);
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.commonLayout.minimumLineSpacing  =5;
    CGFloat W = ScreenWidth/2-40;
    CGFloat H = W*1.5;
    self.commonLayout.itemSize = CGSizeMake(W, H);
    self.collectionView.pagingEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    [self.collectionView registerClass:[IS_TempateCollectionCell class] forCellWithReuseIdentifier:IS_TempateCollectionCell_ID];

}
#pragma mark - ...
-(void)addDefault{
    
    //1.纯图
//    NSDictionary * picArray = @{@"type":@"mutil-pic",
//                                @"datasource":TEMPLATE_THEME_1};
//    
//    NSDictionary * picArray = @{@"type":@"mutil-pic",
//                                @"datasource":TEMPLATE_THEME_1};
    
    
    
    
//    NSArray * array_info = @[@]

    NSMutableArray * arrayM = [NSMutableArray array];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_1];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_2];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_3];
    
    self.c_datasource = arrayM;

  

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.c_datasource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
      IS_TempateCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_TempateCollectionCell_ID forIndexPath:indexPath];
    NSDictionary * dic = self.c_datasource [indexPath.row];
    cell.senceTemplatePanModel = [[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.c_datasource [indexPath.row];
    IS_SenceTemplatePanModel * senceTemplatePanModel = [[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
    [self.c_Delegate IS_CollectionViewDidSelectItem:senceTemplatePanModel];
}
- (void)reloadCollectionViewData{
    [self.collectionView reloadData];
}

@end
