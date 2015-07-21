#define ITEM_MARGIN 5 //间距
#define ITEM_W  ScreenWidth
#define ITEM_H ITEM_WIDTH*1.5 //高度

#import "IS_CaseShowView.h"
#import "IS_CaseHotShowCell.h"
#import "IS_EditPageControl.h"

@interface IS_CaseShowView()<UIScrollViewDelegate>
//1.页面视图
@property (strong,nonatomic)UIPageControl * pageControl;
@end

@implementation IS_CaseShowView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        self.backgroundColor = [UIColor clearColor];
        self.collectionView.backgroundColor = self.backgroundColor;
        
    }
    return self;
}
#define PAGE_CONTROL_MARGIN 10
-(UIPageControl *)pageControl{

    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(PAGE_CONTROL_MARGIN, self.height-PAGE_CONTROL_MARGIN-15, self.width-PAGE_CONTROL_MARGIN, 15)];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 1;

        
    }
    return _pageControl;
    
}
- (void)setup{
    self.c_datasource = [NSMutableArray array];
    self.commonLayout.itemSize = CGSizeMake(ITEM_W, self.collectionView.height);
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    UINib * nib = [UINib nibWithNibName:IS_CaseHotShowCell_ID bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:IS_CaseHotShowCell_ID];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.pageControl];
//

}
-(void)setActionType:(NSString *)actionType{
    _actionType =actionType;
    
    IS_CaseModel * defaultCase = [[IS_CaseModel alloc]init];
    self.c_datasource = [NSMutableArray arrayWithArray:@[defaultCase,defaultCase,defaultCase]];
    [self.collectionView reloadData];
//    [self loadNetWo.rk];
}
- (void)loadNetWork{

    NSDictionary * params = [[NSDictionary alloc]init];
    if (self.actionType&&self.actionType.length>0) {
        params = @{ACTIONTYPE_KEY:self.actionType};
    }else{
        params = @{ACTIONTYPE_KEY:ACTIONTYPE_ALL};
    }
    [HttpTool postWithPath:GET_RANKLIST_DATA params:params success:^(id result) {
        if (result[DATA_KEY][WEEKDATA_KEY]) {
            NSArray * arrayM = result[DATA_KEY][WEEKDATA_KEY];
            NSMutableArray * showCases = [NSMutableArray arrayWithArray:[IS_CaseModel objectArrayWithKeyValuesArray:arrayM]];
            if (showCases.count>=5) {
                self.c_datasource =[NSMutableArray arrayWithArray:[showCases subarrayWithRange:NSMakeRange(0, 5)]];
            }else{
                self.c_datasource =  [NSMutableArray arrayWithArray:showCases];
            }
            
            
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - UICollectionViewDelegate


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IS_CaseHotShowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_CaseHotShowCell_ID forIndexPath:indexPath];
    cell.caseModel  = self.c_datasource[indexPath.row];
    NSString * img = [NSString stringWithFormat:@"kind_image_%@_%d.jpg",self.actionType,0];
    cell.imageView.image = [UIImage imageNamed:img];
    cell.titleLab.text = ACTION_TYPE_DIC[self.actionType];
    cell.coverView.backgroundColor = Color(0, 0, 0, 0.1);
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self.c_Delegate IS_CollectionViewDidSelectItem:self.c_datasource[indexPath.row]];
}

@end
