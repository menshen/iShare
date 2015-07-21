//
//  IS_CaseKindViewController.m
//  iShare
//
//  Created by wusonghe on 15/5/28.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_CaseKindListController.h"
#import "IS_CaseCollectionCell.h"
#import "IS_CaseModel.h"
#import "IS_WebContentController.h"
#import "AFHTTPRequestOperationManager.h"
#import "IS_CaseHotShowView.h"
#import "MBProgressHUD.h"
#import "KVNProgress.h"
#import "IS_KindBanner.h"
#import "NSObject+FBKVOController.h"
#import "IS_CaseBannerModel.h"
#import "IS_KindListCell.h"

@interface IS_CaseKindListController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) BouncePresentAnimation *presentAnimation;
@property (nonatomic, strong) NormalDismissAnimation *dismissAnimation;
@property (nonatomic, strong) SwipeUpInteractiveTransition *transitionController;

@property (strong,nonatomic)UIActivityIndicatorView * activityIndicatorView;
@property (assign,nonatomic)CGFloat headerHeight;
@property (assign,nonatomic)BOOL willDismiss;
@property (assign,nonatomic)BOOL hasmore;
@property (copy,nonatomic)ADLivelyTransform  transformBlock;
@property (strong,nonatomic)NSIndexPath * curIndexPath;




@end

@implementation IS_CaseKindListController{
    
    NSInteger _curpage;
    FBKVOController* _KVOController;
    CGPoint _lastScrollPosition;
    CGPoint _currentScrollPosition;
    
    
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    _presentAnimation = [BouncePresentAnimation new];
    _dismissAnimation = [NormalDismissAnimation new];
    _transitionController = [SwipeUpInteractiveTransition new];
    [self setup];
    
    if (![self.actionType isEqualToString:ACTIONTYPE_ALL]) {
        
//        if (!iPhone4_4S) {
//            [self cornerControllerWitCornerRadius];
//
//        }else{
//            UIImageView* _mainView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//            _mainView.userInteractionEnabled = YES;
//            _mainView.backgroundColor = IS_SYSTEM_WHITE_COLOR;
        
            self.view.clipsToBounds = YES;
            self.view.layer.cornerRadius = 4;
            
            
            
//            [self.view insertSubview:_mainView belowSubview:self.collectionView];
//        }
       
    }
   
    
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.frame=CGRectMake(0, 0, ScreenWidth, self.view.height);

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"kind_icon_arrow_down" highlightedIcon:@"kind_icon_arrow_down" target:self action:@selector(dismissAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"kind_icon_add" highlightedIcon:@"kind_icon_add" target:self action:@selector(creatAction:)];

    
    if (![self.actionType isEqualToString:ACTIONTYPE_ALL]) {
        
       
        self.navigationController.navigationBarHidden = YES;

        [self  adjustStateWithContentOffset:self.collectionView];
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    if (![self.actionType isEqualToString:ACTIONTYPE_ALL]) {
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];;

    }
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [self.navigationController.navigationBar setBarTintColor:IS_MAIN_NAV_COLOR];
    }
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;



}

-(void)setup{
    
   
    [self setupData];
    [self setupListType];
    [self setupCollectionView];
    [self.collectionView.footer beginRefreshing];
    
    
}
#pragma mark - 初始化数据
- (void)setupData{
    _headerHeight = [self.actionType isEqualToString:ACTIONTYPE_ALL]?180:280;
    _curpage = 1;
    _hasmore= YES;
}
#pragma mark - 类型


- (void)setupListType{
    
    
  
    
    switch (self.listType) {
        case CaseBannerTypeNone:
        {
            [self.collectionView addSubview:self.caseBanneScrollView];
            _headerHeight = 180;
            break;
        }
        case CaseBannerTypeCategory:
        {
            [self.collectionView addSubview:self.kindBanner];
            self.kindBanner.actionType = self.actionType;
            self.kindBanner.listType = self.listType;
            _headerHeight = 280;
            break;
        }
        case CaseBannerTypeTopic:
        {
            
           
            self.kindBanner.topicModel = self.topicModel;
            [self.collectionView addSubview:self.kindBanner];
            self.kindBanner.actionType = self.actionType;
            self.kindBanner.listType = self.listType;
            _headerHeight = TOPIC_VIEW_H;
            
            break;
        }
        default:
        break;
    }
    
}



