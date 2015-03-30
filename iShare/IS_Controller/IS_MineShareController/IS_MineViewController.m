
#import "IS_MineViewController.h"
#import "IS_MineCaseCollectionView.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "IS_CaseModel.h"
#import "IS_WebContentController.h"

@interface IS_MineViewController ()<IS_CollectionViewDelegate>
@property (strong,nonatomic)IS_MineCaseCollectionView * mineCaseCollectionView;
@end

@implementation IS_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMineCaseCollectionView];
    [self.mineCaseCollectionView.collectionView.header beginRefreshing];
    self.mineCaseCollectionView.c_Delegate = self;
    
}
-(void)loadNetWork{

    
    [HttpTool postWithPath:GET_MINE_SHARE_DATA params:nil success:^(id result) {
        
        if (result) {
            NSArray * jsonarray  = result[DATA_KEY];
            _mineCaseCollectionView.sectionDatasource = [NSMutableArray arrayWithArray:jsonarray];
            [_mineCaseCollectionView.collectionView reloadData];
            [_mineCaseCollectionView.collectionView.header endRefreshing];

        }
        
    } failure:^(NSError *error) {
        [_mineCaseCollectionView.collectionView.header endRefreshing];

    }];

}
-(void)setupMineCaseCollectionView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = CGRectMake(0, IS_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-IS_NAV_BAR_HEIGHT-IS_MAIN_TABBAR_HEIGHT);
    _mineCaseCollectionView = [[IS_MineCaseCollectionView alloc]initWithFrame:frame];
    [self.view addSubview:_mineCaseCollectionView];
    
      
    
    WEAKSELF;
    [_mineCaseCollectionView.collectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadNetWork];
    }];
    

}
-(void)IS_CollectionViewDidSelectItem:(id)result{
    if (result) {
        
        NSIndexPath * indexPath = result;
        NSDictionary * dic =_mineCaseCollectionView.sectionDatasource[indexPath.section][DATA_KEY][indexPath.row];
        IS_CaseModel * caseModel = [[IS_CaseModel alloc]initWithDictionary:dic];
        IS_WebContentController * webView = [[IS_WebContentController alloc]init];
        
        caseModel.url = [NSString stringWithFormat:@"%@%@#debug",BASEURL,caseModel.url];
        webView.caseModel = caseModel;
        
        
        
        
        [self.navigationController pushViewController:webView animated:YES];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
