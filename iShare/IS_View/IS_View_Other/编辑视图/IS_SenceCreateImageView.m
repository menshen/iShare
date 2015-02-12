
#import "IS_SenceCreateImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "IS_SenceEditTool.h"
#import "MutilThreadTool.h"

@interface IS_SenceCreateImageView()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UILongPressGestureRecognizer  *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer        *panPressGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer        *tapPressGestureRecognizer;

@property (nonatomic, strong) UIPanGestureRecognizer        *inner_panPressGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer      *inner_pinchPressGestureRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer   *inner_rotationPressGestureRecognizer;



@property (nonatomic,assign)BOOL isSelect;//是否被选中
@property (nonatomic,assign)BOOL isInner;//是否被选中

//@property (nonatomic,assign)

@end

@implementation IS_SenceCreateImageView
#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#pragma mark - 内容视图-可以滚动
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
       
        [self addSubview:self.imageBtnView];
        self.delegate=self;
        
    }
    return self;
    
}
#pragma mark - 图片数据
- (void)setImageViewData:(UIImage *)imageData
{
    
    
    if (imageData) {
        [self.imageBtnView setImage:imageData forState:UIControlStateNormal];
    }else{
        UIImage * place_image = [UIImage imageNamed:UPLOAD_IMAGE];
        imageData=place_image;
        [self.imageBtnView setImage:place_image forState:UIControlStateNormal];
        
    }
    CGRect rect  = CGRectZero;
    rect  = CGRectZero;

    CGFloat scale = 1.0f;
    CGFloat w = 0.0f;
    CGFloat h = 0.0f;
    
    if(self.frame.size.width > self.frame.size.height)
    {
        
        w = self.frame.size.width;
        h = w*imageData.size.height/imageData.size.width;
        if(h < self.frame.size.height){
            h = self.frame.size.height;
            w = h*imageData.size.width/imageData.size.height;
        }
        
    }else{
        
        h = self.frame.size.height;
        w = h*imageData.size.width/imageData.size.height;
        if(w < self.frame.size.width){
            w = self.frame.size.width;
            h = w*imageData.size.height/imageData.size.width;
        }
    }
    rect.size  = CGSizeMake(w, h);
//        rect.size = CGSizeMake(w, h);
    
    CGFloat scale_w = w / imageData.size.width;
    CGFloat scale_h = h / imageData.size.height;
    if (w > self.frame.size.width || h > self.frame.size.height) {
        scale_w = w / self.frame.size.width;
        scale_h = h / self.frame.size.height;
        if (scale_w > scale_h) {
            scale = 1/scale_w;
        }else{
            scale = 1/scale_h;
        }
    }
    
    if (w <= self.frame.size.width || h <= self.frame.size.height) {
        scale_w = w / self.frame.size.width;
        scale_h = h / self.frame.size.height;
        if (scale_w > scale_h) {
            scale = scale_h;
        }else{
            scale = scale_w;
        }
    }


    self.imageBtnView.frame = rect;
    if (self.senceSubTemplateModel.sub_image_frame) {
        self.imageBtnView.frame = CGRectFromString(self.senceSubTemplateModel.sub_image_frame);
    }
    if (self.senceSubTemplateModel.sub_image_offset) {
        
        [self setContentOffset:CGPointFromString(self.senceSubTemplateModel.sub_image_offset)];
        
    }else{
        
        self.imageBtnView.center = CGPointMake(self.width/2, self.height/2);
        
        
    }
    [self setZoomScale:0.2 animated:YES];
   
    
    
//    @synchronized(self){
//       
//       
//        
////        [self setNeedsLayout];
//        
//    }
    
}
#pragma mark -图片视图