- (void)dismissAction:(id)sender{
    
   
    
    if ([self isPush]) {
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        self.navigationController.navigationBarHidden = NO;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}
- (void)creatAction:(id)sender{
 
    [self dismissAction:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:WEBVIEW_CREATE_BTN_ACTION object:nil];

}

#define IS_KIND_SECTION_TOP 12
#define IS_KIND_SECTION_SLIDE 12

#define IS_KIND_INTERITEM_SPACING 11
#define IS_KIND_LINE_SPACING 11


- (void)setupLayout{
    
    
    
    CGFloat MARGIN = IS_HOME_LINE_MARGIN;
    self.commonLayout.itemSize  = CGSizeMake(IS_HOME_CELL_W, IS_HOME_CELL_H);
    self.commonLayout.sectionInset = UIEdgeInsetsMake(MARGIN+_headerHeight, 0,0 , 0);
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.commonLayout.minimumInteritemSpacing = 0;
    self.commonLayout.minimumLineSpacing = MARGIN;
    

  
    

    
}
-(void)setupCollectionView{
    
    [super setupCollectionView];
    [self setupLayout];
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    NSString * classStr = NSStringFromClass([IS_CaseCollectionCell class]);
    [self.collectionView registerClass:[IS_CaseCollectionCell class] forCellWithReuseIdentifier:classStr];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    WEAKSELF;
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadNetWork];
        
    }];
    if (self.listType ==CaseBannerTypeNone) {
        [self.collectionView addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadNetWork];

        }];
    }
    
    self.transformBlock = ADLivelyTransformTilt;
    
#pragma mark - 偏差
    if (self.listType!=CaseBannerTypeNone) {
        _KVOController = [FBKVOController controllerWithObserver:self];
        [_KVOController observe:self.collectionView keyPath:MJRefreshContentOffset options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            UICollectionView * collectView = object;
            if (collectView.isTracking||collectView.isDragging||collectView.isDecelerating) {
            
                [weakSelf adjustStateWithContentOffset:object];
            }
         
            
            
        }];
    }
   
    

    
    
}

