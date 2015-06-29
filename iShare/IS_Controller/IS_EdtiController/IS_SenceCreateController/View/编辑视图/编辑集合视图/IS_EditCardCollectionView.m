
#import "IS_EditCardCollectionView.h"
#import "IS_EditTemplateModel.h"
#import "IS_EditCardCell.h"


//刷新控件
#import "AAPullToRefresh.h"
#import "IS_SenceEditTool.h"
#import "MutilThreadTool.h"
#import "IS_EditAssetPickerView.h"
#import "LXActionSheet.h"
#import "IS_SceneCollectionController.h"
#import "IS_EditChoosePageController.h"
#import "KVNProgress.h"

#define WEAKSELF __weak typeof(self) weakSelf = self


@interface IS_EditCardCollectionView()<IS_EditCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
//1.布局
@property (nonatomic,strong)AAPullToRefresh * right_refresh;
/**
 *  当前模板
 */
@property (nonatomic,strong)IS_EditAssetPickerView * imageAssetPickerView;

/**
 *  当前插入图片的数量
 */
@property (nonatomic,assign)NSInteger curTotalImageNum;

/**
 *  子视图 tag
 */
@property (nonatomic,assign)NSInteger curSubtag;

@end

@implementation IS_EditCardCollectionView
#pragma mark - 视图初始化
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setup];

    }
    return self;
}
-(void)awakeFromNib{

    [super awakeFromNib];
    [self setup];
}
#pragma mark - 初始化
-(void)setup{

    [self setupData];
    
    [self setupCollectionView];
    
    [self setupNotification];
}
#pragma mark - 构建数据
-(void)setupData{
    
    //0.设置子视图 tag
    
    _curSubtag = -1;
    
}
#pragma mark - 构建 UICollectionView
-(void)setupCollectionView{

    //0.构建视图

//    self.decelerationRate=UIScrollViewDecelerationRateFast;
    self.backgroundColor =kColor(244, 244, 244);//[UIColor redColor];// kColor(240, 240, 240);
    self.showsHorizontalScrollIndicator=NO;
    self.showsVerticalScrollIndicator=NO;
    //1.代理
    self.dataSource =self;
    self.delegate =self;
    self.pagingEnabled = YES;
    
    //2.初始化缓冲池处理
   [self registerClass:[IS_EditCardCell class] forCellWithReuseIdentifier:IS_EditCardCell_ID];
    
  
  
//    //5.动作
//#pragma mark - 向右刷新
    WEAKSELF;
    _right_refresh =  [self addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf addCurrentItem:IS_AddTypeTypeByDrag];
        });
    }];
    _right_refresh.imageIcon = [UIImage imageNamed:@"launchpad"];
    _right_refresh.borderColor = [UIColor whiteColor];
    

}
#pragma mark - 构建通知
- (void)setupNotification{
    //1.响应手势响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bigImageGestureToCollectionView:) name:BIG_IMAGE_GESTURE_COLLECTION_VIEW object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imgUploadNotification:) name:IS_UPLOAD_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imgDidSelectNotification:) name:IS_EDIT_IMAGE_DID_SELECT object:nil];

    
}
#pragma mark - 图片点击
- (void)imgDidSelectNotification:(NSNotification*)notification{
    
    
    if (notification.object) {
        
        IS_EditImageView * imgView = notification.object;
            _curSubtag = imgView.subTemplateModel.sub_tag;
            [_collection_delegate IS_CardCollectionViewDidEndOperation:notification.object ActionType:IS_ContentImageActionTypeDidSelect];
        
        


    }
}
#pragma mark - 图片上传通知
- (void)imgUploadNotification:(NSNotification*)notification{
    
    
    [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
        if ([notification.object isKindOfClass:[IS_ImageModel class]]) {
            
            IS_ImageModel *imgModel = notification.object;
            
            [self.senceDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                IS_EditTemplateModel * tObj = obj;
                [tObj.subview_array enumerateObjectsUsingBlock:^(id sub_obj, NSUInteger sub_idx, BOOL *sub_stop) {
                    IS_EditSubTemplateModel * subObj = sub_obj;
                    if ([subObj.imageModel.img_id isEqualToString:imgModel.img_id]&&subObj.imageModel.img_upload_state==IS_ImageUploadStateDone) {
                        
                        [tObj.subview_array replaceObjectAtIndex:sub_idx withObject:subObj];
                        [self.senceDataSource replaceObjectAtIndex:idx withObject:tObj];
                    
                         *sub_stop=YES;
                        *stop=YES;
                    
                    }

                }];
                
            }];
            
        }
       
    }];
    
}




