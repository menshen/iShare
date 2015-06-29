
#import "IS_EditImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "IS_SenceEditTool.h"
#import "MutilThreadTool.h"
#import "CMPopTipView.h"
#import "HttpTool.h"
#import "IS_EditLoadingView.h"
#import "UIColor+JJ.h"
#import "UIButton+WebCache.h"
#import "RTSpinKitView.h"

@interface IS_EditImageView()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer       *panPressGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer       *tapPressGestureRecognizer;

@property (nonatomic, strong) UIPanGestureRecognizer       *inner_panPressGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer     *inner_pinchPressGestureRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer  *inner_rotationPressGestureRecognizer;
/**
 *  是否长按中
 */
@property (nonatomic,assign ) BOOL                         isLongPress;
/**
 *  加载视图
 */
@property (nonatomic,strong ) IS_EditLoadingView               * loadingView;

@end

@implementation IS_EditImageView
#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#pragma mark - 内容视图-可以滚动
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
       
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.imageBtnView];
        [self.contentView addSubview:self.loadingView];
        
        
    }
    return self;
    
}
#pragma mark - 增加观察者来观察数据变化


#pragma mark - 图片数据
- (void)setImageViewData:(UIImage *)imageData
                isAdjust:(BOOL)isAdjust
               isExchage:(BOOL)isExchage
{
    
    
    if (imageData) {

//        [self uploadImageData:imageData];
        [self.imageBtnView setImage:imageData forState:UIControlStateNormal];

       
    }else{
        
        UIImage * place_image = [UIImage imageNamed:UPLOAD_IMAGE];
        imageData=place_image;
        [self.imageBtnView setImage:place_image forState:UIControlStateNormal];

        
    }

    NSDictionary * dic = [UIImage dealImageData:imageData
                          containView:self];
    
    CGFloat scale =[dic[SCALE_KEY]floatValue];
    CGRect rect  = CGRectFromString(dic[RECT_KEY]);
    self.imageBtnView.frame =rect;
    [self setBackgroundColor:kColor(221, 221, 221)];
    self.subTemplateModel.img_frame = NSStringFromCGRect(rect);
    [self.imageViewDelegate IS_SenceCreateImageViewDidDealImage:self.subTemplateModel];

#pragma mark - 图片调整
    
    IS_ImageModel * imgModel =self.subTemplateModel.imageModel;
    
    if (isAdjust&&!imgModel.img_info) {
        [self.contentView setZoomScale:1-scale];
        [self.contentView setMinimumZoomScale:scale+0.1];

    }else if(isExchage==YES&&isAdjust==NO){
        
        
        NSDictionary * info = imgModel.img_info;
        CGRect frame = CGRectFromString( self.subTemplateModel.img_frame);
        CGPoint offset = CGPointFromString(info[TRANSLATE_KEY]);
        CGFloat scale =  [info[SCALE_KEY] floatValue];
        CGFloat W = frame.size.width * scale;
        CGFloat H = frame.size.height * scale;
        self.contentView.contentOffset=offset;
        self.contentView.contentSize =CGSizeMake(W,H);
        self.imageBtnView.frame =CGRectMake(0, 0, rect.size.width, rect.size.height);
        
        
    }else if (imgModel.img_info&&isAdjust==YES) {
        
        
        
        NSDictionary * info = imgModel.img_info;
        CGPoint offset = CGPointFromString(info[TRANSLATE_KEY]);
        CGFloat scale =  [info[SCALE_KEY] floatValue];
        CGRect frame = CGRectFromString(self.subTemplateModel.img_frame);
        
        if (self.subTemplateModel.shapeType==IS_ShapeTypeSmall) {
            frame  = CGRectMake(offset.x/3, offset.y/3, frame.size.width, frame.size.height);
        }

        CGFloat W = frame.size.width * scale;
        CGFloat H = frame.size.height * scale;
        self.contentView.contentOffset=offset;
        self.contentView.contentSize =CGSizeMake(W,H);
        self.imageBtnView.frame =CGRectMake(0, 0,W,H);
        [self.contentView setMinimumZoomScale:0.5];


    }else{
        self.contentView.contentOffset=CGPointZero;
        self.contentView.contentSize =rect.size;
        self.imageBtnView.frame =CGRectMake(0, 0, rect.size.width, rect.size.height);
    }

    //1.曲线

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
-(UIScrollView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIScrollView alloc]initWithFrame:self.bounds];
        float minimumScale = _contentView.frame.size.width / MRScreenWidth *2.5;
        [_contentView setMaximumZoomScale:2];
        [_contentView setZoomScale:minimumScale];
        _contentView.delegate=self;
    }
    return _contentView;

}
-(IS_EditLoadingView *)loadingView{
    
    if (!_loadingView) {
        _loadingView = [[IS_EditLoadingView alloc]initWithFrame:self.bounds];
        _loadingView.uploadState =IS_ImageUploadStateNone;
        WEAKSELF;
        [_loadingView addActionBlock:^(id objectData, NSInteger buttonTag) {
            [weakSelf btnAction:weakSelf.imageBtnView];
        }];
    }
    return _loadingView;

}

