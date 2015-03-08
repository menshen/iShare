
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

/**
 *  是否长按中
 */
@property (nonatomic,assign)BOOL isLongPress;

@end

@implementation IS_SenceCreateImageView
#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#pragma mark - 内容视图-可以滚动
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
       
        [self addSubview:self.imageBtnView];
        float minimumScale = self.frame.size.width / MRScreenWidth *2.5;
        [self setMaximumZoomScale:2];
        [self setZoomScale:minimumScale];
        self.delegate=self;
        
    }
    return self;
    
}
#pragma mark - 图片数据
- (void)setImageViewData:(UIImage *)imageData
                isAdjust:(BOOL)isAdjust
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
    
//    if (w <= self.frame.size.width || h <= self.frame.size.height) {
//        scale_w = w / self.frame.size.width;
//        scale_h = h / self.frame.size.height;
//        if (scale_w > scale_h) {
//            scale = scale_h;
//        }else{
//            scale = scale_w;
//        }
//    }


    self.imageBtnView.frame = rect;

    [self setBackgroundColor:kColor(221, 221, 221)];
    if (isAdjust&&!self.subTemplateModel.sub_image_frame) {
        [self setZoomScale:1-scale];
    }
    [self setMinimumZoomScale:scale+0.1];
    if (self.subTemplateModel.sub_image_frame) {
        
          CGRect frame =CGRectFromString(self.subTemplateModel.sub_image_frame);
        if (self.subTemplateModel.shapeType==IS_SubTemplateShapeTypeSmall) {
            frame  = CGRectMake(frame.origin.x/3, frame.origin.y/3, frame.size.width/3, frame.size.height/3);
        }else{
            
        }
        
      
        self.contentOffset=frame.origin;
        self.contentSize=frame.size;
        self.imageBtnView.frame =CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    if (self.subTemplateModel.sub_image_offset) {

     //  [self setContentOffset:CGPointFromString(self.subTemplateModel.sub_image_offset)];

    }else{

    //    self.contentOffset=CGPointMake(0, 20);
        
        
        }
    
}
#pragma mark -图片视图

-(UIButton *)imageBtnView{
    
    if (!_imageBtnView) {
        _imageBtnView = [[UIButton alloc] initWithFrame:self.bounds];
        _imageBtnView.backgroundColor = [UIColor clearColor];
        [_imageBtnView addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
  
    
    return _imageBtnView;
}
#pragma mark -操作拦
-(UIImageView *)operationBar{
    
    if (!_operationBar) {
        _operationBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        _operationBar.image = [UIImage imageNamed:@"Be_My_Own"];
    }
    return _operationBar;
    
}

-(void)setSubTemplateModel:(IS_SenceSubTemplateModel *)subTemplateModel{
    
    _subTemplateModel = subTemplateModel;
    
   

    switch (subTemplateModel.sub_type) {
        case IS_SenceSubTemplateTypeImage:
        {
            if (subTemplateModel.image_data) {
                //1.有数据的
                [self setImageViewData:subTemplateModel.image_data isAdjust:YES];
                
            }else if(subTemplateModel.image_url){
                //2,指向图片库
                [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
                    if (!subTemplateModel.image_data) {
                        subTemplateModel.image_data = [IS_SenceEditTool getImagesDataFromAssetURLString:subTemplateModel.image_url];//[UIImage imageNamed:UPLOAD_IMAGE];//
                    }
                } MainThreadBlock:^{
                    
                    [self setImageViewData:subTemplateModel.image_data isAdjust:YES];
                    
                }];
            }else if (subTemplateModel.image_place_name){
                //3.有占位图片
                 [self.imageBtnView setImage:[UIImage imageNamed:subTemplateModel.image_place_name]forState:UIControlStateNormal];
                _imageBtnView.imageView.contentMode = UIViewContentModeScaleAspectFill;

            }
            //2.增加手势
            [self addGestureRecognizers];
        }
            break;
        case IS_SenceSubTemplateTypeDecorate:{
        
            [self.imageBtnView setImage:[UIImage imageNamed:subTemplateModel.image_place_name]forState:UIControlStateNormal];
            self.imageBtnView.imageView.backgroundColor = [UIColor clearColor];
            self.imageBtnView.userInteractionEnabled=NO;
        }
            break;
        case IS_SenceSubTemplateTypeText:{
        //Raleway Thin
            UIFont * raleway_font = [UIFont fontWithName:@"Raleway-Thin" size:20]; //[UIFont systemFontOfSize:25];
            
            [self.imageBtnView.titleLabel setFont:raleway_font];
            self.imageBtnView.titleLabel.numberOfLines=0;
            [self.imageBtnView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            self.imageBtnView.titleLabel.textAlignment = NSTextAlignmentLeft;
            [self.imageBtnView setTitle:subTemplateModel.text_string forState:UIControlStateNormal];
            self.imageBtnView.imageView.backgroundColor = [UIColor clearColor];
//            self.imageBtnView.height=60;
            

        }
            break;
            
        default:
            break;
    }
    
 
    self.tag = subTemplateModel.sub_tag;
    self.imageBtnView.tag=subTemplateModel.sub_tag;

    
    //3.
    self.isLongPress =NO;
    
    //4.
    
    [self setClipsToBounds:YES];
   //
    
   

}
#pragma mark - 点击按钮
- (void)btnAction:(UIButton *)btn{
    
    btn.transform =CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration:.2 animations:^{
        btn.transform =CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        IS_SenceSubTemplateModel * subTemplateModel = self.subTemplateModel;
        if (subTemplateModel.image_data) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"更换" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"sure", nil];
            [alertView showWithCompletionHandler:^(NSInteger buttonIndex) {
                
                if (buttonIndex==0) {
                    return;
                }
                UIImage * i = [UIImage imageNamed:@"bg_002"];
                [self setImageViewData:i isAdjust:NO];
                self.subTemplateModel.image_data=i;
                if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewDidBtnAction:)]) {
                    [self.imageViewDelegate IS_SenceCreateImageViewDidBtnAction:self.subTemplateModel];
                }
//                [btn setImage:i forState:UIControlStateNormal];
//                [[self.senceSubViewArray objectAtIndex:btn.tag] setImageViewData:i isAdjust:NO];

            }];
            
        }else{
            if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewDidBtnAction:)]) {
                [self.imageViewDelegate IS_SenceCreateImageViewDidBtnAction:self.subTemplateModel];
            }
        }
        
        
    }];
}





