#import "IS_SenceCreateEditView.h"
#import "IS_SenceSubTemplateModel.h"
#import "UIButton+JJ.h"
@interface IS_SenceCreateEditView()<IS_SenceCreateImageViewDelegate>

//拖动时用到的属性，记录最后的选中button的tag
@property (nonatomic,assign)int tmptag;

@property (nonatomic,strong)UIButton * last_button;
@end

@implementation IS_SenceCreateEditView
@synthesize tmptag;
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
    self.senceCreateImgViewArray=nil;
    self.senceCreateImgViewFramesArray=nil;
    self.senceCreateImgViewImageArray=nil;

    [arrayM enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IS_SenceSubTemplateModel * senceSubTemplateModel = obj;
        //9.建设每个视图
        
        IS_SenceCreateImageView * senceCreateImageView = [[IS_SenceCreateImageView alloc]initWithFrame:CGRectFromString(senceSubTemplateModel.sub_frame)];
        senceCreateImageView.senceSubTemplateModel =senceSubTemplateModel;
        senceCreateImageView.editViewDelegate = self;
        [senceCreateImageView.imageBtnView addTarget:self action:@selector(imageBtnViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.senceCreateImgViewImageArray addObject:senceCreateImageView.imageBtnView.currentImage];
        //3.
        [self.senceCreateImgViewArray addObject:senceCreateImageView];
        [self.senceCreateImgViewFramesArray addObject:senceSubTemplateModel.sub_frame];

        
        
        [self addSubview:senceCreateImageView];
        
    }];
    
   
    
}



#pragma mark -通知
#pragma mark -当选择照片后触发
#pragma mark -数据,记录每个子视图,子视图的Frame,图片信息

#pragma mark -存储当前模板子视图数组
-(NSMutableArray *)senceCreateImgViewArray{

    if (!_senceCreateImgViewArray) {
        _senceCreateImgViewArray = [NSMutableArray array];
        
    }
    return _senceCreateImgViewArray;
}
#pragma mark - 存储当前模板图片数据的
-(NSMutableArray *)senceCreateImgViewImageArray{
    
    if (!_senceCreateImgViewImageArray) {
        _senceCreateImgViewImageArray = [NSMutableArray array];
        
    }
    return _senceCreateImgViewImageArray;
}
#pragma mark -存储模板子视图的frame数组
-(NSMutableArray *)senceCreateImgViewFramesArray{
    
    if (!_senceCreateImgViewFramesArray) {
        _senceCreateImgViewFramesArray = [NSMutableArray array];
        
    }
    return _senceCreateImgViewFramesArray;

}

#pragma mark -清除所以子视图
-(void)removeSubViewsFromSuperview{
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}



#pragma mark -点击图片
-(void)imageBtnViewAction:(UIButton*)btn{
    
    IS_SenceSubTemplateModel * subTemplateModel = self.senceTemplateModel.s_sub_view_array[btn.tag];
    subTemplateModel.image_selected =!subTemplateModel.image_selected;
    NSLog(@"selected:%d", subTemplateModel.image_selected);
    if (!subTemplateModel.image_selected||subTemplateModel.sub_type!=IS_SenceSubTemplateTypeImage) {
        self.senceTemplateModel.s_selected_tag=-1;
    }else{
        self.senceTemplateModel.s_selected_tag=btn.tag;
    }
   
    

    
    [[NSNotificationCenter defaultCenter]postNotificationName:BIG_IMAGE_TO_IMAGE_PAN
                                                       object:subTemplateModel
                                                     userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:BIG_IMAGE_TO_COLLECTION_VIEW
                                                       object:subTemplateModel
                                                     userInfo:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:BIG_IMAGE_TO_CONTROLLER
                                                       object:nil
                                                     userInfo:nil];
    
    
    


   
}

#pragma mark - 




#pragma mark -拖动图片
/**
 *  拖动状态
 */
- (void)panSenceCreateSubView:(IS_SenceCreateImageView *)panView
                        state:(UIGestureRecognizerState)pan_state{
    

    if(pan_state == UIGestureRecognizerStateChanged)
    {
//        NSLog(@"grag change");
       //遍历9个view看移动到了哪个view区域，使其为选中状态.并更新选中view的tag值，使其永远为最新的
        for (int i = 0; i< self.senceCreateImgViewArray.count; i++)
        {
            IS_SenceCreateImageView * sence_image_view = self.senceCreateImgViewArray[i];
            NSString* tmprect = self.senceCreateImgViewFramesArray[i];
            if (CGRectContainsPoint(CGRectFromString(tmprect), panView.center))
            {
                
                if (sence_image_view.createImageViewType !=IS_SenceCreateImageViewTypeImage) {
                    return;
                }
                
                tmptag = (int)sence_image_view.tag;
                sence_image_view.layer.borderWidth = 5;
                sence_image_view.layer.borderColor = [[UIColor redColor]CGColor];
                return;
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
             IS_SenceCreateImageView *  beChangeView = self.senceCreateImgViewArray[tmptag];
             beChangeView.layer.borderWidth = 0;
             beChangeView.layer.borderColor = [[UIColor clearColor]CGColor];
             
             //把移动的 view 也还原
             NSString * panViewRectString = self.senceCreateImgViewFramesArray[panView.tag];
             panView.frame = CGRectFromString(panViewRectString);

             
#pragma mark - ImageView
             
             
//
             [panView.imageBtnView setImage:self.senceCreateImgViewImageArray[tmptag] forState:UIControlStateNormal];
             [beChangeView.imageBtnView setImage:self.senceCreateImgViewImageArray[panView.tag] forState:UIControlStateNormal];
             [self.senceCreateImgViewImageArray exchangeObjectAtIndex:panView.tag withObjectAtIndex:beChangeView.tag];
             
#pragma mark - 交换数据-刷新
        
             [self.senceTemplateModel.s_sub_view_array exchangeObjectAtIndex:panView.tag  withObjectAtIndex:beChangeView.tag];
             [[NSNotificationCenter defaultCenter]postNotificationName:BIG_IMAGE_TO_COLLECTION_VIEW object:self.senceTemplateModel];
             
             
             
         } completion:^(BOOL finished)
         {
             NSLog(@"已交换");
             //完成动画后还原btn的状态
             for (int i = 0; i< self.senceCreateImgViewArray.count; i++)
             {
                 
                 IS_SenceCreateImageView * sence_image_view =  self.senceCreateImgViewArray[i];
                 sence_image_view.layer.borderColor = [[UIColor clearColor]CGColor];
                 sence_image_view.layer.borderWidth = 0;
             }
             
         }];
        
        
        
    }

    
}


@end
