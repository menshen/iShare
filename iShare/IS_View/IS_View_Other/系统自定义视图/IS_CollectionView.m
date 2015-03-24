#import "IS_CollectionView.h"

@interface IS_CollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@end

@implementation IS_CollectionView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //
        [self setupCollectionView];
    }
    return self;
}
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupCollectionView];
}
#pragma mark - UICollectionView
-(void)setupCollectionView{
    
    
    _commonLayout = [[UICollectionViewFlowLayout alloc]init];
    _commonLayout.itemSize =CGSizeZero;
    _commonLayout.minimumLineSpacing = 0;
    _commonLayout.minimumInteritemSpacing = 0;
    _commonLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_commonLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.pagingEnabled = YES;
    [self addSubview:_collectionView];
    
    
    


}
- (void)setupCollectionViewRegisterClass:(NSString *)className
                                   isNib:(BOOL)isNib
                                isHeader:(BOOL)isHeader{
    
    if (!isHeader) {
        if (isNib) {
            UINib * nib = [UINib nibWithNibName:className bundle:[NSBundle mainBundle]];
            [_collectionView registerNib:nib forCellWithReuseIdentifier:className];
        }else{
            [_collectionView registerClass:NSClassFromString(className) forCellWithReuseIdentifier:className];
            
        }
    }else{
        if (isNib) {
            UINib * nib = [UINib nibWithNibName:className bundle:[NSBundle mainBundle]];
            [_collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:className];
        }else{
            [_collectionView registerClass:NSClassFromString(className) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:className];
        }
    
    }
    
    

    
}
#pragma mark 
- (void)setupScrollStateAction:(IS_CollectionViewScrollStateAction)scrollStateAction{
    self.scrollStateAction = scrollStateAction;
}


#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{return 1;}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.c_datasource.count;//;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.c_Delegate) {
        [self.c_Delegate IS_CollectionViewDidSelectItem:indexPath];
    }
}
#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollStateAction) {
        self.scrollStateAction(@(YES));
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.scrollStateAction) {
        self.scrollStateAction(@(YES));
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.scrollStateAction) {
        self.scrollStateAction(@(NO));
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (self.scrollStateAction) {
        self.scrollStateAction(@(NO));
    }
}
@end
