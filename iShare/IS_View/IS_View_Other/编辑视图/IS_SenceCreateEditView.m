#import "IS_SenceCreateEditView.h"
#import "IS_SenceSubTemplateModel.h"
#import "UIImage+JJ.h"
#import "PhotoPickerTool.h"
#import "CMPopTipView.h"
#import "IS_ImageEditView.h"
#import "IS_PopView.h"
#import "IS_AssetPickerView.h"
#import "IS_TemplateActonSheet.h"
@interface IS_SenceCreateEditView()<IS_SenceCreateImageViewDelegate,CMPopTipViewDelegate,IS_ImageEditOperationViewDelegate>

//拖动时用到的属性，记录最后的选中button的tag
@property (nonatomic,assign)NSInteger be_change_tag;
/**
 *  可视的浮动视图
 */
@property (nonatomic, strong)NSMutableArray	*visiblePopTipViews;

/**
 *  当前被点击的 tag
 */
@property (nonatomic,assign) NSInteger cur_tag;


@property (nonatomic,strong)IS_AssetPickerView *imageAssetPickerView;
@end

@implementation IS_SenceCreateEditView{
    
    UIButton * _sceneChangeBtn;

}
@synthesize be_change_tag;

#pragma mark - *初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}
- (void)setup{

    
}
- (void)setupData{
    
//    _imageArray = [NSMutableArray array];
    
}
- (void)setupSubView{

}
#pragma mark - 根据模板数据来构建

-(void)setSenceTemplateModel:(IS_SenceTemplateModel *)senceTemplateModel{

    _senceTemplateModel  =senceTemplateModel;
    if (senceTemplateModel) {
        
        [self createSenceSubTemplateViewsBySubViewModelArray:senceTemplateModel.subview_array];

    }else{
        
        [self removeSubViewsFromSuperview];
    }
    //2.图片

}
#pragma mark - 利用子视图数据来构建视图
-(void)createSenceSubTemplateViewsBySubViewModelArray:(NSMutableArray*)arrayM{

    
        [self removeSubViewsFromSuperview];
        self.senceCreateImgViewFramesArray=nil;
        self.senceSubModelArray=nil;
        self.senceSubViewArray=nil;
        self.imageArray=nil;
        
        [arrayM enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_SenceSubTemplateModel * senceSubTemplateModel = obj;
            CGRect frame = CGRectFromString(senceSubTemplateModel.sub_frame);
            CGFloat xx= 3;
            if (self.senceTemplateModel.senceTemplateShape==IS_SenceTemplateShapeGird) {
                CGFloat X = frame.origin.x/xx+0.5;
                CGFloat Y = frame.origin.y/xx;
                CGFloat WIDTH =frame.size.width/xx;
                CGFloat HEIGHT =frame.size.height/xx;
                frame  = CGRectMake(X, Y, WIDTH, HEIGHT);
                
                senceSubTemplateModel.shapeType = IS_ShapeTypeSmall;
                
                
            }else{
                
                senceSubTemplateModel.shapeType = IS_ShapeTypeLarge;
                
            }
            
            IS_SenceCreateImageView * senceCreateImageView = [[IS_SenceCreateImageView alloc]initWithFrame:frame];
            [self addSubview:senceCreateImageView];
            
            senceCreateImageView.subTemplateModel =senceSubTemplateModel;
            senceCreateImageView.imageViewDelegate = self;
            //        [senceCreateImageView.imageBtnView addTarget:self action:@selector(imageBtnViewAction:) forControlEvents:UIControlEventTouchUpInside];
            //3.
            [self.senceSubViewArray addObject:senceCreateImageView];
            if (senceSubTemplateModel.img) {
                [self.imageArray addObject:senceSubTemplateModel.img];
                //  [self.imageAssetURLArray addObject:senceSubTemplateModel.img_url];
            }else{
                [self.imageArray addObject:senceSubTemplateModel.img_place_name];
                //  [self.imageAssetURLArray addObject:senceSubTemplateModel.img_place_name];
                
            }
            [self.senceSubModelArray addObject:senceSubTemplateModel];
            [self.senceCreateImgViewFramesArray addObject:senceSubTemplateModel.sub_frame];
            
        }];
        
       
    if (self.senceTemplateModel.is_sence) {
        //
    }else{
        
    }
    


    
   
    
}


