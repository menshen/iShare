
#import "IS_MineViewController.h"
#import "IS_MineCaseCollectionView.h"

@interface IS_MineViewController ()
@property (strong,nonatomic)IS_MineCaseCollectionView * mineCaseCollectionView;
@end

@implementation IS_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMineCaseCollectionView];
    
}
-(void)setupMineCaseCollectionView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = CGRectMake(0, IS_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-IS_NAV_BAR_HEIGHT-IS_MAIN_TABBAR_HEIGHT);
    _mineCaseCollectionView = [[IS_MineCaseCollectionView alloc]initWithFrame:frame];
    [self.view addSubview:_mineCaseCollectionView];
    
    NSArray * jsonarray = [NSString objectFromJsonFilePath:@"mouth"];
    _mineCaseCollectionView.sectionDatasource = [NSMutableArray arrayWithArray:jsonarray];
    [_mineCaseCollectionView.collectionView reloadData];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
