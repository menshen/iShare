#import "IS_EditContentView.h"
#import "IS_EditSubTemplateModel.h"
#import "UIImage+JJ.h"
#import "IS_EditPopView.h"
#import "IS_EditAssetPickerView.h"
#import "IS_TextActionSheet.h"
@interface IS_EditContentView()<IS_SenceCreateImageViewDelegate,CMPopTipViewDelegate>

//拖动时用到的属性，记录最后的选中button的tag
@property (nonatomic,assign)NSInteger beChangeTag;
@property (nonatomic,assign)NSInteger panTag;
/**
 *  可视的浮动视图
 */
@property (nonatomic, strong)NSMutableArray	*visiblePopTipViews;

/**
 *  当前被点击的 tag
 */
@property (nonatomic,assign) NSInteger cur_tag;


@property (nonatomic,strong)IS_EditAssetPickerView *imageAssetPickerView;
@end

@implementation IS_EditContentView

#pragma mark - *初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


#pragma mark - 根据模板数据来构建

-(void)setSenceTemplateModel:(IS_EditTemplateModel *)senceTemplateModel{

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
            IS_EditSubTemplateModel * senceSubTemplateModel = obj;
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
            
            IS_EditImageView * senceCreateImageView = [[IS_EditImageView alloc]initWithFrame:frame];
            [self addSubview:senceCreateImageView];
            
            senceCreateImageView.subTemplateModel =senceSubTemplateModel;
            senceCreateImageView.imageViewDelegate = self;
            //        [senceCreateImageView.imageBtnView addTarget:self action:@selector(imageBtnViewAction:) forControlEvents:UIControlEventTouchUpInside];
            //3.
            [self.senceSubViewArray addObject:senceCreateImageView];
            
            if (senceSubTemplateModel.imageModel.img) {
                [self.imageArray addObject:senceSubTemplateModel.imageModel.img];
                //  [self.imageAssetURLArray addObject:senceSubTemplateModel.img_url];
            }else{
                [self.imageArray addObject:senceSubTemplateModel.imageModel.img_place_name];
                //  [self.imageAssetURLArray addObject:senceSubTemplateModel.img_place_name];
                
            }
            [self.senceSubModelArray addObject:senceSubTemplateModel];
            [self.senceCreateImgViewFramesArray addObject:senceSubTemplateModel.sub_frame];
            
        }];
        
       
    /**
     动画时间
     *
     */
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.senceSubViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            IS_EditImageView * senceCreateImageView = obj;
//            if (idx==0) {
//                [UIView animateWithDuration:1 animations:^{
//                    senceCreateImageView.transform =CGAffineTransformMakeTranslation(-200, 0);
//                } completion:^(BOOL finished) {
//                    senceCreateImageView.transform = CGAffineTransformIdentity;
//                    
//                }];
//            }
//           
//        }];
//    });
    
   


    
   
    
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
    IS_EditSubTemplateModel * subTemplateModel =[result subTemplateModel];

    if ([subTemplateModel imageModel].img) {
        IS_EditImageView * iv = result;
        [self showPopView:iv];
       _cur_tag=subTemplateModel.sub_tag;
        
    }else if(subTemplateModel.sub_type==IS_SubTypeText){
        
        IS_EditImageView * curImageView = result;
        CGFloat ONE_H = curImageView.bottom+IS_NAV_BAR_HEIGHT+IS_CARD_LAYOUT_HEIGHT*2+IS_NAV_TOOLBAT_H+(iPhone4_4S?85:0);
        CGFloat TEXT_H =(IOS8?IS_KEYBOARD_H_IOS8:IS_KEYBOARD_H_IOS7)+70;
//        CGFloat FONT_SIZE = curImageView.imageBtnView.titleLabel.font.pointSize;
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            if (ONE_H>TEXT_H) {
                self.transform = CGAffineTransformMakeTranslation(0, -(ONE_H-TEXT_H));
            }
            IS_TextActionSheet * textActionSheet = [[IS_TextActionSheet alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            NSString * curText = subTemplateModel.text?subTemplateModel.text:subTemplateModel.text_place_string;
            [textActionSheet showActionSheetAtView:nil PlaceText:curText inputDoneBlock:^(id text) {
                
                [UIView animateWithDuration:.2 animations:^{
                    [curImageView.imageBtnView setTitle:text forState:UIControlStateNormal];
                    IS_EditSubTemplateModel * beChangeModel = curImageView.subTemplateModel;
                    beChangeModel.text=text;
                    [self.senceTemplateModel.subview_array replaceObjectAtIndex:beChangeModel.sub_tag withObject:beChangeModel];
                    [self.delegate IS_EditViewDidChangeDataAction:self.senceTemplateModel userinfo:nil];
                    self.transform = CGAffineTransformIdentity;
                }];
                

                
            } inputIngBlock:^(id inputText) {
                [curImageView.imageBtnView setTitle:inputText forState:UIControlStateNormal];
                
            } imageUploadBlock:nil];
        } completion:^(BOOL finished) {
            
        }];
        
        
        
        
        }else{
          if ([self.delegate respondsToSelector:@selector(IS_EditContentViewDidSelectItem:userinfo:)]) {
            [self.delegate IS_EditContentViewDidSelectItem:subTemplateModel userinfo:nil];
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
        IS_EditPopView  *popTipView = [self.visiblePopTipViews objectAtIndex:0];
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
    IS_EditPopView * popTipView= [[IS_EditPopView alloc] initWithFrame:CGRectZero popViewBtnAction:^(id result) {
        [self IS_ImageEditOperationViewDidBtnAction:result];
    }];
    popTipView.delegate=self;
    popTipView.animation = arc4random() % 2;
    [popTipView presentPointingAtView:createImageView inView:self animated:YES];
    [self.visiblePopTipViews addObject:popTipView];

}
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissAllPopTipViews];

}
#pragma mark - 浮动视图事件
-(IS_EditAssetPickerView *)imageAssetPickerView{

    if (!_imageAssetPickerView) {
        _imageAssetPickerView  = [[IS_EditAssetPickerView alloc]init];
    }
    return _imageAssetPickerView;
}
//static CGFloat degree=0;
-(void)IS_ImageEditOperationViewDidBtnAction:(id)result{
    
    if ([result isKindOfClass:[UIButton class]]) {
        UIButton * btn = result;
        IS_EditImageView * cur_imageView = self.senceSubViewArray[_cur_tag];
        switch (btn.tag) {
            case 0:
            {
                
                //3.展示那个菜单
              
                IS_ImageModel * imgModel = cur_imageView.subTemplateModel.imageModel;
                [self.imageAssetPickerView showAnimationAtContainerView:nil
                                            assetPickerViewBlock:^(id result) {
                                                       imgModel.img_upload_state = IS_ImageUploadStateNone;
                                                       imgModel.img_url          = nil;
                                                       imgModel.img_info         = nil;
                                                       imgModel.img              = result;
                                                        cur_imageView.subTemplateModel.imageModel = imgModel;
                                                       [cur_imageView setImageViewData:result isAdjust:YES isExchage:NO];
                                                
                                                [self.senceTemplateModel.subview_array replaceObjectAtIndex:cur_imageView.subTemplateModel.sub_tag withObject:cur_imageView.subTemplateModel];
                                                [self.delegate IS_EditViewDidChangeDataAction:self.senceTemplateModel userinfo:nil];
                                                
                                                   }
                                                    assetPickerViewType:IS_EditAssetPickerViewTypeOrigin];
                 
                        

                
                
                
                [self dismissAllPopTipViews];

            }
                break;
            case 1:
            {
                
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

                CGFloat angleDegrees =0;
                if (cur_imageView.subTemplateModel.imageModel.img_info) {
                    angleDegrees = [cur_imageView.subTemplateModel.imageModel.img_info[ROTATION_KEY]floatValue];
                    
                }
                CGFloat last_angleDegrees = angleDegrees+90;
                
              
                

                    [UIView animateWithDuration:.2 animations:^{
        
                     
                        cur_imageView.imageBtnView.transform = CGAffineTransformMakeRotation(RADIANS_TO_DEGREES(last_angleDegrees));

                        
                    } completion:^(BOOL finished) {
                        
                        cur_imageView.imageBtnView.transform = CGAffineTransformIdentity;

                        UIImage *i =cur_imageView.imageBtnView.currentImage;
                        UIImage * PortraitImage =[UIImage rotateImage:i angleDegrees:last_angleDegrees];
                        [cur_imageView setImageViewData:PortraitImage isAdjust:NO isExchage:NO];
                        cur_imageView.subTemplateModel.imageModel.img =PortraitImage;
                        [cur_imageView.subTemplateModel.imageModel.img_info setObject:@(last_angleDegrees) forKey:ROTATION_KEY];
                        
                        

                    }];
                    
                   
                   

                
                break;
            }
               
            case 2:
            {
//
                CGFloat zoomScale = cur_imageView.contentView.zoomScale *1.1;
                [cur_imageView.contentView setZoomScale:zoomScale animated:YES];
                [cur_imageView.subTemplateModel.imageModel.img_info setObject:@(zoomScale) forKey:SCALE_KEY];
                
                
                
            }
                break;
            case 3:
            {
                CGFloat zoomScale = cur_imageView.contentView.zoomScale *0.9;
                [cur_imageView.contentView setZoomScale:zoomScale animated:YES];
                [cur_imageView.subTemplateModel.imageModel.img_info setObject:@(zoomScale) forKey:SCALE_KEY];

            }
                break;
                
            default:
                break;
                
                
        }
        
        [self.senceTemplateModel.subview_array replaceObjectAtIndex:cur_imageView.subTemplateModel.sub_tag withObject:cur_imageView.subTemplateModel];
        [self.delegate IS_EditViewDidChangeDataAction:self.senceTemplateModel userinfo:nil];
        
     
    }
}