#pragma mark -通知
#pragma mark -当选择照片后触发
#pragma mark -数据,记录每个子视图,子视图的Frame,图片信息

#pragma mark -存储当前模板子视图数组
-(NSMutableArray *)senceSubViewArray{

    if (!_senceSubViewArray) {
        _senceSubViewArray = [NSMutableArray array];
        
    }
    return _senceSubViewArray;
}

#pragma mark -存储模板子视图的frame数组
-(NSMutableArray *)senceCreateImgViewFramesArray{
    
    if (!_senceCreateImgViewFramesArray) {
        _senceCreateImgViewFramesArray = [NSMutableArray array];
        
    }
    return _senceCreateImgViewFramesArray;

}
-(NSMutableArray *)senceSubModelArray{

    if (!_senceSubModelArray) {
        _senceSubModelArray = [NSMutableArray array];
        
    }
    return _senceSubModelArray;
}
-(NSMutableArray *)imageArray{

    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        
    }
    return _imageArray;
}
-(NSMutableArray *)imageAssetURLArray{
    
    if (!_imageAssetURLArray) {
        _imageAssetURLArray = [NSMutableArray array];
        
    }
    return _imageAssetURLArray;
}
#pragma mark -清除所以子视图
-(void)removeSubViewsFromSuperview{
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}



