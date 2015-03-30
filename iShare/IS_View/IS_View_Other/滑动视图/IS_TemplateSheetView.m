//
//  IS_SenceTemplatePanView.m
//  iShare
//
//  Created by 伍松和 on 15/1/22.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_TemplateSheetView.h"
#import "IS_SenceTemplatePanModel.h"
#import "IS_SenceTemplateModel.h"


#import "IS_TempateCollectionCell.h"
#import "IS_CommonLayout.h"
#import "IS_CollectionView.h"

#define IS_SenceCreateViewDidChangeTemplate @"IS_SenceCreateViewDidChangeTemplate"


@interface IS_TemplateSheetView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic ,strong)IS_CollectionView * collectionview;

@end

@implementation IS_TemplateSheetView

-(void)dealloc{[[NSNotificationCenter defaultCenter]removeObserver:self];}
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //0.
    self.backgroundColor = IS_SYSTEM_WHITE_COLOR;
    [self addSubview:self.collectionview];
    
    UINib * nib = [UINib nibWithNibName:IS_TempateCollectionCell_ID bundle:nil];
    [self.collectionview registerNib:nib forCellWithReuseIdentifier:IS_TempateCollectionCell_ID];
    
    //1.默认
    [self addDefault];
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
     
        
        
    }
    return self;
    
}
#pragma mark 
-(UICollectionView *)collectionview{
    
    if (!_collectionview) {
        IS_CommonLayout * layout = [[IS_CommonLayout alloc]init];
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, self.height-40) collectionViewLayout:layout];
        _collectionview.delegate =self;
        _collectionview.dataSource =self;
        _collectionview.backgroundColor = [UIColor clearColor];

    }
    return _collectionview;
    
}
#pragma mark - ...
-(void)addDefault{

    NSMutableArray * arrayM = [NSMutableArray array];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_1];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_2];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_3];
    
    self.template_dataSource = arrayM;

  

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.template_dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
      IS_TempateCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_TempateCollectionCell_ID forIndexPath:indexPath];
    NSDictionary * dic = self.template_dataSource [indexPath.row];
    cell.senceTemplatePanModel = [[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