#pragma mark - 专题分类头部
- (IS_KindBanner *)kindBanner{
    
    if (!_kindBanner) {
        _kindBanner = [[IS_KindBanner alloc] initWithFrame:CGRectMake(0,0,self.view.width, _headerHeight)];
        _kindBanner.backgroundColor = [UIColor blackColor];
        WEAKSELF;
        _kindBanner.didSelectBlock = ^ (id result){
            
            BtnActionType btnType = [result tag];
            if (btnType==BtnActionTypeCreate) {
                
                [weakSelf creatAction:result];
            }else if (btnType==BtnActionTypeDismiss){
                [weakSelf dismissAction:result];
                
            }
        };

    }
    return _kindBanner;
}
#pragma mark - 普通banner
-(IS_CaseBanneScrollView *)caseBanneScrollView{
    
    if (!_caseBanneScrollView) {
        
        _caseBanneScrollView = [[IS_CaseBanneScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, _headerHeight)];
        _caseBanneScrollView.backgroundColor = [UIColor blackColor];
        WEAKSELF;
        _caseBanneScrollView.didSelectBlock = ^ (id result){
        
            IS_CaseBannerModel *  caseBannerModel = result;
            if (caseBannerModel.actionType!=1) {
                IS_WebContentController * webView = [[IS_WebContentController alloc]init];
                webView.caseModel = [[IS_CaseModel alloc]initWithDictionary:[caseBannerModel.data keyValues]];
                webView.transitioningDelegate = weakSelf;
                [weakSelf.transitionController attachViewController:webView withAction:RZTransitionAction_Dismiss];
                
                SOUND_PLAY(SOUND_OPEN_CAF);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf presentViewController:webView animated:YES completion:nil];
                    
                });
            }else if (caseBannerModel.actionType==1){
//                IS_CaseKindListController * caseVC = [[IS_CaseKindListController alloc]init];
//                caseVC.actionType = caseBannerModel.action;
//                caseVC.listType = CaseBannerTypeTopic;
//                caseVC.title  = caseBannerModel.title;

            }
           

            
        };
    }
    return _caseBanneScrollView;
}
#pragma mark - 调整头部
- (void)adjustStateWithContentOffset:(UIScrollView *)scrollView
{
    
    
    // 当前的contentOffset
    CGFloat offsetY = self.collectionView.contentOffset.y;
    // 头部控件刚好出现的offsetY
    offsetY-=0.1;
    
    if (offsetY < 0) {
        CGFloat offset = -offsetY;
        
        
        _kindBanner.frame = CGRectMake(0,-offset, self.view.width, _headerHeight+offset);

        
    }
    else {
        _kindBanner.frame = CGRectMake(0,0, self.view.width, _headerHeight);


    }

    
#pragma mark - 
    if (self.listType!=CaseBannerTypeNone) {
        if (offsetY>0) {
            
            [self.navigationController setNavigationBarHidden:NO];
            [[UIApplication sharedApplication]setStatusBarHidden:NO];            
            if (offsetY<_headerHeight) {
                self.navigationController.navigationBar.alpha = 1-(_headerHeight-offsetY)/_headerHeight-0.1;

            }
            if (offsetY>_headerHeight-10) {
                self.navigationController.navigationBar.alpha=1;
                [self.navigationController setNavigationBarHidden:NO];
                [[UIApplication sharedApplication]setStatusBarHidden:NO];

            }
            
           
                
            
         
            
        }else{
            if (!_willDismiss) {
                self.navigationController.navigationBarHidden = YES;
                [[UIApplication sharedApplication]setStatusBarHidden:YES];


            }
            
        }
    }else{
    }
    
    
   
  
    

   
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentOffset.y<-100&&decelerate==YES) {
        _willDismiss = YES;
        SOUND_PLAY(SOUND_CONFIRM_CAF);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (![self.actionType isEqualToString:ACTIONTYPE_ALL]) {
                [self dismissAction:nil];

            }else{
          //  [self.collectionView.footer beginRefreshing];
            }
//
        });
    }
}







-(void)loadNetWork{
    
    self.kindBanner.shimmeringView.shimmering = YES;

#pragma mark - 加载数据
    if (!self.actionType||!_hasmore) {
        return;
    }
    if (self.datasource.count<=0) {
        _curpage = 1;
    }
    NSDictionary * param = @{PAGE_KEY:@(_curpage),
                             ACTIONTYPE_KEY:[self.actionType isEqualToString:ACTIONTYPE_ALL]?@"":self.actionType};
    

    
    
    
    [HttpTool postWithPath:GET_HOTLIST_DATA params:param success:^(id result) {
        
        __block NSMutableArray * jsonarray =[NSMutableArray array];

        [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
            
            BOOL A = ![result[DATA_KEY] isKindOfClass:[NSNull class]]&&
            [result[DATA_KEY][DATA_KEY] count]>0;
            
            if (result&&![result[DATA_KEY] isKindOfClass:[NSNull class]]&&result[DATA_KEY][DATA_KEY]&&A) {
                jsonarray  =[NSMutableArray arrayWithArray:result[DATA_KEY][DATA_KEY]];
                _curpage = [result[DATA_KEY][PAGE_KEY] integerValue]+1;
                _hasmore = [result[DATA_KEY][HAS_MORE_KEY] boolValue];
                
                
                NSString * totalViews = [NSString stringWithFormat:@"%@",result[DATA_KEY][TOTALVIEW_KEY]];
                if (self.listType==CaseBannerTypeCategory) {
                    [self.kindBanner.infoPeopleBtn setTitle:totalViews forState:UIControlStateNormal];
                }else if (self.listType==CaseBannerTypeTopic){
                    
                    [self.kindBanner.topicNumBtn setTitle:[NSString stringWithFormat:@" %@W ",totalViews] forState:0];
                }
               
                
                if (!_hasmore) {
                    [self.collectionView.footer endRefreshing];
                    [self.collectionView.header endRefreshing];
                }
            }
        } MainThreadBlock:^{
            [self reloadDataWithDataSource:jsonarray];

        }];
       
        

        
        
        
    } failure:^(NSError *error) {
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        
    }];
    
