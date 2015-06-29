#import "IS_WebContentController.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import "IS_WebCoverView.h"
#import "LXActionSheet.h"
#import "SocialTool.h"
#import "IS_WebNavigationBar.h"
@interface IS_WebContentController ()<UIWebViewDelegate,IS_WebCoverViewDelegate,IS_WebNavigationBarDelegate,LXActionSheetDelegate,UIScrollViewDelegate>

@property (strong,nonatomic)IS_WebCoverView * webCoverView;

/*!
 *  封面图
 */
@property (strong,nonatomic)IS_WebNavigationBar * titleView;

@end

@implementation IS_WebContentController
{
    UIWebView *_webView;

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
}
- (void)setupSubView{
    
    [self setupWebView];
    [self setupTitleView];
    [self setupCoverDetailView];
    [self loadAddress:_caseModel.url];
    
}
#pragma mark - 标题动作
- (void)setupTitleView{
    
    
    _titleView = [[NSBundle mainBundle]loadNibNamed:@"IS_WebNavigationBar" owner:nil options:nil][0];
    _titleView.frame = CGRectMake(0, 0, ScreenWidth, IS_NAV_BAR_HEIGHT);
    _titleView.delegate =self;
    [self.view addSubview:_titleView];
    
}


#pragma mark - 详情
- (void)setupCoverDetailView{
    
    _webCoverView = [[IS_WebCoverView alloc]initWithFrame:self.view.bounds];
    [_webCoverView setContentSize:CGSizeMake(self.view.bounds.size.width, ScreenHeight+10)];
    _webCoverView.coverDelegate = self;
    _webCoverView.caseModel = _caseModel;
    [self.view addSubview:_webCoverView];
    
    
    
}

#pragma mark - 详情


- (void)setupWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scalesPageToFit = YES;
    _webView.contentMode = UIViewContentModeRedraw;
    _webView.opaque = YES;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.delegate =self;
    _webView.y = IS_NAV_BAR_HEIGHT-20;
    _webView.height -=IS_NAV_BAR_HEIGHT-20;
    [self.view addSubview:_webView];

}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//
    
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    

}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

#pragma mark - 封面视图
-(void)IS_WebCoverViewDidBackAction:(id)result{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)IS_WebCoverViewPanning:(id)result{
    
    CGFloat Y = [result floatValue];
    [UIView animateWithDuration:.2 animations:^{
        _webView.y-=Y;
    }];
    
    
}
-(void)IS_WebCoverViewDidScroll:(id)result{

    _webCoverView.backgroundColor = Color(0, 0, 0, 0);
    [UIView animateWithDuration:.4 animations:^{
        
        _webCoverView.y = -ScreenHeight;

    } completion:^(BOOL finished) {
    }];
    
}
#pragma mark - 编辑动作
-(void)IS_WebNavigationBarDidEditAction:(id)result{
    
}
#pragma mark - 分享
-(void)IS_WebNavigationBarDidShareAction:(id)result{
    LXActionSheet * AS = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信对话" otherButtonTitles:@[@"微信朋友圈"]];
    [AS showInView:self.view];
}
- (void)didClickOnButtonIndex:(NSInteger )buttonIndex{
    
    NSInteger index = buttonIndex;
    SocialPlatformType type = SocialPlatformTypeNone;
    if (index==2) {
        return;
    }
    type = index;
      [SocialTool  socialToolPlatformWithURLString:_caseModel.url Title:_caseModel.title Des:_caseModel.title Image:[UIImage imageNamed:@"IS_icon-1"] PlatformType:type];
//    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:_caseModel.share_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//       
//    }];
    
   
    
}
#pragma mark  -
-(void)IS_WebNavigationBarDidBackAction:(id)result{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)backToRoot:(id)item{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 展开
- (void)IS_WebNavigationBarDidTitleAction:(id)result{
    [UIView animateWithDuration:0.5 animations:^{
        _titleView.y = 0;
        _webCoverView.y=0;
        
    } completion:^(BOOL finished) {
        _webCoverView.backgroundColor = Color(0, 0, 0, 0.3);

    }];
}
#pragma mark - NJKWebViewProgressDelegate
- (void)loadAddress:(NSString *)url{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
}


//-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
//{
//    [_progressView setProgress:progress animated:YES];
//    
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//}


@end
