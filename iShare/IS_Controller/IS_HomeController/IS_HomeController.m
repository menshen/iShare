#import "IS_HomeController.h"
#import "IS_SencePageController.h"
#import "IS_CategoryView.h"
#import "IS_CaseCollectionView.h"
#import "IS_WebContentController.h"
#import "IS_CaseModel.h"
#import "SocialTool.h"


@interface IS_HomeController ()<IS_CollectionViewDelegate>
@end

@implementation IS_HomeController{

    IS_CategoryView * _categoryView;
    IS_CaseCollectionView * _caseCollectionView;
    NSInteger _curpage;

}
-(void)viewDidLoad{
    //0.
    
    [super viewDidLoad];
    self.title = @"爱分享";
    [self setup];
    self.automaticallyAdjustsScrollViewInsets = NO;


}


-(void)setup{
    
    
     _curpage = 1;
    [self setupCaseCollectionView];
    [_caseCollectionView.collectionView.header beginRefreshing];
   
    
}




-(void)setupCaseCollectionView{
    _caseCollectionView = [[IS_CaseCollectionView alloc]initWithFrame:CGRectMake(0, _categoryView.bottom, ScreenWidth, ScreenHeight-_categoryView.height-IS_NAV_BAR_HEIGHT-IS_MAIN_TABBAR_HEIGHT)];
    _caseCollectionView.c_Delegate = self;
    WEAKSELF;
    [_caseCollectionView.collectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadNetWork];
    }];
    
    [_caseCollectionView.collectionView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadNetWork];

    }];

    [self.view addSubview:_caseCollectionView];

}


-(void)loadNetWork{
    
    
    NSDictionary * param = @{PAGE_KEY:@(_curpage)};
    [HttpTool postWithPath:GET_HOTLIST_DATA params:param success:^(id result) {
        
        if (result&&result[DATA_KEY][DATA_KEY]) {
            NSMutableArray * jsonarray  =[NSMutableArray arrayWithArray:result[DATA_KEY][DATA_KEY]];
            _curpage = [result[DATA_KEY][PAGE_KEY] integerValue]+1;
            [_caseCollectionView reloadDataWithDataSource:jsonarray];
        }
        [_caseCollectionView.collectionView.header endRefreshing];
        [_caseCollectionView.collectionView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        [_caseCollectionView.collectionView.header endRefreshing];
        [_caseCollectionView.collectionView.footer endRefreshing];

//        [_caseCollectionView.collectionView ins]
    }];
    
}
-(void)IS_CollectionViewDidSelectItem:(id)result{
    if (result) {
        
        NSIndexPath * indexPath = result;
        IS_CaseModel * caseModel =_caseCollectionView.c_datasource[indexPath.row];
        IS_WebContentController * webView = [[IS_WebContentController alloc]init];
        
        caseModel.url = [NSString stringWithFormat:@"%@%@#debug",BASEURL,caseModel.url];
        webView.caseModel = caseModel;
        
        
        
        
        [self.navigationController pushViewController:webView animated:YES];

    }

}


@end