#pragma mark - 设置图片

- (void)setUpImageModel:(IS_ImageModel*)imageModel{
    if (imageModel) {
        [imageModel uploadUnderlyingImageAndNotify];
    }
}

-(void)setSubTemplateModel:(IS_EditSubTemplateModel *)subTemplateModel{
    
    _subTemplateModel = subTemplateModel;
    IS_ImageModel * imgModel = subTemplateModel.imageModel;

   
#pragma mark - 处理类型
    switch (subTemplateModel.sub_type) {
        case IS_SubTypeImage:
        {
            
            
            if (imgModel.img) {
                //1.有数据的
                [self.loadingView hideLoading];
                [self setImageViewData:imgModel.img isAdjust:YES isExchage:NO];
                [self setUpImageModel:imgModel];
                
            }else if (imgModel.img_place_url){
                
                [self.imageBtnView sd_setImageWithURL:[NSURL URLWithString:imgModel.img_place_url]  forState:UIControlStateNormal placeholderImage:nil options:SDWebImageProgressiveDownload];
                _imageBtnView.imageView.contentMode = UIViewContentModeScaleAspectFill;
                
                
            }else if (imgModel.img_place_name){
                //3.有占位图片
                _loadingView.hidden = NO;
                
                NSString * path = [[NSBundle mainBundle]pathForResource:imgModel.img_place_name ofType:@"jpg"];
                if (!path) {
                    path = [[NSBundle mainBundle]pathForResource:imgModel.img_place_name ofType:@"png"];
                }
                UIImage * image = [UIImage imageWithContentsOfFile:path];
                [self.imageBtnView setImage:image forState:UIControlStateNormal];
                _imageBtnView.imageView.contentMode = UIViewContentModeScaleAspectFill;
                
                
                
            }
            //2.增加手势
            [self addGestureRecognizers];
            break;

          //
        }
                case IS_SubTypeText:{
#pragma mark - 处理字体

            NSInteger num = (subTemplateModel.shapeType==IS_ShapeTypeLarge)?1:3;
            UIFont * font = [UIFont systemFontOfSize:20]; //[UIFont systemFontOfSize:25];
            NSString * fontName  =EN_FONT;
                    
#pragma mark - 字体类型
                    if (self.subTemplateModel.text_info[TEXT_FONT_KEY]) {
                        fontName = self.subTemplateModel.text_info[TEXT_FONT_KEY];
                    }else{
//                        fontName = @"Raleway-Thin";//HelveticaNeue
                    }
#pragma mark - 字体大小
                    if (self.subTemplateModel.text_info[TEXT_SIZE_KEY]) {
                        CGFloat fontSize = [self.subTemplateModel.text_info[TEXT_SIZE_KEY] floatValue];
                        font = [UIFont fontWithName:fontName size:fontSize/num];
                    }else{
                        font = [UIFont fontWithName:fontName size:20/num]; //[UIFont systemFontOfSize:25];

                    }
                    
                    [self.imageBtnView.titleLabel setFont:font];
                    
#pragma mark - 字体位置
                    if ([self.subTemplateModel.text_info[TEXT_POSITION_KEY] isEqualToString:@"left"]) {
                        self.imageBtnView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    }else if ([self.subTemplateModel.text_info[TEXT_POSITION_KEY] isEqualToString:@"right"]){
                        self.imageBtnView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                        
                    }else{
                        self.imageBtnView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

                    }
                    
#pragma mark - 字体颜色
                    if (self.subTemplateModel.text_info[TEXT_COLOR_KEY]) {
                        UIColor * hexColor = [UIColor colorWithHexString:self.subTemplateModel.text_info[TEXT_COLOR_KEY]];
//                        UIColor * hexColor = [UIColor colorWithHex:self.subTemplateModel.text_info[TEXT_COLOR_KEY] int  alpha:1];
                        [self.imageBtnView setTitleColor:hexColor forState:UIControlStateNormal];

                    }else{
                        [self.imageBtnView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

                    }
                    
                    

                    
                    
                    
                 
                    
            self.imageBtnView.titleLabel.numberOfLines=0;
            NSString * text =subTemplateModel.text?subTemplateModel.text:subTemplateModel.text_place_string;
            [self.imageBtnView setTitle:text forState:UIControlStateNormal];
            self.imageBtnView.imageView.backgroundColor = [UIColor clearColor];

                    
                    
//            self.imageBtnView.titleLabel.textAlignment = NSTextAlignmentLeft;
            _loadingView.hidden = YES;
            break;
        }

        case IS_SubTypeDecorate:{
            
            
//            self.imageBtnView.imageView.contentMode =UIViewContentModeScaleToFill;
//            UIImage * img = [UIImage stretchableImage:[UIImage imageNamed:imgModel.img_place_name] edgeInsets:UIEdgeInsetsZero];
            [self.imageBtnView setImage:[UIImage imageNamed:imgModel.img_place_name] forState:UIControlStateNormal];
            self.imageBtnView.imageView.backgroundColor = [UIColor clearColor];
            self.imageBtnView.userInteractionEnabled=NO;
            _loadingView.hidden = YES;
             break;
        }
           

            
        default:
            _loadingView.hidden = YES;

            break;
    }
    
#pragma mark - 处理 loading
    
    if (subTemplateModel.shapeType==IS_ShapeTypeSmall) {
        _loadingView.stateBtn.width=self.width/3;
        _loadingView.stateBtn.height=self.height/3;
        _loadingView.stateBtn.center = _loadingView.center;
        
        
    } else{
        _loadingView.width=self.width;
        _loadingView.height=self.height;
        
    }
   
    
#pragma mark - 处理曲线
    
    
    
    if (self.subTemplateModel.img_mask_name) {
        UIImage *_maskingImage = [UIImage imageNamed:self.subTemplateModel.img_mask_name];
            CAShapeLayer *_maskingLayer = [[CAShapeLayer alloc] init];
        _maskingLayer.frame = self.bounds;
        [_maskingLayer setContents:(id)[_maskingImage CGImage]];
         self.layer.masksToBounds = YES;
        self.layer.mask = _maskingLayer;
        [self setNeedsLayout];
    }
    
    //4.
#pragma mark - 设置 tag 等
        self.tag = subTemplateModel.sub_tag;
        self.imageBtnView.tag=subTemplateModel.sub_tag;
        //3.
        self.isLongPress =NO;
        [self setClipsToBounds:YES];
    
    

    

  

}
#pragma mark - 点击按钮
- (void)btnAction:(UIButton *)btn{
    
    self.transform =CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration:.2 animations:^{
        self.transform =CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        if (self.subTemplateModel.sub_type==IS_SubTypeImage&&!self.subTemplateModel.imageModel.img) {
            [[NSNotificationCenter defaultCenter]postNotificationName:IS_EDIT_IMAGE_DID_SELECT object:self];

        }

        if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewDidBtnAction:)]) {
            [self.imageViewDelegate IS_SenceCreateImageViewDidBtnAction:self];
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
    
       if (self.subTemplateModel.sub_type==IS_SubTypeImage&&self.subTemplateModel.imageModel.img) {
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
        
        //3.旋转
        
        _inner_rotationPressGestureRecognizer = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleInnerRotationGesture:)];
        _inner_rotationPressGestureRecognizer.delegate =self;
        [self.imageBtnView addGestureRecognizer:_inner_rotationPressGestureRecognizer];
        
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
            [self addGestureNotification:YES];
            self.contentView.scrollEnabled=NO;
            //3
            [UIView
             animateWithDuration:0.3
             animations:^{
                 self.transform = CGAffineTransformMakeScale(1.0,1.0);
                 self.alpha=.5;
             }
             completion:nil];
             break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            self.isLongPress = NO;
            [self addGestureNotification:NO];
            self.contentView.scrollEnabled=YES;

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

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:{
          
            self.center = CGPointMake(self.center.x + translation.x,
                                      self.center.y + translation.y);
            [pan setTranslation:CGPointZero inView:self];
            if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewPanning:state:)]) {
                [self.imageViewDelegate IS_SenceCreateImageViewPanning:self state:UIGestureRecognizerStateChanged];
            }
            break;
        
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            [self addGestureNotification:NO];
            if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewPanning:state:)]) {
                [self.imageViewDelegate IS_SenceCreateImageViewPanning:self state:UIGestureRecognizerStateEnded];
            }
         break;
        }
           
            
        default:
            break;
    }
           
    
}