-(UIButton *)imageBtnView{
    
    if (!_imageBtnView) {
        _imageBtnView = [[UIButton alloc] initWithFrame:self.bounds];
//        _imageBtnView.frame = CGRectMake(0, 0, MRScreenWidth * 2.5, MRScreenWidth * 2.5);
        float minimumScale = self.frame.size.width / _imageBtnView.frame.size.width;
        [self setMinimumZoomScale:minimumScale];
        [self setZoomScale:minimumScale];
        _imageBtnView.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageBtnView;
}

-(void)setSenceSubTemplateModel:(IS_SenceSubTemplateModel *)senceSubTemplateModel{
    
    _senceSubTemplateModel = senceSubTemplateModel;
    
   
   
   
    
    //1.根据类型判断,初始化图片
    if (senceSubTemplateModel.sub_type==IS_SenceSubTemplateTypeImage) {
        self.createImageViewType=IS_SenceSubTemplateTypeImage;
//        if (!senceSubTemplateModel.image_data) {
//            senceSubTemplateModel.image_data = [IS_SenceEditTool getImagesDataFromAssetURLString:senceSubTemplateModel.image_url];//[UIImage imageNamed:UPLOAD_IMAGE];//
//        }else{
//            [self setImageViewData:senceSubTemplateModel.image_data];
//
//        }
        
        
        
        if (senceSubTemplateModel.image_data) {
            [self setImageViewData:senceSubTemplateModel.image_data];
        }else{
            [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
                if (!senceSubTemplateModel.image_data) {
                    senceSubTemplateModel.image_data = [IS_SenceEditTool getImagesDataFromAssetURLString:senceSubTemplateModel.image_url];//[UIImage imageNamed:UPLOAD_IMAGE];//
                }
            } MainThreadBlock:^{
                
                [self setImageViewData:senceSubTemplateModel.image_data];
                
            }];
        }
        
        
        
        //2.文字
        [self addGestureRecognizers];
    }else{
        self.createImageViewType=IS_SenceSubTemplateTypeText;
        [self.imageBtnView setImage:[UIImage imageNamed:senceSubTemplateModel.image_place_name]forState:UIControlStateNormal];
        
    }
    //
    self.tag = senceSubTemplateModel.sub_tag;
    self.imageBtnView.tag=senceSubTemplateModel.sub_tag;
    
    //3
    
    //
    
    
    
    //3.
    self.isSelect = NO;
    self.isSelected =senceSubTemplateModel.image_selected;
    
    //4.
    
    [self setClipsToBounds:YES];
    [self setBackgroundColor:kColor(221, 221, 221)];
    
   

}
-(void)setIsSelected:(BOOL)isSelected{

    _isSelected = isSelected;
    if (isSelected) {
        self.layer.borderWidth = 2;
        self.layer.borderColor = [IS_SYSTEM_COLOR CGColor];
        
        
    }else{
        self.layer.borderWidth = 0;
        self.layer.borderColor = [[UIColor clearColor]CGColor];
    }
}





#pragma mark -增加手势通知
-(void)addGestureNotification:(BOOL)isGesture{
    
    //
    [[NSNotificationCenter defaultCenter]postNotificationName:BIG_IMAGE_GESTURE_COLLECTION_VIEW object:@(isGesture) userInfo:nil];

}

#pragma mark - 增加手势
-(void)addGestureRecognizers{
    
   
    

    if (self.createImageViewType==IS_SenceCreateImageViewTypeImage) {
        //1.长按手势
        
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
        _longPressGestureRecognizer.minimumPressDuration=0.2;
        _longPressGestureRecognizer.delegate=self;
        for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
            }
        }
        [self addGestureRecognizer:_longPressGestureRecognizer];
        
        
      //  2.拖动手势
        
        _panPressGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        _panPressGestureRecognizer.delegate=self;
        [self addGestureRecognizer:_panPressGestureRecognizer];
//
//        
//        
//        //3.内部 Pan
//        _inner_panPressGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleInnerPanGesture:)];
//        _inner_panPressGestureRecognizer.delegate=self;
//        [_imageBtnView addGestureRecognizer:_inner_panPressGestureRecognizer];
        
        //4.内部 Pinch
        _inner_pinchPressGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handleInnerPinchGesture:)];
        _inner_pinchPressGestureRecognizer.delegate=self;
        [_imageBtnView addGestureRecognizer:_inner_pinchPressGestureRecognizer];
        
       // 5.内部 rotation
        
        _inner_rotationPressGestureRecognizer=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleInnerRotationGesture:)];
        _inner_rotationPressGestureRecognizer.delegate=self;
        [_imageBtnView addGestureRecognizer:_inner_rotationPressGestureRecognizer];
    
    }
  
    
   
    
    
}

#pragma mark -长按方法
-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender{
    
    //1.长按手势变化
    if (sender.state == UIGestureRecognizerStateChanged) {
     
        return;
    }
    
    //2.开始滑动
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            //1
            self.isSelect = YES;
            
            //2
            [self addGestureNotification:YES];
            
            //3
            
            [UIView
             animateWithDuration:0.3
             animations:^{
                 self.transform = CGAffineTransformMakeScale(1,1);
                 self.alpha=.5;
             }
             completion:nil];
            
            
             break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            self.isSelect = NO;
            [self addGestureNotification:NO];

            [UIView
             animateWithDuration:0.3
             animations:^{
                 self.transform = CGAffineTransformMakeScale(1.f, 1.f);
                 self.alpha=1;
             }
             completion:^(BOOL finished) {
                 
             }];
            
             break;
        }
        default: break;
            
    }
    
}

