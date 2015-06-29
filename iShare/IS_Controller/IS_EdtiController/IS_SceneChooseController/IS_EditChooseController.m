//
//  IS_EditChooseController.m
//  iShare
//
//  Created by wusonghe on 15/4/7.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditChooseController.h"
#import "IS_SenceEditTool.h"
#import "IS_EditTemplateCell.h"
#import "IS_EditTemplateModel.h"
#import "KVNProgress.h"

#define CONTAIN_VIEW_H ScreenHeight
#define COLLECTION_W ScreenWidth
#define COLLECTION_H ScreenHeight-8
@interface IS_EditChooseController ()

@end

@implementation IS_EditChooseController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    NSArray * array = [IS_SenceEditTool getArrayFromReadJSONFileType:self.tempateStyle];
    self.datasource =[NSMutableArray arrayWithArray:array];
    [self reloadCollectionViewData];
    
    
}



-(void)setupCollectionView{
    
    [super setupCollectionView];
    
    
    self.commonLayout.sectionInset = UIEdgeInsetsMake(10, 35,5,35);
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.commonLayout.minimumLineSpacing  =5;
    CGFloat W = ScreenWidth/2-40;
    CGFloat H = W*1.5;
    self.commonLayout.itemSize = CGSizeMake(W, H);
    self.collectionView.pagingEnabled = NO;
    self.collectionView.backgroundColor = IS_SYSTEM_WHITE_COLOR;
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    [self.collectionView registerClass:[IS_EditTemplateCell class] forCellWithReuseIdentifier:IS_EditTemplateCell_ID];
    
//    CGFloat Y  = 50-10;
    self.view.frame =CGRectMake(0, 0, self.view.width, self.view.height-40);
    self.collectionView.frame =self.view.bounds;
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.datasource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IS_EditTemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_EditTemplateCell_ID forIndexPath:indexPath];
    //    NSDictionary * dic =
    cell.editShowModel = self.datasource [indexPath.row];//[[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    _curIndexPath  = indexPath;
//    //
    IS_EditTemplateModel * p = self.datasource[indexPath.row];
  //  IS_EditTemplateCell *cell = (IS_EditTemplateCell*)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
  
    
    [self.delegate IS_EditChooseControllerDidSelect:p];
    

}
- (void)reloadCollectionViewData{
    [self.collectionView reloadData];
}


@end