#pragma mark - 默认

-(void)addDefaultWithSenceName:(NSString*)sceneName{
    
  
    IS_EditTemplateModel  * senceModelA = [[IS_EditTemplateModel alloc]init];
    senceModelA.row_num=0;
    senceModelA.isScene=YES;
    senceModelA.a_id = sceneName;

    self.senceDataSource = [NSMutableArray arrayWithObject:senceModelA];
    
    IS_EditTemplateModel  * senceModelB = [[IS_EditTemplateModel alloc]init];
    senceModelB.row_num=1;
    senceModelB.a_id = @"p2_b";
    [self.senceDataSource  addObject:senceModelB];
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self reloadData];
//    [self scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}
#pragma mark --------------- 响应外部方法----------------------

#pragma mark - 响应模板点击->保存图片->换模板
- (void)collectionToChangeTemplate:(id)template_obj{
    
    if (!template_obj) {
        return;
    }
    
    //0.把当前的模板模型拿下来
    IS_EditTemplateModel * cur_SenceTemplateModel = self.senceDataSource[self.currentIndexPath.row];
     IS_EditTemplateModel * from = (IS_EditTemplateModel *)template_obj;
    IS_EditTemplateModel * curModel=[[IS_EditTemplateModel alloc]init];
    curModel.row_num =cur_SenceTemplateModel.row_num;
    curModel.a_id = from.a_id;
    curModel.isScene = from.isScene;

   
    
    
    __block  NSInteger leftNum = 0;
    if (cur_SenceTemplateModel.img_array.count>0) {
        [curModel.subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_EditSubTemplateModel * sub_model = (IS_EditSubTemplateModel*)obj;
            if (sub_model.sub_type == IS_SubTypeImage) {
                if (cur_SenceTemplateModel.img_array.count>leftNum) {
                    
                    sub_model.imageModel.img = cur_SenceTemplateModel.img_array[leftNum];
                    leftNum++;
                    [curModel.subview_array replaceObjectAtIndex:idx withObject:sub_model];
                }
            }
            
            
        }];
    }
   

    
    //2.定型

    NSInteger row = self.currentIndexPath.row;
    [self.senceDataSource replaceObjectAtIndex:row withObject:curModel];
    [self reloadItemsAtIndexPaths:@[self.currentIndexPath]];
}
#pragma mark - 批量增加图片
//   assets-library://asset/asset.JPG?id=7A494467-58CB-450E-9652-55B46FA456FA&ext=JPG
- (void)insertAssetIntoEditView:(NSMutableArray*)image_array
              WithAssetURLArray:(NSMutableArray*)assetUrlArray{
    
//    IS_SenceTemplateModel * senceTemplateModel = self.senceDataSource[self.currentIndexPath.row];
       //1.
    __block NSInteger last_idx = 0;
    __block NSInteger left_num = 0;
    __block NSInteger cur_location =self.currentIndexPath.row;
    __block NSInteger cur_length = self.senceDataSource.count -cur_location;
    NSArray * cur_arraym = [self.senceDataSource subarrayWithRange:NSMakeRange(cur_location, cur_length)];
    
    
    
     //1.把空缺的补上
    for (ALAsset * asset in image_array) {
        
        UIImage *i = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];

//        UIImage * i = [asset ]
        [cur_arraym enumerateObjectsUsingBlock:^(id t, NSUInteger t_idx, BOOL *t_stop) {
            IS_EditTemplateModel * templateModel = t;
            NSArray * sub_view_array =templateModel.subview_array;
            [sub_view_array enumerateObjectsUsingBlock:^(id sub_obj, NSUInteger s_idx, BOOL *s_stop) {
                
                IS_EditSubTemplateModel * sub_templateModel =sub_obj;
                
                if (sub_templateModel.sub_type== IS_SubTypeImage&&!sub_templateModel.imageModel.img) {
                    if (t_idx==0&&s_idx<_curSubtag) {
                        //
                    }else{
                        sub_templateModel.imageModel.img = i;
                        left_num++;
                        [templateModel.subview_array replaceObjectAtIndex:s_idx withObject:sub_templateModel];
                        [self.senceDataSource replaceObjectAtIndex:t_idx+cur_location withObject:templateModel];
                        last_idx = t_idx+cur_location;
                        *s_stop =YES;
                        *t_stop=YES;
                    }
                   
                  
                    
                  
                }
                
            }];
        }];
    }