#pragma mark - 内部选旋
//static float degree=0;
// 处理旋转手势
- (void) handleInnerRotationGesture:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{ //1.取得视图
    UIView *view = rotationGestureRecognizer.view;
    
    
    switch (rotationGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self addGestureNotification:YES];
            self.contentView.userInteractionEnabled=NO;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            
            
//            CGFloat radians = atan2f(view.transform.b, view.transform.a);
//            degree+=rotationGestureRecognizer.rotation;
//         
//            NSLog(@"degrees:%@",@(rotationGestureRecognizer.rotation));

            [rotationGestureRecognizer setRotation:0];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:{
//            UIImage * i =  [UIImage rotateImage:self.imageBtnView.currentImage angleDegrees:degree];
//            [self setImageViewData:i isAdjust:NO isExchage:NO];
            self.contentView.userInteractionEnabled=YES;
//            self.imageBtnView.frame
         break;
        }

            
        default:
            break;
    }
    
    
    
   
   
}

#pragma mark  - UIGestureRecognizer-Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if([gestureRecognizer isEqual:self.contentView.panGestureRecognizer]) {
        
        return YES;
    }else  if([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        
       return self.isLongPress;
    }else if ([gestureRecognizer isEqual:_inner_rotationPressGestureRecognizer]){
        return !self.contentView.dragging;
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
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    [self addGestureNotification:YES];
    
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self addGestureNotification:NO];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self addGestureNotification:NO];
    [self scrollViewDidEndChangeOffset:scrollView.contentOffset contentSize:scrollView.contentSize];

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (decelerate) {
    }else{
        [self addGestureNotification:NO];

    }
  //
    [self scrollViewDidEndChangeOffset:scrollView.contentOffset contentSize:scrollView.contentSize];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
    [self addGestureNotification:NO];
    
