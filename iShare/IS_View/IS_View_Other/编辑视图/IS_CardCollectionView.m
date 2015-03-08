
#import "IS_CardCollectionView.h"
#import "IS_SenceTemplateModel.h"
#import "IS_SenceEditCell.h"


//刷新控件
#import "AAPullToRefresh.h"
#import "IS_SenceEditTool.h"
#import "MutilThreadTool.h"

#define WEAKSELF __weak typeof(self) weakSelf = self


@interface IS_CardCollectionView()<IS_SenceCreateEditViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
//1.布局
@property (nonatomic,strong)AAPullToRefresh * right_refresh;

@property (nonatomic ,strong)UIPinchGestureRecognizer *inner_pinchPressGestureRecognizer;

/**
 *  当前模板
 */
@property (nonatomic,strong)IS_SenceTemplateModel * cur_templateModel;

/**
 *  当前插入图片的数量
 */
@property (nonatomic,assign)NSInteger cur_total_insert_image_num;
@end

@implementation IS_CardCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setupCollectionView];

    }
    return self;
}
-(void)awakeFromNib{

    [super awakeFromNib];
    [self setupCollectionView];
}
-(void)setupCollectionView{

    //0.构建视图

    self.decelerationRate=UIScrollViewDecelerationRateFast;
    self.backgroundColor =kColor(244, 244, 244);//[UIColor redColor];// kColor(240, 240, 240);
    self.showsHorizontalScrollIndicator=NO;
    self.showsVerticalScrollIndicator=NO;
    
    
    
    //1.代理
    self.dataSource =self;
    self.delegate =self;
    
    //2.初始化缓冲池处理
   [self registerClass:[IS_SenceEditCell class] forCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID];
    
  
//   [self addDefaultSenceTemplateData:nil];
  
//    //5.动作
//#pragma mark - 向右刷新
//    WEAKSELF;
    _right_refresh =  [self addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
        [self addItem];
    }];
    _right_refresh.imageIcon = [UIImage imageNamed:@"launchpad"];
    _right_refresh.borderColor = [UIColor whiteColor];
    
    
    [self addNotification];
    
    
    [self addGestureRecognizers];

}
#pragma mark -捏合手势
- (void)addGestureRecognizers{

    //4.内部 Pinch
    _inner_pinchPressGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handleInnerPinchGesture:)];
//    _inner_pinchPressGestureRecognizer.delegate=self;
//    [self addGestureRecognizer:_inner_pinchPressGestureRecognizer];
}
-(void)handleInnerPinchGesture:(UIPinchGestureRecognizer*)pinchGestureRecognizer{

    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.scrollEnabled=NO;
//        self.userInteractionEnabled=NO;
        
    }else if (pinchGestureRecognizer.state==UIGestureRecognizerStateChanged){
       
        if ([self.collection_delegate respondsToSelector:@selector(IS_CardCollectionViewDidEndPinch:)]) {
            [self.collection_delegate IS_CardCollectionViewDidEndPinch:self];
        }
        
    }else{
        self.scrollEnabled=YES;
//        self.userInteractionEnabled=YES;


    }
}
#pragma mark - 默认

-(void)addDefaultSenceTemplateData:(NSMutableArray *)arrayM{
    
    if (arrayM.count>0) {
        self.senceDataSource =arrayM;
        
    }else{
        self.senceDataSource = [IS_SenceEditTool appendSenceDefaultData];
        
    }
//    self.senceDataSource = [IS_SenceEditTool appendSenceDefaultData];

    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self reloadData];
    
}
#pragma mark /--------------- 响应外部方法----------------------

#pragma mark - 响应模板点击->保存图片->换模板
- (void)templateToCollectionView:(id)template_obj{
    
    if (!template_obj) {
        return;
    }
    IS_SenceTemplateModel * from_sence = (IS_SenceTemplateModel *)template_obj;
    if (from_sence.s_sub_template_style==0) {
        return;
    }
    
    IS_SenceTemplateModel * be_change_sence=[[IS_SenceTemplateModel alloc]init];//self.senceTemplateArray[self.currentIndexPath.row];
    be_change_sence.s_template_style=from_sence.s_template_style;
    be_change_sence.s_sub_template_style=from_sence.s_sub_template_style;
//    be_change_sence.img_count =from_sence.img_count;
    //2.定型

    
    [self.senceDataSource replaceObjectAtIndex:self.currentIndexPath.row withObject:be_change_sence];
    [self reloadData];
}
#pragma mark - 批量增加图片




