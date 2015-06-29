#define ITEM_MARGIN 5 //间距
#define ITEM_W  ScreenWidth
#define ITEM_H ITEM_WIDTH*1.5 //高度

#import "IS_CaseShowView.h"
#import "IS_CaseHotShowCell.h"

@interface IS_CaseShowView()<UIScrollViewDelegate>
//1.页面视图
@property (strong,nonatomic)UIPageControl * pageControl;
@end

@implementation IS_CaseShowView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        
    }
    return self;
}
- (void)setup{
    self.c_datasource = [NSMutableArray array];
    self.commonLayout.itemSize = CGSizeMake(ITEM_W, self.collectionView.height);
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    UINib * nib = [UINib nibWithNibName:IS_CaseHotShowCell_ID bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:IS_CaseHotShowCell_ID];
    self.collectionView.backgroundColor=kColor(247, 247, 247);

}
-(void)setActionType:(NSString *)actionType{
    _actionType =actionType;
    [self loadNetWork];
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
            self.c_datasource = [NSMutableArray arrayWithArray:[IS_CaseModel objectArrayWithKeyValuesArray:arrayM]];
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - UICollectionViewDelegate


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IS_CaseHotShowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_CaseHotShowCell_ID forIndexPath:indexPath];
    cell.caseModel  = self.c_datasource[indexPath.row];
    //id exhibitModel = self.exhibitDatasource[indexPath.row];

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self.c_Delegate IS_CollectionViewDidSelectItem:self.c_datasource[indexPath.row]];
}

@end