#pragma mark - 用剩的处理
   // NSLog(@"用了几张:%d",left_num);

    if(image_array.count - left_num<=0){
        self.currentIndexPath= [NSIndexPath indexPathForRow:last_idx inSection:0];
        [self scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    }else{
        //2.把剩下的新增
        NSInteger location = (left_num==0)?0:(left_num);
        NSInteger length = image_array.count - left_num;
        NSArray * left_array = [image_array subarrayWithRange:NSMakeRange(location, length)];
        
        int sub =(arc4random() % 6)+ 1;
        NSMutableArray * arrayM = [self makeIndex:1 SubIndex:sub totalArray:left_array];
        
        [self dealLetf:arrayM lastSenceTemplateModel:[self.senceDataSource lastObject]];
        self.currentIndexPath = [NSIndexPath indexPathForRow:self.senceDataSource.count-1 inSection:0];
        
        

    }
    
    [self reloadData];
    [self scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _curSubtag=-1;



   


   
}

-(void)dealLetf:(NSMutableArray *)deal_image_array
            lastSenceTemplateModel:(IS_EditTemplateModel*)senceTemplateModel{
    
    [deal_image_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
//        if (idx==0) {
//            return;
//        }
        
        NSArray * arrayM1 = obj;
        IS_EditTemplateModel * newModel = [[IS_EditTemplateModel alloc]init];
        newModel.row_num = self.senceDataSource.count;
        NSInteger type = 1;
        NSInteger subType =1;
        if (arrayM1.count>=6) {
           type=1;
        }else if (arrayM1.count>=5){
           type = (arc4random() % 2)+ 1;
        }else{
           type = (arc4random() % 3)+ 1;

        }
        subType =arrayM1.count;
        
        NSString * a_id = [NSString stringWithFormat:@"p%d_%c",(int)subType,[IS_SenceEditTool numberToAlpha:type]];
        newModel.a_id = a_id;

        [arrayM1 enumerateObjectsUsingBlock:^(ALAsset * image_asset, NSUInteger image_idx, BOOL *stop) {
            //1.填满了当前视图
            [newModel.subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *sub_stop) {
                
                IS_EditSubTemplateModel * sub_model = obj;
                
                if (sub_model.sub_type==IS_SubTypeImage&&!sub_model.imageModel.img) {
                    //                        sub_model.img=image;
                    //                    sub_model.img_url=image_asset;//assetUrlArray[image_idx];
                    UIImage *image = [UIImage imageWithCGImage:image_asset.defaultRepresentation.fullScreenImage];

                    sub_model.imageModel.img = image;//[IS_SenceEditTool getImagesDataFromAssetURLString:image_asset];
//                    sub_model.page=t_idx+cur_location;
                    [newModel.subview_array replaceObjectAtIndex:idx withObject:sub_model];
                
                    *sub_stop=YES;
                }
            }];
            
            
            
        }];
        
        [self.senceDataSource addObject:newModel];

        
//        if (idx+1 ==deal_image_array.count) {
//            self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+idx inSection:0];
//        }
        
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
        
        int y = arc4random() % 5+ 1;
        subIndex +=y;
        

        
    }

    return arrayForArrayM;
    
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
    
    
   IS_EditCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_EditCardCell_ID
                                                                       forIndexPath:indexPath];
    
    IS_EditTemplateModel * senceTemplateModel =self.senceDataSource[indexPath.row];
    
    senceTemplateModel.senceTemplateShape = IS_SenceTemplateShapeCard;
    cell.senceTemplateModel = senceTemplateModel;
   cell.delegate = self;
    return cell;
}
#pragma mark - 每次滑动后得到当前编辑视图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
        CGRect visibleRect = (CGRect){.origin = self.contentOffset, .size = self.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
        NSIndexPath *visibleIndexPath = [self indexPathForItemAtPoint:visiblePoint];
        self.currentIndexPath =visibleIndexPath;
    
    
    NSInteger curRow = self.currentIndexPath.row;
    [self.collection_delegate IS_CardCollectionViewDidEndDecelerating:@(curRow) userinfo:nil];
 
}
#pragma mark - 数据的增删改查