//   assets-library://asset/asset.JPG?id=7A494467-58CB-450E-9652-55B46FA456FA&ext=JPG
- (void)insertAssetIntoEditView:(NSMutableArray*)image_array
              WithAssetURLArray:(NSMutableArray*)assetUrlArray{
    
//    IS_SenceTemplateModel * senceTemplateModel = self.senceDataSource[self.currentIndexPath.row];
       //1.
    __block NSInteger last_idx = 0;
    __block NSInteger left_num = 0;
//    __block NSInteger cur_location =self.currentIndexPath.row;
//    __block  NSInteger cur_length = self.senceDataSource.count -cur_location-1;
//    NSArray * cur_arraym = [self.senceDataSource subarrayWithRange:NSMakeRange(cur_location, cur_length)];
    //1.把空缺的补上
    for (UIImage * i in image_array) {
        [self.senceDataSource enumerateObjectsUsingBlock:^(id t, NSUInteger t_idx, BOOL *t_stop) {
            IS_SenceTemplateModel * templateModel = t;
            
            [templateModel.s_sub_view_array enumerateObjectsUsingBlock:^(id sub_obj, NSUInteger s_idx, BOOL *s_stop) {
                
                IS_SenceSubTemplateModel * sub_templateModel =sub_obj;
                if (sub_templateModel.sub_type== IS_SenceSubTemplateTypeImage&&!sub_templateModel.image_data) {
                    sub_templateModel.image_data = i;
                    left_num++;
                   
                    [templateModel.s_sub_view_array replaceObjectAtIndex:s_idx withObject:sub_templateModel];
                    [self.senceDataSource replaceObjectAtIndex:t_idx withObject:templateModel];
                    last_idx = t_idx;
                  
                    
                    *s_stop =YES;
                    *t_stop=YES;
                }
                
            }];
        }];
    }
    [self reloadData];

   // NSLog(@"用了几张:%d",left_num);
    
    //2.把剩下的新增
    NSInteger location = (left_num==0)?0:(left_num);
    NSInteger length = image_array.count - left_num;
    NSArray * left_array = [image_array subarrayWithRange:NSMakeRange(location, length)];
    
    int sub =(arc4random() % 1) + 6;
    NSMutableArray * arrayM = [self makeIndex:1 SubIndex:sub totalArray:left_array];
    
    [self dealLetf:arrayM lastSenceTemplateModel:[self.senceDataSource lastObject]];
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.senceDataSource.count-1 inSection:0];
    [self scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
   
    [self reloadData];

    
  

   
    
    
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:last_idx inSection:0];
//    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
   


   
}

-(void)dealLetf:(NSMutableArray *)deal_image_array
            lastSenceTemplateModel:(IS_SenceTemplateModel*)senceTemplateModel{
    
    [deal_image_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
//        if (idx==0) {
//            return;
//        }
        
        NSArray * arrayM1 = obj;
        IS_SenceTemplateModel * newModel = [[IS_SenceTemplateModel alloc]init];
        if (arrayM1.count>=6) {
            newModel.s_template_style=1;
        }else if (arrayM1.count>=5){
            newModel.s_template_style = (arc4random() % 1) + 2;
        }else{
            newModel.s_template_style = (arc4random() % 1) + 3;

        }
        newModel.s_sub_template_style =arrayM1.count;
        

        [arrayM1 enumerateObjectsUsingBlock:^(id image_asset, NSUInteger image_idx, BOOL *stop) {
            //1.填满了当前视图
            [newModel.s_sub_view_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *sub_stop) {
                
                IS_SenceSubTemplateModel * sub_model = obj;
                
                if (sub_model.sub_type==IS_SenceSubTemplateTypeImage&&!sub_model.image_data) {
                    //                        sub_model.image_data=image;
                    //                    sub_model.image_url=image_asset;//assetUrlArray[image_idx];
                    sub_model.image_data = image_asset;//[IS_SenceEditTool getImagesDataFromAssetURLString:image_asset];
                    [newModel.s_sub_view_array replaceObjectAtIndex:idx withObject:sub_model];
                    *sub_stop=YES;
                }
            }];
            
            
            
        }];
        
        [self.senceDataSource addObject:newModel];

        
        if (idx+1 ==deal_image_array.count) {
            self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+idx inSection:0];
        }
        
        //
        
        
    }];
}


