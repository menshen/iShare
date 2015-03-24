
#import "IS_HomeController.h"
#import "IS_SencePageController.h"
#import "IS_CategoryView.h"
#import "IS_CaseCollectionView.h"

@interface IS_HomeController ()
@end

@implementation IS_HomeController{

    IS_CategoryView * _categoryView;
    IS_CaseCollectionView * _caseCollectionView;

}
-(void)viewDidLoad{
    //0.
    
    [super viewDidLoad];
    self.title = @"爱分享";
    [self setup];
    self.automaticallyAdjustsScrollViewInsets = NO;


}


#define IS_CategoryView_H 40
-(void)setup{
    
    [self setupCategoryView];
    [self setupCaseCollectionView];
    
    NSArray * itemTitles = @[@"婚礼",@"情侣",@"宠物",@"亲子",@"闺密",@"独享",@"旅行"];
    _categoryView.itemTitles = itemTitles;
    [_categoryView updateData];
    
}
- (void)setupCategoryView{
    
    _categoryView = [[IS_CategoryView alloc]initWithFrame:CGRectMake(0, IS_NAV_BAR_HEIGHT, ScreenWidth, IS_CategoryView_H)];
    [self.view addSubview:_categoryView];
  

}
-(void)setupCaseCollectionView{
    _caseCollectionView = [[IS_CaseCollectionView alloc]initWithFrame:CGRectMake(0, _categoryView.bottom, ScreenWidth, ScreenHeight-_categoryView.height-IS_NAV_BAR_HEIGHT-IS_MAIN_TABBAR_HEIGHT)];
    _caseCollectionView.c_datasource = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"2"]];
    [_caseCollectionView.collectionView reloadData];
    [self.view addSubview:_caseCollectionView];
}



@end