#pragma mark -增加手势通知
-(void)addGestureNotification:(BOOL)isGesture{
    
    //
    [[NSNotificationCenter defaultCenter]postNotificationName:BIG_IMAGE_GESTURE_COLLECTION_VIEW object:@(isGesture) userInfo:nil];

}

#pragma mark - 增加手势
-(void)addGestureRecognizers{
    
   
    

    if (self.subTemplateModel.sub_type==IS_SenceSubTemplateTypeImage&&self.subTemplateModel.image_data) {
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
//       // 5.内部 rotation
//        
//        _inner_rotationPressGestureRecognizer=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleInnerRotationGesture:)];
//        _inner_rotationPressGestureRecognizer.delegate=self;
//        [_imageBtnView addGestureRecognizer:_inner_rotationPressGestureRecognizer];
    
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
            self.isLongPress = YES;
            
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
            self.isLongPress = NO;
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
            
            if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewPanning:state:)]) {
                [self.imageViewDelegate IS_SenceCreateImageViewPanning:self state:UIGestureRecognizerStateChanged];
            }
            
            
        }
        else if (pan.state == UIGestureRecognizerStateEnded)
        {
            //        NSLog(@"drag end");
            
            [self addGestureNotification:NO];
            
            
            self.alpha = 1;
            if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewPanning:state:)]) {
                [self.imageViewDelegate IS_SenceCreateImageViewPanning:self state:UIGestureRecognizerStateEnded];
            }
            
            
        }
//    }
    
   
    
    
    
    
}



#pragma mark  - UIGestureRecognizer-Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if([gestureRecognizer isEqual:self.panGestureRecognizer]) {
        
        return YES;
    }else  if([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        
       return self.isLongPress;
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
    

    
    return YES;
}







#pragma mark - ScrollView-Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self addGestureNotification:YES];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addGestureNotification:NO];
    CGPoint point = scrollView.contentOffset;
    CGSize size = scrollView.contentSize;
    CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
    self.subTemplateModel.sub_image_frame = NSStringFromCGRect(frame);
    if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewDidDealImage:)]) {
        [self.imageViewDelegate IS_SenceCreateImageViewDidDealImage: self.subTemplateModel];
    }}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    [self addGestureNotification:YES];

}- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
    [self addGestureNotification:NO];

    CGPoint point = scrollView.contentOffset;
    CGSize size = scrollView.contentSize;
    CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
    self.subTemplateModel.sub_image_frame = NSStringFromCGRect(frame);
    if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewDidDealImage:)]) {
        [self.imageViewDelegate IS_SenceCreateImageViewDidDealImage: self.subTemplateModel];
    }


}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    self.imageBtnView.center = touch;
    
}
#pragma mark - 设置视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageBtnView;
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    //    NSLog(@"zoomRect.size.height is %f",zoomRect.size.height);
    //    NSLog(@"self.frame.size.height is %f",self.frame.size.height);
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
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

@end