-(NSMutableArray *)makeIndex:(NSInteger)index
                    SubIndex:(NSInteger)subIndex
                  totalArray:(NSArray*)image_array{
    
    NSMutableArray * arrayForArrayM = [NSMutableArray array];
    NSInteger left_num = image_array.count;
    
    while (left_num>0) {
        //1.第一份
        
        NSInteger location = image_array.count-left_num;
        NSInteger length = subIndex>left_num?left_num:subIndex;
        
        
        NSArray * arrayM1 = [image_array subarrayWithRange:NSMakeRange(location,length)];
        [arrayForArrayM addObject:arrayM1];
        left_num-=subIndex;
        
        int y = (arc4random() % 1) + 5;
        subIndex +=y;
        

        
    }

    return arrayForArrayM;
    
}








#pragma mark - 点击缩略图时候，增加图片到编辑视图
-(void)insertAssetIntoEditViewDidthumbnailImageAction:(id)itemData
                                             userInfo:(NSDictionary*)userInfo{
    IS_SenceTemplateModel * senceTemplateModel = self.senceDataSource[self.currentIndexPath.row];
    
    
    
    if ([itemData isKindOfClass:[UIImage class]]){

        
        
        [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
            [senceTemplateModel.s_sub_view_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                IS_SenceSubTemplateModel * sub_model = obj;
                if (sub_model.sub_type==IS_SenceSubTemplateTypeImage&&!sub_model.image_data) {
                    sub_model.image_data=itemData;
                      sub_model.image_url =userInfo[@"image_url"];
                    [senceTemplateModel.s_sub_view_array replaceObjectAtIndex:idx withObject:sub_model];
                    *stop=YES;
                    
                }
                [self.senceDataSource replaceObjectAtIndex:self.currentIndexPath.row withObject:senceTemplateModel];

            }];
        } MainThreadBlock:^{
            [self reloadItemsAtIndexPaths:@[self.currentIndexPath]];
        }];
        
      
      
    }else if ([itemData isKindOfClass:[IS_SenceSubTemplateModel class]]){
        
     //   NSString * image_url = userInfo[@"image_url"];
       [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
           IS_SenceSubTemplateModel * sub_model = itemData;
           // sub_model.image_url=image_url;
           NSInteger  cur_big_btn_tag =sub_model.sub_tag;
           [senceTemplateModel.s_sub_view_array replaceObjectAtIndex:cur_big_btn_tag withObject:sub_model];
           [self.senceDataSource replaceObjectAtIndex:self.currentIndexPath.row withObject:senceTemplateModel];

       } MainThreadBlock:^{
           [self reloadItemsAtIndexPaths:@[self.currentIndexPath]];

       }];
        
        
        
    }
}


#pragma mark -通知方法

-(void)addNotification{
    
    //1.响应手势响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bigImageGestureToCollectionView:) name:BIG_IMAGE_GESTURE_COLLECTION_VIEW object:nil];
    
}
-(void)deleteNotification{[[NSNotificationCenter defaultCenter]removeObserver:self];}
#pragma mark -响应手势通知方法

-(void)bigImageGestureToCollectionView:(NSNotification*)notification{
    
    BOOL isGesture = [notification.object boolValue];
    self.scrollEnabled =!isGesture;
    
}



#pragma mark - UICollectionView-Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.senceDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    IS_SenceEditCell *cell = [[IS_SenceEditCell alloc]initWithFrame:CGRectMake(0, 0, self.width, 470)];
    
   IS_SenceEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID forIndexPath:indexPath];
    
    IS_SenceTemplateModel * senceTemplateModel =self.senceDataSource[indexPath.row];
    
    senceTemplateModel.senceTemplateShape = IS_SenceTemplateShapeCard;
    cell.senceTemplateModel = senceTemplateModel;
    if (indexPath.row==self.currentIndexPath.row) {
        cell.senceCreateEditView.userInteractionEnabled = YES;
//        cell.senceCreateEditView.alpha=1;
    }else{
        cell.senceCreateEditView.userInteractionEnabled = NO;
//        cell.senceCreateEditView.alpha=0.4;


    }
    cell.senceCreateEditView.delegate =self;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{return YES;}





