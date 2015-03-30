
#import "IS_EditCardCollectionView.h"
#import "IS_EditTemplateModel.h"
#import "IS_EditCardCell.h"


//刷新控件
#import "AAPullToRefresh.h"
#import "IS_SenceEditTool.h"
#import "MutilThreadTool.h"
#import "IS_EditTemplateSelectModel.h"
#import "IS_EditAssetPickerView.h"
#import "IS_SencePageController.h"

#define WEAKSELF __weak typeof(self) weakSelf = self


@interface IS_EditCardCollectionView()<IS_EditCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
//1.布局
@property (nonatomic,strong)AAPullToRefresh * right_refresh;
/**
 *  当前模板
 */
@property (nonatomic,strong)IS_EditTemplateModel * cur_templateModel;

/**
 *  当前插入图片的数量
 */
@property (nonatomic,assign)NSInteger cur_total_insert_image_num;

/**
 *  子视图 tag
 */
@property (nonatomic,assign)NSInteger cur_sub_tag;

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
    
    _cur_sub_tag = -1;
    
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
//    WEAKSELF;
    _right_refresh =  [self addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self addItem];
        });
    }];
    _right_refresh.imageIcon = [UIImage imageNamed:@"launchpad"];
    _right_refresh.borderColor = [UIColor whiteColor];
    

}
#pragma mark - 构建通知
- (void)setupNotification{
    //1.响应手势响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bigImageGestureToCollectionView:) name:BIG_IMAGE_GESTURE_COLLECTION_VIEW object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(image_upload_action:) name:@"IMAGE_UPLOAD" object:nil];
}
#pragma mark - 图片上传通知
- (void)image_upload_action:(NSNotification*)notification{
    
    if ([notification.object isKindOfClass:[IS_EditSubTemplateModel class]]) {
        IS_EditSubTemplateModel * sub_obj = notification.object;
        if (self.senceDataSource.count<sub_obj.page+1) {
            return;
        }
        IS_EditTemplateModel * t_obj = [self.senceDataSource objectAtIndex:sub_obj.page];
        if (t_obj.subview_array.count<sub_obj.sub_tag+1) {
            return;
        }
        [t_obj.subview_array replaceObjectAtIndex:sub_obj.sub_tag withObject:sub_obj];
        [self.senceDataSource replaceObjectAtIndex:sub_obj.page withObject:t_obj];
        if (sub_obj.page == self.currentIndexPath.row) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:sub_obj.page inSection:0];
            [self reloadItemsAtIndexPaths:@[indexPath]];
        }
     
        
        
    }
}


#pragma mark - 默认