#pragma mark - 图片位置处理
//#pragma mark - 处理完
-(void)IS_SenceCreateImageViewDidDealImage:(id)result{
    
    if (result) {
        IS_EditSubTemplateModel * subTemplateModel = result;
        [self.senceTemplateModel.subview_array replaceObjectAtIndex:subTemplateModel.sub_tag withObject:subTemplateModel];
        [self.delegate IS_EditViewDidChangeDataAction:self.senceTemplateModel userinfo:nil];

    }
    
}
#pragma mark -拖动图片
/**
 *  拖动状态
 */
- (void)IS_SenceCreateImageViewPanning:(IS_EditImageView *)panView
                        state:(UIGestureRecognizerState)pan_state{
    

    
    _panTag = panView.tag;
    if(pan_state == UIGestureRecognizerStateChanged)
    {
#pragma mark - 检索每一个内部的视图
        for (int i = 0; i< self.senceSubViewArray.count; i++)
        {
            IS_EditImageView * editImageView = self.senceSubViewArray[i];
            NSString* tmprect = self.senceCreateImgViewFramesArray[i];
            IS_ImageModel *imgModel =editImageView.subTemplateModel.imageModel;
            
            
            BOOL isExchange =editImageView.subTemplateModel.sub_type==IS_SubTypeImage
                            &&imgModel.img
                            && CGRectContainsPoint(CGRectFromString(tmprect), panView.center);
            
            //0.是否交换
            if (isExchange)
            {
                
                _beChangeTag = (int)editImageView.tag;
                editImageView.layer.borderWidth = 4;
                editImageView.layer.borderColor = [IS_SYSTEM_COLOR CGColor];
            }
            else
            {
                editImageView.layer.borderWidth = 0;
                editImageView.layer.borderColor = [[UIColor clearColor]CGColor];
            }
        }
        
        
    }
#pragma mark - 检索结束
    else if (pan_state == UIGestureRecognizerStateEnded)
    {

        [UIView animateWithDuration:.2  animations:^
         {
             
            
             
             //结束时将选中view的边框还原
             IS_EditImageView *  targetEditImageView = self.senceSubViewArray[_beChangeTag];
             targetEditImageView.layer.borderWidth = 0;
             targetEditImageView.layer.borderColor = [[UIColor clearColor]CGColor];
             NSString * panViewRectString = self.senceCreateImgViewFramesArray[_beChangeTag];
             targetEditImageView.frame =CGRectFromString(panViewRectString);
             
             //把移动的 view 也还原
             NSString * beChangeFrame = self.senceCreateImgViewFramesArray[_panTag];
             panView.frame = CGRectFromString(beChangeFrame);
                        
#pragma mark - 交换数据 1.清楚照片位置信息 2.交互二进制图片
             
             IS_EditSubTemplateModel * beChangeModel = self.senceSubModelArray[_beChangeTag];
             IS_EditSubTemplateModel * panModel = self.senceSubModelArray[_panTag];
             
             
             beChangeModel.imageModel.img_info=nil;
             panModel.imageModel.img_info=nil;
             
             IS_ImageModel * panImgModel = panModel.imageModel;
             [panView setImageViewData:beChangeModel.imageModel.img isAdjust:NO isExchage:YES];
             [targetEditImageView setImageViewData:panImgModel.img isAdjust:NO isExchage:YES];
        
             
             panModel.imageModel=beChangeModel.imageModel;
             beChangeModel.imageModel=panImgModel;
        
#pragma mark - 把数据存到数组
             [self.senceTemplateModel.subview_array replaceObjectAtIndex:_beChangeTag withObject:beChangeModel];
             [self.senceTemplateModel.subview_array replaceObjectAtIndex:_panTag withObject:panModel];

             [self.delegate IS_EditViewDidChangeDataAction:self.senceTemplateModel userinfo:nil];
//             [self IS_SenceCreateImageViewDidDealImage:self.senceTemplateModel];
            

             
         } completion:^(BOOL finished)
         {
          

         }];
    }
}


@end
