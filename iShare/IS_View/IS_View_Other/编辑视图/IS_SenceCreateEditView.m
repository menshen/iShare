#import "IS_SenceCreateEditView.h"

@interface IS_SenceCreateEditView()<IS_SenceCreateImageViewDelegate>

//拖动时用到的属性，记录最后的选中button的tag
@property (nonatomic,assign)int tmptag;


@end

@implementation IS_SenceCreateEditView
@synthesize tmptag;
#pragma mark - 根据模板数据来构建视图
-(void)setSenceTemplateModel:(IS_SenceTemplateModel *)senceTemplateModel{

    _senceTemplateModel  =senceTemplateModel;
    
    if (senceTemplateModel) {
        [self didSelectedStoryboardStyleIndex:senceTemplateModel.s_template_stype
                                SubStyleIndex:senceTemplateModel.s_sub_template_stype];
    }else{
    
        [self removeSubViewsFromSuperview];
    }

    //2.图片

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
#pragma mark - 构建整体视图


#define SUB_VIEW_INFO @"view_info"
#define FRAME_KEY @"frame"
#define HEIGHT_KEY @"h"
#define WIDTH_KEY @"w"
#define X_KEY @"x"
#define Y_KEY @"y"

#define TYPE_KEY @"type"
#define PLACE_IMAGE_NAME @"place_image"
- (void)didSelectedStoryboardStyleIndex:(NSInteger)StyleIndex
                          SubStyleIndex:(NSInteger)SubStyleIndex
{
    
    //0.清除子视图
    [self removeSubViewsFromSuperview];
    [self resetViewByStyleIndex:StyleIndex SubStyleIndex:SubStyleIndex];
    
    [_senceTemplateModel.s_img_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IS_SenceCreateImageView * senceCreateImageView_1 = self.senceCreateImgViewArray[idx];
        senceCreateImageView_1.imageBtnView.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [senceCreateImageView_1.imageBtnView setImage:obj forState:UIControlStateNormal];
        
    }];
    
}
#pragma mark -清除所以子视图
-(void)removeSubViewsFromSuperview{
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}
- (void)resetViewByStyleIndex:(NSInteger)index
                   SubStyleIndex:(NSInteger)sub_index
{
    
        //0. 如果是空模板
        if (index==0) {
        return;
        }
        self.senceCreateImgViewArray=nil;self.senceCreateImgViewFramesArray=nil;
        self.senceCreateImgViewImageArray=nil;
        //1.模板对应配置文件
        NSString *styleName = [NSString stringWithFormat:@"t_%d_%d",(int)index,(int)sub_index+1];
        
        //2.
        NSDictionary *styleDict = [NSString objectFromJsonFilePath:styleName];
        
    
        //3.
        NSArray * sub_view_info_array = styleDict[SUB_VIEW_INFO];
        
    
            //4.遍历 每一个子视图信息
            [sub_view_info_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary  * sub_view_info_dic = obj;
                
                //5.frame 信息
                NSDictionary  * sub_view_frame = sub_view_info_dic[FRAME_KEY];
                
                
                
                CGFloat X = [sub_view_frame[X_KEY] floatValue]*0.01*self.width;
                CGFloat Y = [sub_view_frame[Y_KEY] floatValue]*0.01*self.height;
                CGFloat W = [sub_view_frame[WIDTH_KEY] floatValue]*0.01*self.width;
                CGFloat H = [sub_view_frame[HEIGHT_KEY] floatValue]*0.01*self.height;
                CGRect rect = CGRectMake(X, Y, W, H);
                
                
                   //6.是什么类型的
                
                NSInteger sub_view_type = [sub_view_info_dic[TYPE_KEY] integerValue];
                
                    //7.占位符
                
                NSString * place_image_name = sub_view_info_dic[PLACE_IMAGE_NAME];
                
                //8.已经保存的照片
                UIImage * existImage = nil;
              
                
                //9.建设每个视图
                
               IS_SenceCreateImageView * senceCreateImageView = [self createEditViewWithFrame:rect
                                   existImage:existImage
                               placeImageName:place_image_name
                                          Tag:idx
                                         path:nil
                                         type:sub_view_type];
                
                 [self addSubview:senceCreateImageView];
            }];
       
    
       
    
    
    
}
#pragma mark -构建子视图
/**
 *  根据 Frame-tag-path-type-placeName来建设每个子视图
 */
-(IS_SenceCreateImageView*)createEditViewWithFrame:(CGRect)frame
                    existImage:(UIImage*)existImage
                placeImageName:(NSString*)placeImageName
                           Tag:(NSInteger)tag
                          path:(UIBezierPath*)path
                          type:(NSInteger)type{
    
    
  
    
    //2.把视图的片块拼好
    IS_SenceCreateImageView *senceCreateImageView = [[IS_SenceCreateImageView alloc] initWithFrame:frame];
    [senceCreateImageView setClipsToBounds:YES];
    [senceCreateImageView setBackgroundColor:kColor(221, 221, 221)];
    senceCreateImageView.tag = tag;
    senceCreateImageView.editViewDelegate = self;
    senceCreateImageView.createImageViewType =type;
    senceCreateImageView.imageBtnView.tag=tag;
    [senceCreateImageView.imageBtnView addTarget:self action:@selector(imageBtnViewAction:) forControlEvents:UIControlEventTouchUpInside];

    if (type==IS_SenceCreateImageViewTypeImage) {
        if (existImage) {
            [senceCreateImageView.imageBtnView setImage:existImage forState:UIControlStateNormal];

        }else{
            senceCreateImageView.imageBtnView.imageView.contentMode=UIViewContentModeCenter;
            [senceCreateImageView.imageBtnView setImage:[UIImage imageNamed:@"UPLOAD_IMAGE"] forState:UIControlStateNormal];

        }
        
        [self.senceCreateImgViewArray addObject:senceCreateImageView];
        [self.senceCreateImgViewFramesArray  addObject:NSStringFromCGRect(frame)];
        [self.senceCreateImgViewImageArray addObject:senceCreateImageView.imageBtnView.currentImage];
    }else{
        [senceCreateImageView.imageBtnView setImage:[UIImage imageNamed:placeImageName] forState:UIControlStateNormal];

    }
    //回调或者说是通知主线程刷新，
    
  
    
   

    return senceCreateImageView;

}

#pragma mark -点击图片
-(void)imageBtnViewAction:(UIButton*)btn{
    [[NSNotificationCenter defaultCenter]postNotificationName:IS_SenceCreateViewDidChangeImage
                                                       object:btn
                                                     userInfo:@{@"type":@(0)}];
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
             [panView.imageBtnView setImage:self.senceCreateImgViewImageArray[beChangeView.tag] forState:UIControlStateNormal];
             [beChangeView.imageBtnView setImage:self.senceCreateImgViewImageArray[beChangeView.tag] forState:UIControlStateNormal];
             [self.senceCreateImgViewImageArray exchangeObjectAtIndex:panView.tag withObjectAtIndex:beChangeView.tag];
             
             
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