//    CGPoint tranlate = point;
     CGSize size = scrollView.contentSize;
    CGRect frame = CGRectFromString(self.subTemplateModel.img_frame);
    CGFloat ssss = size.height/frame.size.height;
//    CGFloat rotate = 0;
    
    NSDictionary * dic = [NSDictionary dictionary];
    IS_ImageModel * imgModel = self.subTemplateModel.imageModel;
    if (imgModel.img_info[TRANSLATE_KEY]) {
         dic = @{TRANSLATE_KEY:imgModel.img_info[TRANSLATE_KEY],
                               SCALE_KEY:@(ssss),
                               ROTATION_KEY:imgModel.img_info[ROTATION_KEY]
                               };
    }else{
        dic = @{SCALE_KEY:@(ssss)};
    }
    
  
    imgModel.img_info = [NSMutableDictionary dictionaryWithDictionary:dic];
    self.subTemplateModel.imageModel = imgModel;
    [self.imageViewDelegate IS_SenceCreateImageViewDidDealImage:self.subTemplateModel];
    
//    [self scrollViewDidEndChangeOffset:scrollView.contentOffset contentSize:scrollView.contentSize];



}
#pragma mark - 根据移动后 img_info 改变

- (void)scrollViewDidEndChangeOffset:(CGPoint)offset
                         contentSize:(CGSize)contentSize{
 
    
    CGPoint point = offset;
    CGSize size = contentSize;
    if ([self.imageViewDelegate respondsToSelector:@selector(IS_SenceCreateImageViewDidDealImage:)]) {
        
        CGPoint tranlate = point;
        CGRect frame = CGRectFromString(self.subTemplateModel.img_frame);
        CGFloat scale = size.height/frame.size.height;
        CGFloat rotate = 0;
        NSDictionary * dic = @{TRANSLATE_KEY:NSStringFromCGPoint(tranlate),
                               SCALE_KEY:@(scale),
                               ROTATION_KEY:@(rotate)
                               };
        self.subTemplateModel.imageModel.img_info = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.imageViewDelegate IS_SenceCreateImageViewDidDealImage:self.subTemplateModel];
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
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}



@end
