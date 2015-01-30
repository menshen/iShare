#import "IS_SenceCreateView.h"
#import "IS_SenceEditCell.h"

#import "AAPullToRefresh.h"
#define WEAKSELF __weak typeof(self) weakSelf = self


@interface IS_SenceCreateView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)AAPullToRefresh * right_refresh;

@end
@implementation IS_SenceCreateView
#pragma mark -初始化

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
       
        
       
        
        //1.添加子视图
        [self addSubViews];
        
        
        //0.数据
        [self addDefaultData];
        
        //2.
        [self addNotification];
        
        
    }
    return self;
}
-(void)dealloc{[self deleteNotification];}

-(NSMutableArray *)senceTemplateArray{
    
    if (!_senceTemplateArray) {
        _senceTemplateArray = [NSMutableArray array];
    }
    return _senceTemplateArray;

}



#pragma mark -通知方法

-(void)addNotification{
    
    //1.响应手势响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bigImageGestureToCollectionView:) name:BIG_IMAGE_GESTURE_COLLECTION_VIEW object:nil];
    //2.响应模板点击改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(templateToCollectionView:) name:TEMPLATE_TO_COLLECTION_VIEW_BY_TAP object:nil];
    //3.响应图片改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bigImageToCollectionView:) name:BIG_IMAGE_TO_COLLECTION_VIEW object:nil];
    //4.响应点击缩略图
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(thumbnailImageToCollectionView:) name:THUMBNAIL_IMAGE_TO_COLLECTION_VIEW object:nil];
}
-(void)deleteNotification{[[NSNotificationCenter defaultCenter]removeObserver:self];}
#pragma mark -响应手势通知方法

-(void)bigImageGestureToCollectionView:(NSNotification*)notification{
    
    BOOL isGesture = [notification.object boolValue];
    self.senceCollectioneEditView.scrollEnabled =!isGesture;

}
#pragma mark - 响应模板点击->保存图片->换模板
- (void)templateToCollectionView:(NSNotification*)notification{
    
    if ([notification.userInfo[IS_NOTIFICATION_OPTION] isEqualToString:TEMPLATE_TO_COLLECTION_VIEW_BY_TAP]) {
        
        IS_SenceTemplateModel * from_sence = (IS_SenceTemplateModel *)notification.object;
        
        
        IS_SenceTemplateModel * be_change_sence=[[IS_SenceTemplateModel alloc]init];//self.senceTemplateArray[self.currentIndexPath.row];
        be_change_sence.s_template_style=from_sence.s_template_style;
        be_change_sence.s_sub_template_style=from_sence.s_sub_template_style;
        //2.定型
        [self.senceTemplateArray replaceObjectAtIndex:self.currentIndexPath.row withObject:be_change_sence];
        [self.senceCollectioneEditView reloadItemsAtIndexPaths:@[self.currentIndexPath]];
    }
   

    
}
#pragma mark - 响应大图点击->改变模型选择项>>>刷新以把当前大图选中
-(void)bigImageToCollectionView:(NSNotification*)notification{
    
   
    
    if ([notification.object isKindOfClass:[IS_SenceSubTemplateModel class]]) {
        
        IS_SenceSubTemplateModel * cur_templateSubModel=notification.object;
        IS_SenceTemplateModel * cur_templateModel = self.senceTemplateArray[self.currentIndexPath.row];
        [cur_templateModel.s_sub_view_array replaceObjectAtIndex:cur_templateSubModel.sub_tag withObject:cur_templateSubModel];
        [self.senceTemplateArray replaceObjectAtIndex:self.currentIndexPath.row withObject:cur_templateModel];
        [self.senceCollectioneEditView reloadItemsAtIndexPaths:@[self.currentIndexPath]];
        
        
    }
    
   

}
#pragma mark - 响应缩略图通知

-(void)thumbnailImageToCollectionView:(NSNotification*)notification{
    
    IS_SenceTemplateModel * senceTemplateModel = self.senceTemplateArray[self.currentIndexPath.row];

    if (!notification.object) {
        return;
    }else if ([notification.object isKindOfClass:[UIImage class]]){
    
        UIImage * selectImage=notification.object;
        [senceTemplateModel.s_sub_view_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            IS_SenceSubTemplateModel * sub_model = obj;
            if (sub_model.sub_type==IS_SenceSubTemplateTypeImage&&!sub_model.image_data) {
                sub_model.image_data=selectImage;
                [senceTemplateModel.s_sub_view_array replaceObjectAtIndex:idx withObject:sub_model];
                *stop=YES;
                
            }
        }];
        [self.senceTemplateArray replaceObjectAtIndex:self.currentIndexPath.row withObject:senceTemplateModel];
        [self.senceCollectioneEditView reloadItemsAtIndexPaths:@[self.currentIndexPath]];
    }else if ([notification.object isKindOfClass:[IS_SenceSubTemplateModel class]]){
    
        IS_SenceSubTemplateModel * sub_model = notification.object;
        NSInteger  cur_big_btn_tag =sub_model.sub_tag;
        [senceTemplateModel.s_sub_view_array replaceObjectAtIndex:cur_big_btn_tag withObject:sub_model];
        [self.senceTemplateArray replaceObjectAtIndex:self.currentIndexPath.row withObject:senceTemplateModel];
        [self.senceCollectioneEditView reloadItemsAtIndexPaths:@[self.currentIndexPath]];


    
    }
    
    
    

    
    
    
}

