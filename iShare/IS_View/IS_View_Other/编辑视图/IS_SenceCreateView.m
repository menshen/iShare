#import "IS_SenceCreateView.h"
#import "IS_SenceEditCell.h"




#import "UIScrollView+Extension.h"
#import "Masonry.h"
#import "POP.h"


#define IS_SENCE_EDIT_CELL_ID @"IS_SenceEditCell_ID"
@interface IS_SenceCreateView()<UICollectionViewDataSource,UICollectionViewDelegate>
@end
@implementation IS_SenceCreateView
#pragma mark -初始化

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
       
        
        //0.数据
        [self addDefaultData];
        
        //1.添加子视图
        [self addSubViews];
        
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
#pragma mark -增加手势

-(void)addNotification{
    
    //1.手势响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleGestureChange:) name:IS_SenceCreateImageViewGestureNotification object:nil];

    //2.模板改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleTemplateChange:) name:IS_SenceCreateViewDidChangeTemplate object:nil];
    //3.图片改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleImageChange:) name:IS_SenceCreateViewDidChangeImage object:nil];
}
-(void)deleteNotification{
 
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IS_SenceCreateImageViewGestureNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:IS_SenceCreateViewDidChangeTemplate object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IS_SenceCreateViewDidChangeImage object:nil];

}
#pragma mark -响应通知方法

-(void)handleGestureChange:(NSNotification*)notification{
    
    BOOL isGesture = [notification.object boolValue];
    
    self.senceCollectioneEditView.scrollEnabled =!isGesture;

}

- (void)handleTemplateChange:(NSNotification*)notification{
    
    IS_SenceTemplateModel * senceTemplateModel =(IS_SenceTemplateModel *)notification.object;
    //2.定型
    [self.senceTemplateArray replaceObjectAtIndex:self.currentIndexPath.row withObject:senceTemplateModel];
    [self.senceCollectioneEditView reloadItemsAtIndexPaths:@[self.currentIndexPath]];

    
}
-(void)handleImageChange:(NSNotification*)notification{
    
    NSDictionary * user_info = notification.userInfo;
    UIButton * button =notification.object;
    UIImage * image=nil;
    if ([user_info[@"type"] isEqualToValue:@(0)]) {
        //0.点击大图
        image= button.currentImage;
    }else{
        //1.点击图片选择器
        image=  button.currentBackgroundImage;
        IS_SenceTemplateModel * senceTemplateModel = self.senceTemplateArray[self.currentIndexPath.row];
        [senceTemplateModel.s_img_array addObject:image];
        //2.定型
        [self.senceTemplateArray replaceObjectAtIndex:self.currentIndexPath.row withObject:senceTemplateModel];
        [self.senceCollectioneEditView reloadItemsAtIndexPaths:@[self.currentIndexPath]];

        
      }
    
    
    
   
//    IS_SenceEditCell * editCell = ( IS_SenceEditCell * )[self collectionView:self.senceCollectioneEditView cellForItemAtIndexPath:self.currentIndexPath];
//    IS_SenceCreateEditView * editView =editCell.senceCreateEditView;
//    editView.senceTemplateModel=senceTemplateModel;
//    [editView resetImageViews];

    
    
}

#pragma mark - Init_Data
-(void)addDefaultData{

    
    for (int i = 0; i<7; i++) {
        IS_SenceTemplateModel  * senceModel = [[IS_SenceTemplateModel alloc]init];
        if (i<4) {
            
            senceModel.s_isCurrent = (i==0)?YES:NO;
            senceModel.s_template_stype=1;
            senceModel.s_sub_template_stype=i+3;
            
        }else{
            senceModel.s_template_stype=0;
            senceModel.s_sub_template_stype=0;
        }
        [self.senceTemplateArray addObject:senceModel];
    
        
    }
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
}

#pragma mark -SubViews

-(void)addSubViews{
    
    
   
    
    
    //1.添加卡片式视图
    [self addSubview:self.senceCollectioneEditView];
    
  
    //2.初始化缓冲池处理
    [self.senceCollectioneEditView registerClass:[IS_SenceEditCell class] forCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID];

    
    
    if (self.senceTemplateArray) {
        self.currentSenceTemplateModel = self.senceTemplateArray.firstObject;
    }

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
        UIOffset anOffset = UIOffsetMake(40, 10);
        [(EBCardCollectionViewLayout *)_senceCollectioneEditView.collectionViewLayout setOffset:anOffset];
        

        
    }
    
    
    return _senceCollectioneEditView;
}
//
#pragma mark - UICollectionView-Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.senceTemplateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IS_SenceEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_SENCE_EDIT_CELL_ID forIndexPath:indexPath];
    
//    NSLog(@"senceTemplate:%@",cell);
    

    cell.senceTemplateModel = self.senceTemplateArray[indexPath.row];
//    [UIView animateWithDuration:0.1 animations:^{
//        cell.senceCreateEditView.alpha=[self.currentIndexPath isEqual:indexPath]?1:0.7;
//
//    }];

    

    return cell;
}




#pragma mark - 每次滑动后得到当前编辑视图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = _senceCollectioneEditView.contentOffset, .size = _senceCollectioneEditView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [_senceCollectioneEditView indexPathForItemAtPoint:visiblePoint];
    
   NSLog(@"%d",(int)visibleIndexPath.row);
    
    //1
    self.currentIndexPath =visibleIndexPath;
    self.currentSenceTemplateModel = self.senceTemplateArray [visibleIndexPath.row];
    
    
    
   
    
}


///currentSenceEditView
//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        
//        //  [self addSubview:self.senceEditView];
//        
//        //1.布局
//        
//        [self addSubViews];
//        
//    }
//    return self;
//}

//6.单击后
//[self.senceCreateView.senceEditView AddSingleTapAction:^(id result) {
//    IS_SenceCreateImageView * imageView =result;
//    if (imageView.createImageViewType==IS_SenceCreateImageViewTypeImage) {
//        [self showImagePan];
//        
//    }else{
//        NSLog(@"编辑文字");
//    }
//    
//}];
@end
