
#import "IS_MineCaseController.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "IS_CaseModel.h"
#import "IS_WebContentController.h"
#import "IS_CaseCollectionCell.h"
#import "IS_MineCaseHeaderView.h"
#import "IS_AccountModel.h"
#import "IS_SenceEditTool.h"
#import "IS_HomeLoginController.h"
#import "IS_NavigationController.h"

@interface IS_MineCaseController ()
@end

@implementation IS_MineCaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView.header beginRefreshing];
    
}

- (void)setupLayout{
    
    
    
#define EDGE_INSET 5
  
        
        
    self.commonLayout.itemSize  = CGSizeMake(IS_CASE_ITEM_WIDTH, IS_CASE_ITEM_HEIGHT);
    self.commonLayout.sectionInset = UIEdgeInsetsMake(EDGE_INSET, EDGE_INSET, EDGE_INSET, EDGE_INSET);
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.commonLayout.minimumInteritemSpacing =EDGE_INSET;
    self.commonLayout.minimumLineSpacing = EDGE_INSET;
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.commonLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    
    
    [self setupCollectionViewRegisterClass:NSStringFromClass([IS_CaseCollectionCell class])
                                     isNib:YES
                                  isHeader:NO];
    
    
    
    [self setupCollectionViewRegisterClass:NSStringFromClass([IS_MineCaseHeaderView class])
                                     isNib:YES
                                  isHeader:YES];
    
    
    self.collectionView.backgroundColor = kColor(247, 247, 247);
    self.collectionView.pagingEnabled = NO;

}
-(void)setupCollectionView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super setupCollectionView];
    [self setupLayout];
    self.collectionView.frame = CGRectMake(0, IS_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-IS_NAV_BAR_HEIGHT-IS_MAIN_TABBAR_HEIGHT);
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    
    
     WEAKSELF;
    [UIScrollView addMJRefreshGIFWithMethod:^{
         [weakSelf loadNetWork];
    } Method:^{
         [weakSelf loadNetWork];
    } scrollView:self.collectionView];
   
   
    

}
-(void)loadNetWork{
    
    NSDictionary * params = [NSDictionary dictionary];
    
    if ([IS_AccountModel getToken]) {
        params = @{TOKEN:[IS_AccountModel getToken]};
        [HttpTool postWithPath:GET_MINE_SHARE_DATA params:params success:^(id result) {
            
            if ([result[RET_MSG] boolValue]) {
                NSArray * jsonarray  = result[DATA_KEY];
                self.sectionDatasource = [NSMutableArray arrayWithArray:jsonarray];
                [self.collectionView.collectionViewLayout invalidateLayout];
                [self.collectionView reloadData];
                
            }else{
               
                IS_HomeLoginController * homeLogin = [[IS_HomeLoginController alloc]init];
                 IS_NavigationController * nav = [[IS_NavigationController alloc]initWithRootViewController:homeLogin];
                [self presentViewController:nav animated:YES completion:nil];
            }
            [self.collectionView.header endRefreshing];
            [self.collectionView.footer endRefreshing];

        } failure:^(NSError *error) {
            [self.collectionView.header endRefreshing];
            [self.collectionView.footer endRefreshing];

            
        }];
    }else{
        //问他拿
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];

    }
    
  
    
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionDatasource.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary * dict = self.sectionDatasource[section];
    NSArray * arrayM = dict [DATA_KEY];
    return arrayM.count;//;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSDictionary * dict = self.sectionDatasource[indexPath.section];
    NSArray * arrayM = dict[DATA_KEY];
    IS_CaseCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IS_CaseCollectionCell class]) forIndexPath:indexPath];
    NSDictionary * dic = arrayM[indexPath.row];
    IS_CaseModel * caseModel = [[IS_CaseModel alloc]initWithDictionary:dic];
    caseModel.caseType = IS_CaseCollectionTypeMineShare;
    cell.caseModel = caseModel;
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    
      NSDictionary * dict = self.sectionDatasource[indexPath.section];
        UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        IS_MineCaseHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([IS_MineCaseHeaderView class]) forIndexPath:indexPath];
        headerView.titleLab.text = dict[@"mon"];
        reusableview = headerView;
    }
    
    
    return reusableview;
    
    
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic =self.sectionDatasource[indexPath.section][DATA_KEY][indexPath.row];
    IS_CaseModel * caseModel = [[IS_CaseModel alloc]initWithDictionary:dic];
    IS_WebContentController * webView = [[IS_WebContentController alloc]init];
    
//    caseModel.url = [NSString stringWithFormat:@"%@%@",BASEURL,caseModel.url];
    webView.caseModel = caseModel;

    [self.navigationController pushViewController:webView animated:YES];
}

@end