#pragma mark -点击图片
-(void)IS_SenceCreateImageViewDidBtnAction:(id)result{
    if (!result) {
        return;
    }
    
    //1.
    IS_SenceSubTemplateModel * subTemplateModel =[result subTemplateModel];

    if ([subTemplateModel img]) {
        IS_SenceCreateImageView * iv = result;
        [self showPopView:iv];
       _cur_tag=subTemplateModel.sub_tag;
        
    }else if(subTemplateModel.sub_type==IS_SubTypeText){
      
      
        IS_TemplateActonSheet * asv = [[IS_TemplateActonSheet alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [asv showAnimationAtContainerView:nil actonSheetBlock:nil];
        
        
//        IS_SenceCreateImageView * iv = result;
//        [iv.imageBtnView setTitle:@"你好" forState:UIControlStateNormal];
        
    }else{
        if ([self.delegate respondsToSelector:@selector(IS_SenceCreateEditViewDidSelectItem:userinfo:)]) {
            [self.delegate IS_SenceCreateEditViewDidSelectItem:subTemplateModel userinfo:nil];
        }
    }
}
#pragma mark - 浮动视图
-(NSMutableArray *)visiblePopTipViews{
    if (!_visiblePopTipViews) {
       _visiblePopTipViews = [NSMutableArray array];
    }
    return _visiblePopTipViews;
}
- (void)dismissAllPopTipViews {
    while ([_visiblePopTipViews count] > 0) {
        IS_PopView  *popTipView = [self.visiblePopTipViews objectAtIndex:0];
        [self.visiblePopTipViews removeObjectAtIndex:0];
        [popTipView dismissAnimated:YES];
//        IS_SenceCreateImageView * iv = self.senceSubViewArray[_cur_tag];
//        iv.scrollEnabled=NO;
    }
}
-(void)showPopView:(id)createImageView {
    
    //0.删除多余
    [self dismissAllPopTipViews];
    
    //1.创建新的
     IS_ImageEditView * contentView = [[NSBundle mainBundle]loadNibNamed:@"IS_ImageEditView" owner:nil options:nil][0];
    contentView.delegate =self;
    IS_PopView * popTipView= [[IS_PopView alloc] initWithCustomView:contentView];
    popTipView.delegate=self;
    popTipView.animation = arc4random() % 2;
    [popTipView presentPointingAtView:createImageView inView:self animated:YES];
    [self.visiblePopTipViews addObject:popTipView];

}
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{
//    IS_SenceCreateImageView * iv = self.senceSubViewArray[_cur_tag];
//    [iv setImageViewData:[UIImage imageNamed:@"bg_002"] isAdjust:YES isExchage:NO];
//    iv.contentSize = CGSizeMake(iv.imageBtnView.width*2, iv.imageBtnView.height*2);
//    iv.imageBtnView.size = iv.contentSize;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissAllPopTipViews];

}
#pragma mark - 浮动视图事件
-(IS_AssetPickerView *)imageAssetPickerView{

    if (!_imageAssetPickerView) {
        _imageAssetPickerView  = [[IS_AssetPickerView alloc]init];
    }
    return _imageAssetPickerView;
}
static CGFloat degree=0;
-(void)IS_ImageEditOperationViewDidBtnAction:(id)result{
    
    if ([result isKindOfClass:[UIButton class]]) {
        UIButton * btn = result;
        IS_SenceCreateImageView * cur_imageView = self.senceSubViewArray[_cur_tag];

        switch (btn.tag) {
            case 0:
            {
                
                //3.展示那个菜单
              
            
                [self.imageAssetPickerView showAnimationAtContainerView:nil
                                                   assetPickerViewBlock:^(id result) {
                                           
                           cur_imageView.subTemplateModel.img_upload_state = IS_ImageUploadStateNone;
                           cur_imageView.subTemplateModel.img_url          = nil;
                           cur_imageView.subTemplateModel.img_info         = nil;
                           cur_imageView.subTemplateModel.img              = result;
                           [cur_imageView setImageViewData:result isAdjust:YES isExchage:NO];
                        

                   }];
                
                
                [self dismissAllPopTipViews];

            }
                break;
            case 1:
            {
                [UIView animateWithDuration:0.2 animations:^{
                   
 #define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
                    
                    CGFloat angleDegrees =0;
                    if (cur_imageView.subTemplateModel.img_info) {
                         angleDegrees = [cur_imageView.subTemplateModel.img_info[ROTATION_KEY]floatValue];

                    }
                    
                    [UIView animateWithDuration:0.2f animations:^()
                     {

                         CGFloat last_angleDegrees = angleDegrees+90;
                         UIImage *i =cur_imageView.imageBtnView.currentImage;
                         UIImage * PortraitImage =[UIImage rotateImage:i angleDegrees:last_angleDegrees];
                         [cur_imageView setImageViewData:PortraitImage isAdjust:NO isExchage:NO];
                         cur_imageView.subTemplateModel.img =PortraitImage;
                         [cur_imageView.subTemplateModel.img_info setObject:@(last_angleDegrees) forKey:ROTATION_KEY];
                         
                     }];;
                   

                }];
                
                break;
            }
               
            case 2:
            {
//
                CGFloat zoomScale = cur_imageView.contentView.zoomScale *1.1;
                [cur_imageView.contentView setZoomScale:zoomScale animated:YES];
                [cur_imageView.subTemplateModel.img_info setObject:@(zoomScale) forKey:SCALE_KEY];
                
                
                
            }
                break;
            case 3:
            {
                CGFloat zoomScale = cur_imageView.contentView.zoomScale *0.9;
                [cur_imageView.contentView setZoomScale:zoomScale animated:YES];
                [cur_imageView.subTemplateModel.img_info setObject:@(zoomScale) forKey:SCALE_KEY];

            }
                break;
                
            default:
                break;
                
                
        }
        
        [self.senceTemplateModel.subview_array replaceObjectAtIndex:cur_imageView.subTemplateModel.sub_tag withObject:cur_imageView.subTemplateModel];
        [self.delegate IS_SenceCreateEditViewDidEndPanItem:self.senceTemplateModel userinfo:nil];
        
     
    }
}

#pragma mark - 图片选择


#pragma mark - 图片位置处理
//#pragma mark - 处理完
-(void)IS_SenceCreateImageViewDidDealImage:(id)result{
    
    if (result) {
        IS_SenceSubTemplateModel * subTemplateModel = result;
        [self.senceTemplateModel.subview_array replaceObjectAtIndex:subTemplateModel.sub_tag withObject:subTemplateModel];
        if ([self.delegate respondsToSelector:@selector(IS_SenceCreateEditViewDidEndPanItem:userinfo:)]) {
            [self.delegate IS_SenceCreateEditViewDidEndPanItem:self.senceTemplateModel userinfo:nil];
        }
    }
    
}
#pragma mark -拖动图片
/**
 *  拖动状态
 */
- (void)IS_SenceCreateImageViewPanning:(IS_SenceCreateImageView *)panView
                        state:(UIGestureRecognizerState)pan_state{
    

    
    NSInteger pan_tag = panView.tag;
//    NSInteger change_tag =0;
    if(pan_state == UIGestureRecognizerStateChanged)
    {

        for (int i = 0; i< self.senceSubViewArray.count; i++)
        {
            IS_SenceCreateImageView * sence_image_view = self.senceSubViewArray[i];
            NSString* tmprect = self.senceCreateImgViewFramesArray[i];
            BOOL isExchange =sence_image_view.subTemplateModel.sub_type==IS_SubTypeImage
                            &&sence_image_view.subTemplateModel.img
                            &&sence_image_view.uploadState==IS_ImageUploadStateDone
                            && CGRectContainsPoint(CGRectFromString(tmprect), panView.center);
            if (isExchange)
            {
                
                be_change_tag = (int)sence_image_view.tag;
                sence_image_view.layer.borderWidth = 2;
                sence_image_view.layer.borderColor = [IS_SYSTEM_COLOR CGColor];
            }
            else
            {
                sence_image_view.layer.borderWidth = 0;
                sence_image_view.layer.borderColor = [[UIColor clearColor]CGColor];
            }
        }
        
        
    }
    else if (pan_state == UIGestureRecognizerStateEnded)
    {

        [UIView animateWithDuration:.2  animations:^
         {
             
            
             
             //结束时将选中view的边框还原
             IS_SenceCreateImageView *  beChangeView = self.senceSubViewArray[be_change_tag];
             beChangeView.layer.borderWidth = 0;
             beChangeView.layer.borderColor = [[UIColor clearColor]CGColor];
             NSString * panViewRectString = self.senceCreateImgViewFramesArray[be_change_tag];
             beChangeView.frame =CGRectFromString(panViewRectString);
             
             //把移动的 view 也还原
             NSString * beChangeFrame = self.senceCreateImgViewFramesArray[pan_tag];
             panView.frame = CGRectFromString(beChangeFrame);



             
         


                        
#pragma mark - 交换数据-刷新
             
             IS_SenceSubTemplateModel * beChangeModel = self.senceSubModelArray[be_change_tag];
             IS_SenceSubTemplateModel * panModel = self.senceSubModelArray[pan_tag];
             //beChangeModel.img_frame=nil;
             beChangeModel.img_info=nil;

             panModel.img_info=nil;
           //  panModel.img_frame=nil;

             
             //1.交换图片
             
             UIImage * temp = panModel.img;
             [panView setImageViewData:beChangeModel.img isAdjust:NO isExchage:YES];
             [beChangeView setImageViewData:temp isAdjust:NO isExchage:YES];
             
             panModel.img=panView.imageBtnView.currentImage;//self.imageArray[pan_tag];
             beChangeModel.img=beChangeView.imageBtnView.currentImage;
         //    beChangeModel.img_url = self.imageAssetURLArray[pan_tag];
            

            // self.imageArray[be_change_tag];
           ///  panModel.img_url = self.imageAssetURLArray[be_change_tag];
             

             [self.senceTemplateModel.subview_array replaceObjectAtIndex:be_change_tag withObject:beChangeModel];
             [self.senceTemplateModel.subview_array replaceObjectAtIndex:pan_tag withObject:panModel];

             
             if ([self.delegate respondsToSelector:@selector(IS_SenceCreateEditViewDidEndPanItem:userinfo:)]) {
                 [self.delegate IS_SenceCreateEditViewDidEndPanItem:self.senceTemplateModel userinfo:nil];
             }
             
//             [self.imageAr/ray exchangeObjectAtIndex:pan_tag withObjectAtIndex:be_change_tag];

             
         } completion:^(BOOL finished)
         {
          

         }];
        
        
        
    }

    
}


@end