#pragma mark -加载banner数据
    
    if (self.listType==CaseBannerTypeNone) {
        
        
        [HttpTool postWithPath:GET_BANNER_DATA params:nil success:^(id result) {
            
            if ([result[RET_MSG] boolValue]) {
               NSArray * bannerInfos = result[DATA_KEY];

                
                NSArray * bannerModels = [IS_CaseBannerModel objectArrayWithKeyValuesArray:bannerInfos];
                self.caseBanneScrollView.datasourcce = [NSMutableArray array];
                [self.caseBanneScrollView.datasourcce addObjectsFromArray:bannerModels];
                
                [self.caseBanneScrollView reloadData];
            }
           
            
        } failure:^(NSError *error) {
            
        }];
       
    }
    
   
    
}

- (void)reloadDataWithDataSource:(NSMutableArray*)arrayM{
    
    NSArray * a =[IS_CaseModel objectArrayWithKeyValuesArray:arrayM];
    if (self.collectionView.header.isRefreshing) {
        self.datasource = [NSMutableArray arrayWithArray:a];
    }else{
        [self.datasource addObjectsFromArray:a];
        
        
    }
   
   
    
 
    
   
    [self.collectionView reloadData];
    [_activityIndicatorView stopAnimating];
    [self.collectionView.footer endRefreshing];
    [self.collectionView.header endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.kindBanner.shimmeringView.shimmering = NO;

    });
}



#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section    {
    
    return self.datasource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellID = NSStringFromClass([IS_CaseCollectionCell class]);
    IS_CaseCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    IS_CaseModel * caseModel = self.datasource[indexPath.row];
    cell.caseModel = caseModel;
    
    
    float speed = self.scrollSpeed.y;
    float normalizedSpeed = MAX(-1.0f, MIN(1.0f, speed/20.0f));
    if (_curIndexPath.row>indexPath.row) {
        normalizedSpeed=0;
    }
    BOOL shouldAnimate = YES;
    if (_transformBlock && shouldAnimate) {
        NSTimeInterval animationDuration = _transformBlock(cell.layer, normalizedSpeed);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
    }
    cell.layer.transform = CATransform3DIdentity;
    cell.layer.opacity = 1.0f;
    if (_transformBlock) {
        [UIView commitAnimations];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IS_CaseModel * caseModel = self.datasource[indexPath.row];
    
    IS_WebContentController * webView = [[IS_WebContentController alloc]init];
      webView.caseModel = [[IS_CaseModel alloc]initWithDictionary:[caseModel keyValues]];
    webView.transitioningDelegate = self;
    [self.transitionController attachViewController:webView withAction:RZTransitionAction_Dismiss];
    
    SOUND_PLAY(SOUND_OPEN_CAF);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:webView animated:YES completion:nil];

    });
}

- (CGPoint)scrollSpeed {
    return CGPointMake(_lastScrollPosition.x - _currentScrollPosition.x,
                       _lastScrollPosition.y - _currentScrollPosition.y);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _lastScrollPosition = _currentScrollPosition;
    _currentScrollPosition = [scrollView contentOffset];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _curIndexPath = [self.collectionView indexPathForItemAtPoint:scrollView.contentOffset];
    
}

- (IS_CaseCollectionCell *)getCaseCellWithIndexPath:(NSIndexPath *)indexPath{
    
    IS_CaseCollectionCell * cell =(IS_CaseCollectionCell*) [self.collectionView cellForItemAtIndexPath:indexPath];
    
    return cell;
    
}

#pragma mark  -动态
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{

    return self.presentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    

    return self.dismissAnimation;
}
-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transitionController.interacting ? self.transitionController : nil;
}
@end
