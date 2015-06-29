#import "IS_CollectionView.h"

@interface IS_CollectionView()<UIGestureRecognizerDelegate>
@end

@implementation IS_CollectionView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupActionSheet];
        [self setupCollectionView];
    }
    return self;
}
-(void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupActionSheet];
    [self setupCollectionView];
}
#pragma mark - UICollectionView
-(void)setupCollectionView{
    
    _c_datasource = [NSMutableArray array];
    
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
- (void)showActionSheetAtView:(UIView *)view
              actonSheetBlock:(IS_CollectionViewActonSheetBlock)actonSheetBlock{
    
    self.actonSheetBlock = actonSheetBlock;
    UIView * contain_v =  [UIApplication sharedApplication].delegate.window.rootViewController.view;
    [contain_v addSubview:self];
}
#pragma mark - 初始化
- (void)setupActionSheet{
    
    self.backgroundColor = Color(0, 0, 0, 0.6);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissActionSheet)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    /*!
     *  显示变化的视图
     */
    
}
#pragma mark - 关闭
- (void)dismissActionSheet{
    
    /*!
     *  关闭变化的视图
     */
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]&&[touch.view isEqual:self]){
        return YES;
    }
    return NO;
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
