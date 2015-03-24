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
//1.布局
@property (strong,nonatomic)IS_EditSetLayout * editSetLayout;
//2.底部 button
@property (strong,nonatomic)UIButton * closeButton;
@end

@implementation IS_SenceGirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
  
    [self setupCollectionView];
   
    [self setupClosebtn];

    
    
    
}
#pragma mark - 

-(void)setupCollectionView{
    //0.布局
    self.editSetLayout = [[IS_EditSetLayout alloc]init];
    //1.添加集合视图
    [self.view addSubview:self.collectionView];
    [self.collectionView addGestures];
    
    
    //2.注册 Cell
    [self.collectionView registerClass:[IS_SenceEditCell class] forCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID];
    
    //3.单击
    
    UITapGestureRecognizer * tap_dismss =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapDismiss:)];
    [_collectionView addGestureRecognizer:tap_dismss];
    [_collectionView setUserInteractionEnabled:YES];
}
-(IS_EditCollectionView *)collectionView{
    
    if (!_collectionView) {
        
        CGRect frame = CGRectMake(0, 10, ScreenWidth, ScreenHeight-100);
        _collectionView = [[IS_EditCollectionView alloc]initWithFrame:frame collectionViewLayout:self.editSetLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource=self;
        _collectionView.move_delegate=self;
        
        
        
    }
    return _collectionView;

}
#pragma mark  -关闭
#define CLOSE_BUTTON_WIDTH 60

-(void)setupClosebtn{
    
    _closeButton = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-CLOSE_BUTTON_WIDTH)/2, ScreenHeight-70, CLOSE_BUTTON_WIDTH,CLOSE_BUTTON_WIDTH)];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"IS_Edit_Close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
}

- (void)closeButtonAction:(UIButton*)btn{

    if ([self.delegate respondsToSelector:@selector(IS_SenceGirdControllerDidUpdate:)]) {
        [self.delegate IS_SenceGirdControllerDidUpdate:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 手势
-(void)handleTapDismiss:(UIGestureRecognizer*)gesture{
    CGPoint point =  [gesture locationInView:self.collectionView];  //create your custom index path here
    NSIndexPath * indexPath = [self indexPathForItemClosestToPoint:point];
    if (indexPath) {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];

    }
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
    IS_SenceTemplateModel *fromTemplateModel = self.sence_array[fromIndexPath.item];
    IS_SenceTemplateModel * toTemplateModel = self.sence_array[toIndexPath.item];

    //0.改变子视图的page
    [fromTemplateModel.subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IS_SenceSubTemplateModel * subModel = obj;
        subModel.page = toTemplateModel.row_num;
        [fromTemplateModel.subview_array replaceObjectAtIndex:idx withObject:subModel];
    }];
    
    [toTemplateModel.subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IS_SenceSubTemplateModel * subModel = obj;
        subModel.page = fromTemplateModel.row_num;
        [toTemplateModel.subview_array replaceObjectAtIndex:idx withObject:subModel];
    }];
    
    
    //2.改吧 row_num
    NSInteger temp = toTemplateModel.row_num;
    toTemplateModel.row_num =fromTemplateModel.row_num;
    fromTemplateModel.row_num=temp;
    
    //3.插入
    
    [_sence_array removeObjectAtIndex:fromIndexPath.item];
    [_sence_array insertObject:fromTemplateModel atIndex:toIndexPath.item];
    
    

    
    
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
