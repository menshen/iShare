//
//  IS_SenceGirdController.m
//  iShare
//
//  Created by 伍松和 on 15/2/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SenceGirdController.h"

#import "IS_EditCollectionView.h"
#import "IS_EditSetLayout.h"
#import "IS_SenceEditCell.h"

@interface IS_SenceGirdController ()<UICollectionViewDataSource,UICollectionViewDelegate,IS_EditCollectionViewDelegate>
@property (strong,nonatomic)IS_EditSetLayout * editSetLayout;
@end

@implementation IS_SenceGirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //0.布局
    self.editSetLayout = [[IS_EditSetLayout alloc]init];
    
    //1.添加集合视图
    [self.view addSubview:self.collectionView];
    [self.collectionView addGestures];

    
    //2.注册 Cell
    [self.collectionView registerClass:[IS_SenceEditCell class] forCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID];
    
    //3.单击
   
//    UITapGestureRecognizer*  tapPressGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
//    [self.view addGestureRecognizer:tapPressGestureRecognizer];

    UITapGestureRecognizer * tap_dismss =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapDismiss:)];
    [_collectionView addGestureRecognizer:tap_dismss];
    [_collectionView setUserInteractionEnabled:YES];

    
    
    
}

-(IS_EditCollectionView *)collectionView{
    
    if (!_collectionView) {
        
        _collectionView = [[IS_EditCollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.editSetLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource=self;
        _collectionView.move_delegate=self;
        
        
        
    }
    return _collectionView;

}
#pragma mark - 手势
-(void)handleTapDismiss:(UIGestureRecognizer*)gesture{
    CGPoint point =  [gesture locationInView:self.collectionView];  //create your custom index path here
    NSIndexPath * indexPath = [self indexPathForItemClosestToPoint:point];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}
#pragma mark - 根据CGPoint对象获取对应的NSIndexPath
- (NSIndexPath *)indexPathForItemClosestToPoint:(CGPoint)point
{
    NSIndexPath *indexPath;
    
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        if (CGRectContainsPoint(cell.frame, point)) {
            indexPath = [self.collectionView indexPathForCell:cell];
            break;
        }
    }
    return indexPath;
}
#pragma mark - UICollectionView-Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sence_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IS_SenceEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID forIndexPath:indexPath];
    
    IS_SenceTemplateModel * senceTemplateModel =self.sence_array[indexPath.row];
    
    senceTemplateModel.senceTemplateShape = IS_SenceTemplateShapeGird;
    cell.senceCreateEditView.userInteractionEnabled=NO;
    cell.senceTemplateModel = senceTemplateModel;
    
    
    cell.close_btn.tag=indexPath.row;
    [cell.close_btn addTarget:self action:@selector(handleDel:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.delegate respondsToSelector:@selector(IS_SenceGirdControllerDidUpdate:)]) {
        [self.delegate IS_SenceGirdControllerDidUpdate:indexPath];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  -----------Delegate

#pragma mark - 数据重置
- (void)collectionView:(IS_EditCollectionView *)collectionView
            moveItemAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath{
    
    IS_SenceTemplateModel *t = self.sence_array[fromIndexPath.item];
    
    [_sence_array removeObjectAtIndex:fromIndexPath.item];
    [_sence_array insertObject:t atIndex:toIndexPath.item];
}
-(void)handleDel:(UIButton*)btn{
    
    NSInteger row = btn.tag;
    NSIndexPath * remove_indexPath = [NSIndexPath indexPathForRow:row inSection:0];
  [self.collectionView performBatchUpdates:^{
      [_sence_array removeObjectAtIndex:row];
      [self.collectionView deleteItemsAtIndexPaths:@[remove_indexPath]];

  } completion:^(BOOL finished) {
      [self.collectionView reloadData];

  }];
    
  
   
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}
@end