#pragma mark - Init_Data
-(void)addDefaultData{

    
    self.senceTemplateArray = [IS_SenceEditTool appendSenceDefaultData];
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.senceCollectioneEditView reloadData];
    
}

#pragma mark -SubViews

-(void)addSubViews{
    
    
   
    
    
    //1.添加卡片式视图
    [self addSubview:self.senceCollectioneEditView];
    
  
    //2.初始化缓冲池处理
    [self.senceCollectioneEditView registerClass:[IS_SenceEditCell class] forCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID];

    
    


}


//
//#pragma mark - senceCollectioneEditView
//

#pragma mark - CollectionView-Layout



-(UICollectionView *)senceCollectioneEditView{

    if (!_senceCollectioneEditView) {
        
        
        EBCardCollectionViewLayout* _cardCollectionViewLayout = [[EBCardCollectionViewLayout alloc]init];
        _senceCollectioneEditView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_cardCollectionViewLayout];
        
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
        WEAKSELF;
        _right_refresh =  [_senceCollectioneEditView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
            NSLog(@"fire from right");
            [weakSelf performSelector:@selector(doneSomeThing) withObject:nil afterDelay:0.2];
            
            
        }];
        _right_refresh.imageIcon = [UIImage imageNamed:@"launchpad"];
        _right_refresh.borderColor = [UIColor whiteColor];
        

        
    }
    
    
    return _senceCollectioneEditView;
}
-(void)doneSomeThing{
    
//    [self addLastButtonPressed:nil];
    IS_SenceTemplateModel  * new_senceModel = [[IS_SenceTemplateModel alloc]init];
    new_senceModel.s_template_style=1;
    new_senceModel.s_sub_template_style=3;
    [self.senceTemplateArray addObject:new_senceModel];
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:[self.senceTemplateArray count]-1 inSection:0];
    self.currentIndexPath = newIndexPath;
    [_senceCollectioneEditView insertItemsAtIndexPaths:@[newIndexPath]];
    [_senceCollectioneEditView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
      [[NSNotificationCenter defaultCenter]postNotificationName:COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN object:new_senceModel userInfo:@{IS_NOTIFICATION_OPTION:COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN}];
    [_right_refresh performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:.2];
    //
    
}
//
#pragma mark - UICollectionView-Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.senceTemplateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IS_SenceEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID forIndexPath:indexPath];
    cell.senceTemplateModel = self.senceTemplateArray[indexPath.row];
    
    return cell;
}


#pragma mark - 每次滑动后得到当前编辑视图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = _senceCollectioneEditView.contentOffset, .size = _senceCollectioneEditView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [_senceCollectioneEditView indexPathForItemAtPoint:visiblePoint];
    
    
   
    
    //0.上一个senceTemplateModel
    IS_SenceTemplateModel * last_senceTemplateModel=nil;
    if (visibleIndexPath.row>0) {
        NSIndexPath * last_indexPath =[NSIndexPath indexPathForRow:visibleIndexPath.row-1 inSection:0];
        last_senceTemplateModel=self.senceTemplateArray[last_indexPath.row];
        last_senceTemplateModel.s_selected_tag=-1;
        last_senceTemplateModel.templateState=IS_SenceTemplateStateInsert; //都是重新开始插入
        [self.senceTemplateArray replaceObjectAtIndex:last_indexPath.row withObject:last_senceTemplateModel];

        
        //3.
    }
    //1.得到当前senceTemplateModel
    
    self.currentIndexPath =visibleIndexPath;
    IS_SenceTemplateModel * senceTemplateModel = self.senceTemplateArray[self.currentIndexPath.row];
    senceTemplateModel.s_selected_tag=-1;
    senceTemplateModel.templateState=IS_SenceTemplateStateInsert; //都是重新开始插入
    if (senceTemplateModel.s_sub_view_array.count==0) {
        senceTemplateModel.s_template_style=last_senceTemplateModel.s_template_style;
        senceTemplateModel.s_sub_template_style =last_senceTemplateModel.s_sub_template_style+1;
    }
    if (last_senceTemplateModel.s_sub_template_style>6) {
        senceTemplateModel.s_template_style=1;
        senceTemplateModel.s_sub_template_style =6;
    }
    
    
    [self.senceTemplateArray replaceObjectAtIndex:self.currentIndexPath.row withObject:senceTemplateModel];
    [self.senceCollectioneEditView reloadData];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN object:senceTemplateModel userInfo:@{IS_NOTIFICATION_OPTION:COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN}];
    

    
    
    
   
    
}

@end
