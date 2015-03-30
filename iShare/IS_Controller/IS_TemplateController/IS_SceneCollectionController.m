//
//  IS_SenceCollectionController.m
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SceneCollectionController.h"
#import "IS_SenceCreateController.h"
#import "IS_EditTemplateSelectModel.h"
#import "IS_EditTemplateCell.h"

@interface IS_SceneCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@end

@implementation IS_SceneCollectionController{
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout * _commonLayout;
    NSMutableArray * _datasource;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupLayout];
    [self setupCollectionView];
    [_collectionView reloadData];
}
//#define W (ScreenWidth/2-40)
//#define H  W*1.5
- (void)setupLayout{
    _commonLayout = [[UICollectionViewFlowLayout alloc]init];
    _commonLayout.sectionInset = UIEdgeInsetsMake(30, 35, 5,35);
    _commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _commonLayout.minimumLineSpacing  =5;
    CGFloat W = self.view.width/2-40;
    CGFloat H = W*1.5;
    _commonLayout.itemSize = CGSizeMake(W, H);
}
- (void)setupCollectionView{
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-120) collectionViewLayout:_commonLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[IS_EditTemplateCell class] forCellWithReuseIdentifier:IS_EditTemplateCell_ID];
    
    [self.view addSubview:_collectionView];
    
    

}
#pragma mark - 

-(void)appendDatasource:(NSMutableArray *)datasource{
    _datasource = [NSMutableArray array];
    NSArray * array = [IS_EditTemplateSelectModel objectArrayWithKeyValuesArray:datasource];
    _datasource =[NSMutableArray arrayWithArray:array];
    [_datasource addObjectsFromArray:array];
  //  [_collectionView reloadData];
}

#pragma mark - Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{return 1;}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _datasource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IS_EditTemplateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_EditTemplateCell_ID forIndexPath:indexPath];
    cell.templatePanModel =_datasource [indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IS_SenceCreateController * sc = [[IS_SenceCreateController alloc]init];
    IS_EditTemplateSelectModel * s =_datasource [indexPath.row];
    sc.firstEditModel = s;
    
    if (self.sceneChooseType==IS_SceneChooseTypeCreate) {
        
        if (self.navigationController) {
            [self.navigationController pushViewController:sc animated:YES];

        }else{
            [self.delegate IS_SceneCollectionControllerDidSceneChange:s];

        }

    }else{

    }
    
}

@end