#pragma mark - 每次滑动后得到当前编辑视图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
        CGRect visibleRect = (CGRect){.origin = self.contentOffset, .size = self.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [self indexPathForItemAtPoint:visiblePoint];
        
        
        //1.得到当前senceTemplateModel
        //    if (self.currentIndexPath.row!=_senceDataSource.count-1) {
        //       self.currentIndexPath =visibleIndexPath;
        //    }
        self.currentIndexPath =visibleIndexPath;
        IS_SenceTemplateModel * senceTemplateModel = self.senceDataSource[self.currentIndexPath.row];
        senceTemplateModel.s_selected_tag=-1;
        if ([self.collection_delegate respondsToSelector:@selector(IS_CardCollectionViewDidEndDecelerating:userinfo:)]) {
            [self.collection_delegate IS_CardCollectionViewDidEndDecelerating:senceTemplateModel userinfo:nil];
        }

        if (visibleIndexPath) {
            [self reloadItemsAtIndexPaths:@[visibleIndexPath]];
            if (visibleIndexPath.row==0||visibleIndexPath.row==self.senceDataSource.count-1) {
                [self scrollToItemAtIndexPath:visibleIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }


        }

    
    
    //2.
    
    
 
}
#pragma mark - 数据的增删改查
-(void)addItem{
    
    //0.把最后一条拿出来
    
    NSInteger  last_row = self.senceDataSource.count-1;
    IS_SenceTemplateModel * last_model = self.senceDataSource[last_row];
    IS_SenceTemplateModel  * new_senceModel = [[IS_SenceTemplateModel alloc]init];
    
    NSInteger last_sub =last_model.s_sub_template_style;
    NSInteger last_index =last_model.s_template_style;

    
    if (last_index==2||last_model.s_sub_template_style>=4) {
        
        if (last_sub==3) {
            new_senceModel.s_template_style=1;
            new_senceModel.s_sub_template_style=1;
        }else{
            new_senceModel.s_template_style=2;
            new_senceModel.s_sub_template_style=(last_sub>=4)?1:last_sub+1;
        }
 
    }else {
        new_senceModel.s_template_style=1;
        new_senceModel.s_sub_template_style=last_model.s_sub_template_style+1;
    }
   
    [self.senceDataSource addObject:new_senceModel];
    
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:[self.senceDataSource count]-1 inSection:0];
    self.currentIndexPath = [NSIndexPath indexPathForRow:[self.senceDataSource count]-1 inSection:0];
    [self insertItemsAtIndexPaths:@[newIndexPath]];
    //[self reloadData];
    self.contentOffset= CGPointMake(self.contentOffset.x+130+20, self.contentOffset.y);
  [self scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    //    [self scrollViewDidEndDecelerating:self];
//    if ([self.collection_delegate respondsToSelector:@selector(IS_CardCollectionViewDidEndDecelerating:userinfo:)]) {
//        [self.collection_delegate IS_CardCollectionViewDidEndDecelerating:new_senceModel userinfo:@{@"info":@"add"}];
//    }
    //    [self.senceDataSource replaceObjectAtIndex:self.currentIndexPath.row withObject:new_senceModel];
    
    
    [_right_refresh performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:0.5];
    
    
}

-(void)IS_SenceCreateEditViewDidEndPanItem:(id)itemData userinfo:(NSDictionary *)userinfo{
    
    if (!itemData) {
        return;
    }
    IS_SenceTemplateModel * cur_templateModel = itemData;
    [self.senceDataSource replaceObjectAtIndex:self.currentIndexPath.row withObject:cur_templateModel];
//    [self reloadItemsAtIndexPaths:@[self.currentIndexPath]];
}

#pragma mark -IS_SenceCreateEditViewDelegate
-(void)IS_SenceCreateEditViewDidSelectItem:(id)itemData userinfo:(NSDictionary *)userinfo{
    //1.代理
    if (!itemData) {
        return;
    }
    //2.
    if ([self.collection_delegate respondsToSelector:@selector(IS_CardCollectionViewDidSelectImageViewItem:userinfo:)]) {
        [self.collection_delegate IS_CardCollectionViewDidSelectImageViewItem:itemData userinfo:userinfo];
    }
}


@end
