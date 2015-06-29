

#import "IS_EditLoadingView.h"
#import "RTSpinKitView.h"

@interface IS_EditLoadingView()
@end

@implementation IS_EditLoadingView{

    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //0.
        self.backgroundColor = Color(0, 0, 0, 0.1);
        
        
      //

        //1.
        [self addSubview:self.loadingView];
        
        
         [self setupStateBtn];
        
        
        [self setupLoadingView];
        //2.
    }
    return self;
}
#pragma mark - Loading
-(RTSpinKitView *)loadingView{
    
    if (!_loadingView) {
        //RTSpinKitViewStyleWanderingCubes
        _loadingView = [[RTSpinKitView alloc]initWithStyle:RTSpinKitViewStylePlane color:IS_SYSTEM_COLOR];
        _loadingView.frame = CGRectMake(0, 0, 40, 40);
        _loadingView.center = CGPointMake(self.width/2, self.height/2);
//       _loadingView.hidden = YES;
//        [_loadingView startAnimating];

    }
    return _loadingView;
}
- (void)setupLoadingView{
    

    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
}
-(void)setupStateBtn{
    
    _stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateBtn.frame = CGRectMake(0, 0, 60, 30);
    _stateBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _stateBtn.center = CGPointMake(self.width/2, self.height/2);
    _stateBtn.hidden = YES;
    [_stateBtn addTarget:self action:@selector(stateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_stateBtn];
    
}
- (void)tapAction:(id)s{
    
    [self stateBtnAction:_stateBtn];
}
#pragma mark - 重新上传
-(void)stateBtnAction:(UIButton*)btn{
    switch (self.uploadState) {
        case IS_ImageUploadStateNone:{
            self.btnActionBlock(btn,IS_ImageUploadStateNone);
            break;
        }
        case IS_ImageUploadStateFailure:{
            self.btnActionBlock(btn,IS_ImageUploadStateFailure);

            break;
        }
            
            
        default:
            break;
    }
}


#pragma mark - 状态 -1.提示上传 2.失败重新上传
-(void)setUploadState:(IS_ImageUploadState)uploadState{
    // [self.loadingView removeFromSuperview];
    
    _uploadState = uploadState;
    switch (uploadState) {
            
        case IS_ImageUploadStateNone:
        {
            [self showUploadState];
            break;
        }
        case IS_ImageUploadStateing:
        {
            [self showLoading];
            //            [self.loadingView startAnimating];
            break;
        }
        case IS_ImageUploadStateDone:
        {
            [self hideLoading];
            break;
        }
        case IS_ImageUploadStateFailure:
        {
            [self showFailureState];
            
            break;
        }
            
            
        default:
            break;
    }
    
}
#pragma mark - 上传
#define FAILURE_ICON @"edit_icon_failure"
#define UPLOAD_TIP_ICON @"edit_icon_upload_tip"
- (void)showUploadState{

    [_stateBtn setImage:[UIImage imageNamed:UPLOAD_TIP_ICON] forState:UIControlStateNormal];
    _stateBtn.hidden =NO;
    self.hidden = NO;

   self.loadingView.hidden=YES;
}
- (void)showFailureState{
    [_stateBtn setImage:[UIImage imageNamed:FAILURE_ICON] forState:UIControlStateNormal];
    _stateBtn.hidden =NO;
     self.hidden = NO;
    self.loadingView.hidden=YES;

}

#pragma mark - 展示隐藏 loading
-(void)showLoading{
    
    self.hidden = NO;
    self.loadingView.hidden=NO;
    [self.loadingView startAnimating];

    _stateBtn.hidden = YES;
    

}
- (void)hideLoading{
    self.hidden = YES;
    _stateBtn.hidden = YES;
    self.loadingView.hidden=YES;
    [self.loadingView stopAnimating];
}
@end
