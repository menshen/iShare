


#import "IS_MineCaseCollectionView.h"
#import "IS_CaseCollectionCell.h"
#import "IS_MineCaseHeaderView.h"


@implementation IS_MineCaseCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.commonLayout.itemSize = CGSizeMake(IS_CASE_ITEM_WIDTH,IS_CASE_ITEM_WIDTH*1.5);
        self.commonLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.commonLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 35);
        
        [self.collectionView setCollectionViewLayout:self.commonLayout];
        
        
        [self setupCollectionViewRegisterClass:NSStringFromClass([IS_CaseCollectionCell class])
                                         isNib:YES
                                      isHeader:NO];
        
        
        
        [self setupCollectionViewRegisterClass:NSStringFromClass([IS_MineCaseHeaderView class])
                                         isNib:YES
                                      isHeader:YES];
        
//        NSString * classStr = NSStringFromClass([IS_CaseCollectionCell class]);
//        UINib * nib = [UINib nibWithNibName:classStr bundle:[NSBundle mainBundle]];
//        [self.collectionView registerNib:nib forCellWithReuseIdentifier:classStr];
        
//        
//        NSString * headclassStr = NSStringFromClass([IS_MineCaseHeaderView class]);
//        UINib * headerNIb =[UINib nibWithNibName:headclassStr bundle:[NSBundle mainBundle]];
//        [self.collectionView registerNib:headerNIb forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headclassStr];
        self.collectionView.backgroundColor = kColor(247, 247, 247);
        
        
        self.collectionView.pagingEnabled = NO;
        
        
        
    }
    return self;
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionDatasource.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary * dict = self.sectionDatasource[section];
    NSArray * arrayM = dict [@"datas"];
    return arrayM.count;//;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSDictionary * dict = self.sectionDatasource[indexPath.section];
    NSArray * arrayM = dict [@"datas"];
    
    IS_CaseCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IS_CaseCollectionCell class]) forIndexPath:indexPath];
    cell.caseType = IS_CaseCollectionTypeMineShare;
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
//    NSDictionary * dict = self.sectionDatasource[indexPath.section];
//    NSArray * arrayM = dict [@"datas"];
//    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        IS_MineCaseHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([IS_MineCaseHeaderView class]) forIndexPath:indexPath];
        reusableview = headerView;
    }
    
    
    return reusableview;
    
    
  
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.c_Delegate) {
        [self.c_Delegate IS_CollectionViewDidSelectItem:indexPath];
    }
}

@end