#pragma mark - 数据的增删改查
-(void)addCurrentItem:(IS_AddType)addType{
    
    IS_EditTemplateModel * newModel = [[IS_EditTemplateModel alloc]init];

    if (addType==IS_AddTypeTypeAuto) {
        NSInteger arrayM1 = arc4random() % 6+ 1;
        newModel.row_num = self.senceDataSource.count;
        //
        NSInteger type = 1;
        NSInteger subType =1;
        if (arrayM1>=6) {
            type=1;
        }else if (arrayM1>=5){
            type = (arc4random() % 2)+ 1;
        }else{
            type = (arc4random() % 3)+ 1;
            
        }
        subType =arrayM1;
        
        NSString * a_id = [NSString stringWithFormat:@"p%d_%c",(int)subType,[IS_SenceEditTool numberToAlpha:type]];
        newModel.a_id = a_id;
    }else if(addType!=IS_AddTypeTypeAuto){
        newModel.a_id = nil;
    }
    

    
    
    
    [self.senceDataSource addObject:newModel];
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:[self.senceDataSource count]-1 inSection:0];
    self.currentIndexPath = [NSIndexPath indexPathForRow:[self.senceDataSource count]-1 inSection:0];
    [self insertItemsAtIndexPaths:@[newIndexPath]];
    [self scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    NSInteger curRow = self.currentIndexPath.row;
    if (addType==IS_AddTypeTypeByDrag) {
        self.currentIndexPath =  [NSIndexPath indexPathForRow:self.currentIndexPath.row+1 inSection:self.currentIndexPath.section];
    }else{

    }

    [self.collection_delegate IS_CardCollectionViewDidEndDecelerating:@(curRow) userinfo:@{@"action":@"additem"}];
    [self.collection_delegate IS_CardCollectionViewDidEndOperation:self ActionType:IS_ContentImageActionTypeAdd];
    
    [_right_refresh performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:0.5];
    

}


-(void)deleteCurrentItem{
    if (self.senceDataSource.count<1) {
        return;
    }
    
    [self performBatchUpdates:^{
        
            NSInteger curRow = self.currentIndexPath.row;
            NSInteger newRow = curRow;
            if (curRow+1==self.senceDataSource.count) {
                newRow = curRow-1;
            }
            [self.senceDataSource removeObjectAtIndex:curRow];
            [self deleteItemsAtIndexPaths:@[self.currentIndexPath]];
            self.currentIndexPath = [NSIndexPath indexPathForItem:newRow inSection:0];
        
        
       
        
    } completion:^(BOOL finished) {
        [self reloadData];
        [self.collection_delegate IS_CardCollectionViewDidEndOperation:self ActionType:IS_ContentImageActionTypeDel];

        
    }];
    
    
}

#pragma mark  - 跳转到模板选择界面
- (void)jumpToTemplateSheetAction:(id)sender {
    
    
}

#pragma mark -IS_CellEditViewDelegate


#pragma mark - Cell视图交换后数据整理
-(void)IS_EditCellDidSelectItemAction:(id)result userinfo:(id)userinfo{
    
    
   
    
 
}
-(void)IS_EditCellDidDataChangeAction:(id)result userinfo:(id)userinfo{
    
    
    IS_EditTemplateModel * cur_templateModel = result;
    [self.senceDataSource replaceObjectAtIndex:self.currentIndexPath.row withObject:cur_templateModel];
}


@end
