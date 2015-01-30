
#import "IS_SenceCreateCollectionView.h"
#import "IS_SenceTemplateModel.h"
#import "IS_SenceEditCell.h"

//布局
#import "EBCardCollectionViewLayout.h"
//刷新控件
#import "AAPullToRefresh.h"

#define WEAKSELF __weak typeof(self) weakSelf = self


@interface IS_SenceCreateCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)AAPullToRefresh * right_refresh;

@end

@implementation IS_SenceCreateCollectionView



- (instancetype)senceCollectioneEditView{
    
    
        
        EBCardCollectionViewLayout* _cardCollectionViewLayout = [[EBCardCollectionViewLayout alloc]init];
        IS_SenceCreateCollectionView* _senceCollectioneEditView = [[IS_SenceCreateCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_cardCollectionViewLayout];
        
        _senceCollectioneEditView.decelerationRate=UIScrollViewDecelerationRateFast;
        _senceCollectioneEditView.delegate =self;
        _senceCollectioneEditView.dataSource=self;
        _senceCollectioneEditView.backgroundColor = kColor(240, 240, 240);
        _senceCollectioneEditView.showsHorizontalScrollIndicator=NO;
        _senceCollectioneEditView.showsVerticalScrollIndicator=NO;
        _senceCollectioneEditView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//contentInset
        UIOffset anOffset = UIOffsetMake(40, 10);
        [(EBCardCollectionViewLayout *)_senceCollectioneEditView.collectionViewLayout setOffset:anOffset];
        // right
     //   WEAKSELF;
        _right_refresh =  [_senceCollectioneEditView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
            NSLog(@"fire from right");
           // [weakSelf performSelector:@selector(doneSomeThing) withObject:nil afterDelay:0.2];
            
            
        }];
        _right_refresh.imageIcon = [UIImage imageNamed:@"launchpad"];
        _right_refresh.borderColor = [UIColor whiteColor];
    
    //2.初始化缓冲池处理
    [self registerClass:[IS_SenceEditCell class] forCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID];

    
    
    return _senceCollectioneEditView;
}

#pragma mark - UICollectionView-Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.senceDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IS_SenceEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID forIndexPath:indexPath];
    cell.senceTemplateModel = self.senceDataSource[indexPath.row];
    
    return cell;
}


#pragma mark - 每次滑动后得到当前编辑视图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.contentOffset, .size = self.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self indexPathForItemAtPoint:visiblePoint];
    
    
    
    
    //0.上一个senceTemplateModel
    IS_SenceTemplateModel * last_senceTemplateModel=nil;
    if (visibleIndexPath.row>0) {
        NSIndexPath * last_indexPath =[NSIndexPath indexPathForRow:visibleIndexPath.row-1 inSection:0];
        last_senceTemplateModel=self.senceDataSource[last_indexPath.row];
        last_senceTemplateModel.s_selected_tag=-1;
        last_senceTemplateModel.templateState=IS_SenceTemplateStateInsert; //都是重新开始插入
        [self.senceDataSource replaceObjectAtIndex:last_indexPath.row withObject:last_senceTemplateModel];
        
        
        //3.
        //        [self.senceColle\ctioneEditView reloadItemsAtIndexPaths:@[last_indexPath]];
    }
    //1.得到当前senceTemplateModel
    
    self.currentIndexPath =visibleIndexPath;
    IS_SenceTemplateModel * senceTemplateModel = self.senceDataSource[self.currentIndexPath.row];
    senceTemplateModel.s_selected_tag=-1;
    senceTemplateModel.templateState=IS_SenceTemplateStateInsert; //都是重新开始插入
    if (senceTemplateModel.s_img_array.count==0) {
        senceTemplateModel.s_template_style=last_senceTemplateModel.s_template_style;
        senceTemplateModel.s_sub_template_style =last_senceTemplateModel.s_sub_template_style+1;
    }
    if (last_senceTemplateModel.s_sub_template_style>6) {
        senceTemplateModel.s_template_style=1;
        senceTemplateModel.s_sub_template_style =6;
    }
    
    
    [self.senceDataSource replaceObjectAtIndex:self.currentIndexPath.row withObject:senceTemplateModel];
    //    [self.senceCollectioneEditView reloadItemsAtIndexPaths:@[self.currentIndexPath]];
    
    [self.senceCollectioneEditView reloadData];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN object:senceTemplateModel userInfo:@{TEMPLATE_STATE:TEMPLATE_NEXT_PAGE}];
    
    
    
    //    self.currentSenceTemplateModel = self.senceTemplateArray [visibleIndexPath.row];
    //    IS_SenceEditCell *cell = [is_se]
    
    
    
    
    
}




#pragma mark - 数据的增删改查
-(void)addItem{
   
    //0.把最后一条拿出来
    
    NSInteger  last_row = self.senceDataSource.count-1;
    IS_SenceTemplateModel * last_model = self.senceDataSource[last_row];
    
    
    IS_SenceTemplateModel  * new_senceModel = [[IS_SenceTemplateModel alloc]init];
    new_senceModel.s_template_style=last_model.s_template_style;
    new_senceModel.s_sub_template_style=3;
    [self.senceDataSource addObject:new_senceModel];
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:[self.senceDataSource count]-1 inSection:0];
    self.currentIndexPath = newIndexPath;
    [self insertItemsAtIndexPaths:@[newIndexPath]];
    [self scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [_right_refresh performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:.2];
    
    
}

@end