-(void)addDefaultWithSenceType:(NSInteger)SenceType
                  SubSenceType:(NSInteger)SubSenceType
                     ExistData:(NSMutableArray *)arrayM{
    
    if (arrayM.count>0) {
        self.senceDataSource =arrayM;
        
    }else{
        
        IS_EditTemplateModel  * senceModelA = [[IS_EditTemplateModel alloc]init];
        senceModelA.row_num=0;
        senceModelA.is_sence=YES;
        senceModelA.type=SenceType;
        senceModelA.sub_type=SubSenceType;
        senceModelA.sence_Id = SubSenceType;
        self.senceDataSource = [NSMutableArray arrayWithObject:senceModelA];
        
        IS_EditTemplateModel  * senceModelB = [[IS_EditTemplateModel alloc]init];
        senceModelB.row_num=1;
        senceModelB.type=1;
        senceModelB.sub_type=2;
        [self.senceDataSource  addObject:senceModelB];
        
    }
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
     IS_EditTemplateSelectModel * from = (IS_EditTemplateSelectModel *)template_obj;
    IS_EditTemplateModel * be_change_sence=[[IS_EditTemplateModel alloc]init];//self.senceTemplateArray[self.currentIndexPath.row];
    be_change_sence.is_sence = from.isScene;
    be_change_sence.row_num =cur_SenceTemplateModel.row_num;
    be_change_sence.type=from.type;
    be_change_sence.sub_type=from.sub_type;
   
    
    
    __block  NSInteger leftNum = 0;
    if (cur_SenceTemplateModel.img_array.count>0) {
        [be_change_sence.subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_EditSubTemplateModel * sub_model = (IS_EditSubTemplateModel*)obj;
            if (sub_model.sub_type == IS_SubTypeImage) {
                if (cur_SenceTemplateModel.img_array.count>leftNum) {
                    sub_model.img = cur_SenceTemplateModel.img_array[leftNum];
                    leftNum++;
                    [be_change_sence.subview_array replaceObjectAtIndex:idx withObject:sub_model];
                }
            }
            
            
        }];
    }
   

    
    //2.定型

    NSInteger row = self.currentIndexPath.row;
    [self.senceDataSource replaceObjectAtIndex:row withObject:be_change_sence];
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
    for (UIImage * i in image_array) {
        [cur_arraym enumerateObjectsUsingBlock:^(id t, NSUInteger t_idx, BOOL *t_stop) {
            IS_EditTemplateModel * templateModel = t;
            NSArray * sub_view_array =templateModel.subview_array;
            [sub_view_array enumerateObjectsUsingBlock:^(id sub_obj, NSUInteger s_idx, BOOL *s_stop) {
                
                IS_EditSubTemplateModel * sub_templateModel =sub_obj;
                if (sub_templateModel.sub_type== IS_SubTypeImage&&!sub_templateModel.img) {
                    if (t_idx==0&&s_idx<_cur_sub_tag) {
                        //
                    }else{
                        sub_templateModel.img = i;
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
    _cur_sub_tag=-1;



   


   
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
        if (arrayM1.count>=6) {
            newModel.type=1;
        }else if (arrayM1.count>=5){
            newModel.type = (arc4random() % 2)+ 1;
        }else{
            newModel.type = (arc4random() % 3)+ 1;

        }
        newModel.sub_type =arrayM1.count;
        

        [arrayM1 enumerateObjectsUsingBlock:^(id image_asset, NSUInteger image_idx, BOOL *stop) {
            //1.填满了当前视图
            [newModel.subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *sub_stop) {
                
                IS_EditSubTemplateModel * sub_model = obj;
                
                if (sub_model.sub_type==IS_SubTypeImage&&!sub_model.img) {
                    //                        sub_model.img=image;
                    //                    sub_model.img_url=image_asset;//assetUrlArray[image_idx];
                    sub_model.img = image_asset;//[IS_SenceEditTool getImagesDataFromAssetURLString:image_asset];
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
-(void)addItem{
    
    //0.把最后一条拿出来

//
    IS_EditTemplateModel * newModel = [[IS_EditTemplateModel alloc]init];
    NSInteger sub_num = arc4random() % 6+ 1;
    newModel.row_num = self.senceDataSource.count;
//
    if (sub_num>=6) {
        newModel.type=1;
    }else if (sub_num>=5){
        newModel.type = arc4random() % 2+ 1;
    }else{
        newModel.type = arc4random() % 3+ 1;
        
    }
    newModel.sub_type =sub_num;

    
    newModel.type=0;
    newModel.sub_type=0;
    
    [self.senceDataSource addObject:newModel];
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:[self.senceDataSource count]-1 inSection:0];
    self.currentIndexPath = [NSIndexPath indexPathForRow:[self.senceDataSource count]-1 inSection:0];
    [self insertItemsAtIndexPaths:@[newIndexPath]];
    //[self reloadData];
    
        //
//    self.contentOffset= CGPointMake(self.contentOffset.x+130+20, self.contentOffset.y);
    [self scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.currentIndexPath =  [NSIndexPath indexPathForRow:self.currentIndexPath.row+1 inSection:self.currentIndexPath.section];
    
    NSInteger curRow = self.currentIndexPath.row;
    [self.collection_delegate IS_CardCollectionViewDidEndDecelerating:@(curRow) userinfo:@{@"action":@"additem"}];
    
 
    [_right_refresh performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:0.5];
    
    
}
#pragma mark -IS_CellEditViewDelegate


#pragma mark - Cell视图交换后数据整理
-(void)IS_EditCellDidSelectItemAction:(id)result userinfo:(id)userinfo{
    
    _cur_sub_tag = [result sub_tag];
    //2.
    if ([self.collection_delegate respondsToSelector:@selector(IS_CardCollectionViewDidSelectImageViewItem:userinfo:)]) {
        [self.collection_delegate IS_CardCollectionViewDidSelectImageViewItem:result userinfo:userinfo];
    }
}
-(void)IS_EditCellDidDataChangeAction:(id)result userinfo:(id)userinfo{
    
    
    IS_EditTemplateModel * cur_templateModel = result;
    [self.senceDataSource replaceObjectAtIndex:self.currentIndexPath.row withObject:cur_templateModel];
//    [self reloadItemsAtIndexPaths:@[self.currentIndexPath]];
}

-(void)IS_EditCellDidChangeSceneAction:(id)result{
    IS_SencePageController * pvc = [[IS_SencePageController alloc]init];
    CGSize windowSize = self.window.bounds.size;
    
    UIImage * snapshot = [UIImage getImageFromCurView:self];
    snapshot = [snapshot applyBlurWithRadius:40
                                   tintColor:Color(244, 244, 244, 0.7)
                       saturationDeltaFactor:0.8
                                   maskImage:nil];
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];
    backgroundImageView.frame =  CGRectMake(0, 0, windowSize.width, windowSize.height);;
    backgroundImageView.userInteractionEnabled = YES;
    [pvc.view addSubview:backgroundImageView];
    [pvc.view sendSubviewToBack:backgroundImageView];
    [pvc showAnimationAtContainerView:nil selectBlock:^(id result) {
        if (result) {
            
//            IS_SenceTemplateModel * cur_templateModel = result;
            [self collectionToChangeTemplate:result];

        }
    }];
}

@end
