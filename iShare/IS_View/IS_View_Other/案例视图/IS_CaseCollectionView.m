
#import "IS_CaseCollectionView.h"
#import "IS_CaseCollectionCell.h"
#import "IS_HomeHeaderView.h"
//#import "IS_TemplateActonSheet.h"
#import "IS_CaseModel.h"
#import "MJRefresh.h"

#define IS_HomeHeaderView_ID NSStringFromClass([IS_HomeHeaderView class])

@implementation IS_CaseCollectionView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.commonLayout.itemSize = CGSizeMake(IS_CASE_ITEM_WIDTH,IS_CASE_ITEM_HEIGHT);
        self.commonLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.commonLayout.minimumInteritemSpacing =0;
        self.commonLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, IS_ACTIVITY_ITEM_HEIGHT+IS_SHOWRANK_ITEM_HEIGHT);

        [self.collectionView setCollectionViewLayout:self.commonLayout];
        NSString * classStr = NSStringFromClass([IS_CaseCollectionCell class]);
        UINib * nib = [UINib nibWithNibName:classStr bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:classStr];
        [self.collectionView registerClass:[IS_HomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IS_HomeHeaderView_ID];
        self.collectionView.backgroundColor = kColor(247, 247, 247);
        self.collectionView.pagingEnabled = NO;
        
    }
    return self;
}
#pragma mark - 

- (void)reloadDataWithDataSource:(NSMutableArray*)arrayM{
    
    NSArray * a =[IS_CaseModel objectArrayWithKeyValuesArray:arrayM];
    [self.c_datasource addObjectsFromArray:a];
//    self.c_datasource = [NSMutableArray arrayWithArray:a];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellID = NSStringFromClass([IS_CaseCollectionCell class]);
    IS_CaseCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    IS_CaseModel * caseModel = self.c_datasource[indexPath.row];
    cell.caseModel = caseModel;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        IS_HomeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IS_HomeHeaderView_ID forIndexPath:indexPath];
        [headerView setupScrollStateAction:^(id result) {
            self.collectionView.scrollEnabled = ![result boolValue];
        }];
        reusableview = headerView;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    // Add observers
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
