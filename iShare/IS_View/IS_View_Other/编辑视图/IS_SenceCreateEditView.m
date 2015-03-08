#import "IS_SenceCreateEditView.h"
#import "IS_SenceSubTemplateModel.h"
#import "UIButton+JJ.h"
#import "PhotoPickerTool.h"
@interface IS_SenceCreateEditView()<IS_SenceCreateImageViewDelegate>

//拖动时用到的属性，记录最后的选中button的tag
@property (nonatomic,assign)NSInteger be_change_tag;
@end

@implementation IS_SenceCreateEditView
@synthesize be_change_tag;
#pragma mark - 根据模板数据来构建
-(void)setSenceTemplateModel:(IS_SenceTemplateModel *)senceTemplateModel{

    _senceTemplateModel  =senceTemplateModel;
    if (senceTemplateModel) {
        
        [self createSenceSubTemplateViewsBySubViewModelArray:senceTemplateModel.s_sub_view_array];

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
            
            senceSubTemplateModel.shapeType = IS_SubTemplateShapeTypeSmall;
           
           
        }else{
            
            senceSubTemplateModel.shapeType = IS_SubTemplateShapeTypeLarge;

        }
        
        IS_SenceCreateImageView * senceCreateImageView = [[IS_SenceCreateImageView alloc]initWithFrame:frame];
        [self addSubview:senceCreateImageView];

        senceCreateImageView.subTemplateModel =senceSubTemplateModel;
        senceCreateImageView.imageViewDelegate = self;
//        [senceCreateImageView.imageBtnView addTarget:self action:@selector(imageBtnViewAction:) forControlEvents:UIControlEventTouchUpInside];
        //3.
        [self.senceSubViewArray addObject:senceCreateImageView];
        if (senceSubTemplateModel.image_data) {
            [self.imageArray addObject:senceSubTemplateModel.image_data];
          //  [self.imageAssetURLArray addObject:senceSubTemplateModel.image_url];
        }else{
            [self.imageArray addObject:senceSubTemplateModel.image_place_name];
          //  [self.imageAssetURLArray addObject:senceSubTemplateModel.image_place_name];

        }
        [self.senceSubModelArray addObject:senceSubTemplateModel];
        [self.senceCreateImgViewFramesArray addObject:senceSubTemplateModel.sub_frame];

        
        
        
        
    }];
    
   
    
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


#pragma mark - 输入框
-(UITextView *)senceTextView{

    if (!_senceTextView) {
        _senceTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 40)];
    }
    return _senceTextView;

}
#pragma mark -点击图片
-(void)IS_SenceCreateImageViewDidBtnAction:(id)result{
    
    if (result) {
        IS_SenceSubTemplateModel * subTemplateModel =result;
        if ([self.delegate respondsToSelector:@selector(IS_SenceCreateEditViewDidSelectItem:userinfo:)]) {
            [self.delegate IS_SenceCreateEditViewDidSelectItem:subTemplateModel userinfo:nil];
        }
    }
}
#pragma mark - 图片位置处理
//#pragma mark - 处理完
-(void)IS_SenceCreateImageViewDidDealImage:(id)result{
    
    if (result) {
        IS_SenceSubTemplateModel * subTemplateModel = result;
        [self.senceTemplateModel.s_sub_view_array replaceObjectAtIndex:subTemplateModel.sub_tag withObject:subTemplateModel];
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
            if (sence_image_view.subTemplateModel.sub_type==IS_SenceSubTemplateTypeImage&&CGRectContainsPoint(CGRectFromString(tmprect), panView.center)&&sence_image_view.subTemplateModel.image_data)
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



             
             [beChangeView setImageViewData:self.imageArray[pan_tag] isAdjust:NO];
             [panView setImageViewData:self.imageArray[be_change_tag] isAdjust:NO];


                        
#pragma mark - 交换数据-刷新
             
             IS_SenceSubTemplateModel * beChangeModel = self.senceSubModelArray[be_change_tag];
             beChangeModel.sub_image_frame=nil;

             beChangeModel.image_data=self.imageArray[pan_tag];
         //    beChangeModel.image_url = self.imageAssetURLArray[pan_tag];
            

             IS_SenceSubTemplateModel * panModel = self.senceSubModelArray[pan_tag];
             panModel.sub_image_frame=nil;

             panModel.image_data=self.imageArray[be_change_tag];
           ///  panModel.image_url = self.imageAssetURLArray[be_change_tag];
             

             [self.senceTemplateModel.s_sub_view_array replaceObjectAtIndex:be_change_tag withObject:beChangeModel];
             [self.senceTemplateModel.s_sub_view_array replaceObjectAtIndex:pan_tag withObject:panModel];

             
             if ([self.delegate respondsToSelector:@selector(IS_SenceCreateEditViewDidEndPanItem:userinfo:)]) {
                 [self.delegate IS_SenceCreateEditViewDidEndPanItem:self.senceTemplateModel userinfo:nil];
             }
             
             [self.imageArray exchangeObjectAtIndex:pan_tag withObjectAtIndex:be_change_tag];

             
         } completion:^(BOOL finished)
         {
          

         }];
        
        
        
    }

    
}


@end