//拖动手势的回调方法
-(void)handlePanGesture:(UIPanGestureRecognizer*)pan
{
    //NSLog(@"drag");
    //获取手势在该视图上得偏移量
    

    
    CGPoint translation = [pan translationInView:self];

        if (pan.state == UIGestureRecognizerStateBegan)
        {
            //        NSLog(@"drag begin");
            //开始时拖动的view更改透明度
            self.alpha = 0.5;
            
            
        }
        else if(pan.state == UIGestureRecognizerStateChanged)
        {
            //        NSLog(@"grag change");
            
            
            
            //使拖动的view跟随手势移动
            self.center = CGPointMake(self.center.x + translation.x,
                                      self.center.y + translation.y);
            [pan setTranslation:CGPointZero inView:self];
            
            /**
             *  把pan 动作 post 出去
             */
            
            if ([self.editViewDelegate respondsToSelector:@selector(panSenceCreateSubView:state:)]) {
                [self.editViewDelegate panSenceCreateSubView:self state:UIGestureRecognizerStateChanged];
            }
            
            
        }
        else if (pan.state == UIGestureRecognizerStateEnded)
        {
            //        NSLog(@"drag end");
            
            [self addGestureNotification:NO];
            
            
            self.alpha = 1;
            if ([self.editViewDelegate respondsToSelector:@selector(panSenceCreateSubView:state:)]) {
                [self.editViewDelegate panSenceCreateSubView:self state:UIGestureRecognizerStateEnded];
            }
            
            
        }
//    }
    
   
    
    
    
    
}



#pragma mark  - UIGestureRecognizer-Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if([gestureRecognizer isEqual:self.panGestureRecognizer]) {
        
        return YES;
    }else  if([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        
       return self.isSelect;
    }
    
    return  YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isEqual:_longPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:_panPressGestureRecognizer];
    }
    
    if ([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:_longPressGestureRecognizer];
    }
    
    return NO;
}




#pragma mark - 内部手势处理
-(void)handleInnerPinchGesture:(UIPinchGestureRecognizer*)pinchGestureRecognizer{
    
    CGRect oldRect =CGRectZero;
    CGRect newRect =CGRectZero;

    
    
    //1.取得视图
    UIButton *view = (UIButton*)pinchGestureRecognizer.view;
    BOOL isGestureRecognizerStateBegan =(pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged);
    [self addGestureNotification:isGestureRecognizerStateBegan];
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        oldRect = view.frame;
        NSLog(@"oldSize-size:%@",NSStringFromCGRect(oldRect));
    }else if (pinchGestureRecognizer.state==UIGestureRecognizerStateChanged){
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        
        pinchGestureRecognizer.scale = 1;
    }else{
        newRect=view.frame;
        NSString * newSizeString =NSStringFromCGRect(newRect);
        NSLog(@"view-size:%@",newSizeString);
        
//        CGFloat dx =newSize.width-oldSize.width;
//        CGFloat dy =newSize.height-oldSize.height;
//        CGPoint point = CGPointMake(dx, dy);
        self.senceSubTemplateModel.sub_image_frame = newSizeString;
        if ([self.editViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewDidDealImage:)]) {
            [self.editViewDelegate IS_SenceCreateImageViewDidDealImage:self.senceSubTemplateModel];
        }
        
    }
    

    
  // UIImage * cur_image= view.currentImage;
    //2.手势在开始/进行中
   
    
   

}
- (void)handleInnerPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
   
    
    //1.取得视图
    UIView *view = panGestureRecognizer.view;
    //2.手势在开始/进行中
    BOOL isGestureRecognizerStateBegan =(panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged);
    [self addGestureNotification:isGestureRecognizerStateBegan];
    
    if (isGestureRecognizerStateBegan) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
// 处理旋转手势
- (void) handleInnerRotationGesture:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{ //1.取得视图
    UIView *view = rotationGestureRecognizer.view;
    
    //2.手势在开始/进行中
    BOOL isGestureRecognizerStateBegan =(rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged);
    [self addGestureNotification:isGestureRecognizerStateBegan];
    
    if (isGestureRecognizerStateBegan) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

#pragma mark - ScrollView-Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
//    NSLog(@"image_center:%@",NSStringFromCGPoint(scrollView.contentOffset));
    [self addGestureNotification:YES];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addGestureNotification:NO];
    
    self.senceSubTemplateModel.sub_image_offset = NSStringFromCGPoint(scrollView.contentOffset);
    if ([self.editViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewDidDealImage:)]) {
        [self.editViewDelegate IS_SenceCreateImageViewDidDealImage:self.senceSubTemplateModel];
    }
//    NSLog(@"2-image_center:%@",NSStringFromCGPoint(scrollView.contentOffset));


}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageBtnView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
  

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    self.imageBtnView.center = touch;
    
}
@end
