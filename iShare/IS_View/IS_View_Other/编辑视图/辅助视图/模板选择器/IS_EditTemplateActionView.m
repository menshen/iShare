//
//  IS_SenceTemplatePanView.m
//  iShare
//
//  Created by 伍松和 on 15/1/22.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditTemplateActionView.h"
#import "IS_EditTemplateSelectModel.h"
#import "IS_SenceTemplateModel.h"


#import "IS_EditTemplateCell.h"
#import "IS_CommonLayout.h"
#import "IS_CollectionView.h"

#define IS_SenceCreateViewDidChangeTemplate @"IS_SenceCreateViewDidChangeTemplate"

#define TITLE_KEY @"title"
#define IMG_KEY   @"img"

#define BOTTOM_BTN_WIDTH ScreenWidth/5
#define COVER_WINDOW_H ScreenHeight/2
#define BOTTOM_SHEET_H 50
#define COLLECTION_W ScreenWidth
#define COLLECTION_H ScreenHeight/2-BOTTOM_SHEET_H
#define COLLECTION_HEADER_H 20
@interface IS_EditTemplateActionView()


@end

@implementation IS_EditTemplateActionView{
    NSMutableArray * _btnArray;
    UIView * _containView;
    UIButton * _selectBtn;
    UIImageView * _bottomView;
    NSIndexPath * _curIndexPath;
}

-(void)dealloc{[[NSNotificationCenter defaultCenter]removeObserver:self];}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
      }
    return self;
    
}
- (void)setup{
    //0.
    
    //1.默认
    

    [self setupContainView];
    [self setupCollectionView];
    [self setupHeaderView];
    [self setupBottomView];
    [self setupDatasource];

    
    

}
- (void)setupDatasource{
    NSMutableArray * arrayM = [NSMutableArray array];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_1];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_2];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_3];
    
    NSArray * a_m = [IS_EditTemplateSelectModel objectArrayWithKeyValuesArray:arrayM];
    self.c_datasource = [NSMutableArray arrayWithArray:a_m];
    _curIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    [self.collectionView reloadData];
}
- (void)setupContainView{
    _containView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/2)];
    [self addSubview:_containView];
    [UIView animateWithDuration:.3 animations:^{
        [_containView setFrame:CGRectMake(0, ScreenHeight/2, ScreenWidth, ScreenHeight/2)];
        
    }];

}

- (void)setupHeaderView{
    UIView * headerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, COLLECTION_HEADER_H)];
    headerView.backgroundColor = IS_SYSTEM_WHITE_COLOR;
    [_containView addSubview:headerView];
}
- (void)setupCollectionView{

    [super setupCollectionView];
    
    self.commonLayout.sectionInset = UIEdgeInsetsMake(COLLECTION_HEADER_H+10, 35,5,35);
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.commonLayout.minimumLineSpacing  =5;
    CGFloat W = ScreenWidth/2-40;
    CGFloat H = W*1.5;
    self.commonLayout.itemSize = CGSizeMake(W, H);
    self.collectionView.pagingEnabled = NO;
    self.collectionView.backgroundColor = IS_SYSTEM_WHITE_COLOR;
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    [self.collectionView registerClass:[IS_EditTemplateCell class] forCellWithReuseIdentifier:IS_EditTemplateCell_ID];
    self.collectionView.frame =_containView.bounds;
    self.collectionView.height -=BOTTOM_SHEET_H;
    [self.collectionView removeFromSuperview];
    [_containView addSubview:self.collectionView];


}
- (void)setupBottomView{
    
    
    _btnArray = [NSMutableArray array];
    
    _bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0,_containView.height- BOTTOM_SHEET_H, ScreenWidth, BOTTOM_SHEET_H)];
    _bottomView.userInteractionEnabled = YES;
    _bottomView.image = [UIImage resizedImage:@"IS_Toolbar_up"];
    [_containView addSubview:_bottomView];
    
    //1.5个数组
    NSArray * btn_infos =@[@{TITLE_KEY:@"",IMG_KEY:@"bottom_template_icon_cancel"},
                           @{TITLE_KEY:@"纯图",IMG_KEY:@""},
                           @{TITLE_KEY:@"少字",IMG_KEY:@""},
                           @{TITLE_KEY:@"多字",IMG_KEY:@""},
                           @{TITLE_KEY:@"",IMG_KEY:@"bottom_template_icon_comfire"}];
    for (int i = 0; i<5; i++) {
        CGRect frame = CGRectMake(BOTTOM_BTN_WIDTH * i, 0, BOTTOM_BTN_WIDTH, BOTTOM_SHEET_H);
        UIButton * btn = [[UIButton alloc]initWithFrame:frame];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:IS_SYSTEM_COLOR forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        NSDictionary * info = btn_infos[i];
        if ([info[IMG_KEY] length]==0&&info[TITLE_KEY]) {
            [btn setTitle:info[TITLE_KEY] forState:UIControlStateNormal];
            
        }else if ([info[TITLE_KEY] length]==0&&info[IMG_KEY]){
            [btn setImage:[UIImage imageNamed:info[IMG_KEY]] forState:UIControlStateNormal];
            
        }
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_btnArray addObject:btn];
        [_bottomView addSubview:btn];
        
    }
    
    UIButton * btn_3 = _btnArray[2];
    [self btnAction:btn_3];
    
    
}
-(void)btnAction:(UIButton *)btn{
    
    if (btn.tag==0) {
        [self dismissActionSheet];
       
    }else if(btn.tag==4){
        if (self.actonSheetBlock) {
            if (_curIndexPath.row>=0) {
                IS_EditTemplateSelectModel * p = self.c_datasource[_curIndexPath.row];
                self.actonSheetBlock (p);
            }else{
                [self dismissActionSheet];

            }
           
        }
    }else{
        _selectBtn.selected = !_selectBtn.selected;
        btn.selected = YES;
        _selectBtn = btn;
    }
    
    
    
}





#pragma mark --- **控制
-(void)dismissActionSheet{
    
    [UIView animateWithDuration:.25 animations:^{
        [_containView setFrame:CGRectMake(0, ScreenHeight,ScreenWidth, ScreenHeight/2)];
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.c_datasource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
      IS_EditTemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_EditTemplateCell_ID forIndexPath:indexPath];
//    NSDictionary * dic =
    cell.templatePanModel = self.c_datasource [indexPath.row];//[[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _curIndexPath  = indexPath;
//    
//    NSDictionary * dic = self.c_datasource [indexPath.row];
//    IS_SenceTemplatePanModel * senceTemplatePanModel = [[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
//    [self.c_Delegate IS_CollectionViewDidSelectItem:senceTemplatePanModel];
}
- (void)reloadCollectionViewData{
    [self.collectionView reloadData];
}

@end
