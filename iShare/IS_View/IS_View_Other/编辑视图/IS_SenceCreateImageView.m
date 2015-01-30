
#import "IS_SenceCreateImageView.h"


@interface IS_SenceCreateImageView()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panPressGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapPressGestureRecognizer;


@property (nonatomic,assign)BOOL isSelect;//是否被选中

@end

@implementation IS_SenceCreateImageView

-(void)setSenceSubTemplateModel:(IS_SenceSubTemplateModel *)senceSubTemplateModel{
    
    _senceSubTemplateModel = senceSubTemplateModel;
    
    //1.根据类型判断,初始化图片
    if (senceSubTemplateModel.sub_type==IS_SenceSubTemplateTypeImage) {
        UIImage * image =senceSubTemplateModel.image_data;
        if (image) {
            [self.imageBtnView setImage:image forState:UIControlStateNormal];
        }else{
            UIImage * place_image = [UIImage imageNamed:UPLOAD_IMAGE];
            [self.imageBtnView setImage:place_image forState:UIControlStateNormal];
            self.imageBtnView.imageView.contentMode=UIViewContentModeCenter;

        }
        //2.文字
        [self addGestureRecognizers];
    }else{
        [self.imageBtnView setImage:[UIImage imageNamed:senceSubTemplateModel.image_place_name]forState:UIControlStateNormal];

    }
    //
    self.tag = senceSubTemplateModel.sub_tag;
    self.imageBtnView.tag=senceSubTemplateModel.sub_tag;
    
    //3
    
    //1
    [self initContentViewWithImageView];
    
  
    
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
        self.layer.borderWidth = 5;
        self.layer.borderColor = [[UIColor redColor]CGColor];
        
        
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
        
        
        //2.拖动手势
        
        _panPressGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        _panPressGestureRecognizer.delegate=self;
        [self addGestureRecognizer:_panPressGestureRecognizer];
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
    
    
    //一下分别为拖动时的三种状态：开始，变化，结束
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
    
    
    
    
}
/**
 *  初始化
 */
- (void)initContentViewWithImageView
{
    self.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageBtnView];
}
#pragma mark - 内容视图-可以滚动
-(UIView *)contentView{

    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 0, 0)];
//        _contentView.delegate = self;
//        _contentView.showsHorizontalScrollIndicator = NO;
//        _contentView.showsVerticalScrollIndicator = NO;
//        float minimumScale = self.frame.size.width / self.imageview.frame.size.width;
//        [_contentView setMinimumZoomScale:minimumScale];
//        [_contentView setZoomScale:minimumScale];
    }
    return _contentView;

}
#pragma mark -图片视图
-(UIButton *)imageBtnView{
    
    if (!_imageBtnView) {
        _imageBtnView = [[UIButton alloc] initWithFrame:self.contentView.bounds];
        _imageBtnView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageBtnView;
}

#pragma mark  - UIGestureRecognizer-Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        return self.isSelect;
    }
    return YES;
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

#pragma mark - UIScrollViewDelegate

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return _imageview;
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    
//    [scrollView setZoomScale:scale animated:NO];
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
////    self.gestureRecognizers = nil;
//    return;
//}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    return;
//}
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//    
//}
//
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint touch = [[touches anyObject] locationInView:self.superview];
//    self.imageview.center = touch;
//    
//}

@end
