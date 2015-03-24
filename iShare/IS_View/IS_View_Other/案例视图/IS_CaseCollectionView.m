
#import "IS_CaseCollectionView.h"
#import "IS_CaseCollectionCell.h"
#import "IS_HomeHeaderView.h"
#import "IS_TemplateActonSheet.h"

#define IS_HomeHeaderView_ID NSStringFromClass([IS_HomeHeaderView class])

@implementation IS_CaseCollectionView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
       
        self.commonLayout.itemSize = CGSizeMake(IS_CASE_ITEM_WIDTH,IS_CASE_ITEM_HEIGHT);
        self.commonLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
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

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellID = NSStringFromClass([IS_CaseCollectionCell class]);
    IS_CaseCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    
    NSString * randomName = [NSString stringWithFormat:@"temp_%d",(int)random()%4+1];
    [cell.imgBtnView setImage:[UIImage imageNamed:randomName] forState:UIControlStateNormal];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    
}



@end
