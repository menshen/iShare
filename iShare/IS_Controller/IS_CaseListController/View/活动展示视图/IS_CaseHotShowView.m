/*
 
 1. 首页的头部视图，为了视图的频繁调用，所以用UICollectionView的头部显示
 
    a.活动
    b.数据: 排行榜,热门,温情等等

 */


#import "IS_CaseHotShowView.h"
#import "IS_CaseShowView.h"


@interface IS_CaseHotShowView()
/**
 *  @brief  集合视图
 */
//@property (strong,nonatomic)UICollectionView * collectionView;
///**
// *  @brief  数据源
// */
//@property (strong,nonatomic)NSMutableArray * datasource;

@end

@implementation IS_CaseHotShowView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)awakeFromNib{

    [super awakeFromNib];
    [self setup];

}
- (void)setupScrollStateAction:(IS_HomeHeaderViewScrollStateAction)scrollStateAction{
    self.scrollStateAction = scrollStateAction;
}
- (void)setup{
    [self setupActivityShowView];
}
- (void)setupActivityShowView{

    
    [self addSubview:self.showView];

}
-(void)setActionType:(NSString *)actionType{
    
    _actionType =actionType;
    self.showView.actionType =self.actionType;

}
-(IS_CaseShowView *)showView{

    if (!_showView) {
        _showView = [[IS_CaseShowView alloc]initWithFrame:CGRectMake(0, 0, IS_ACTIVITY_ITEM_WIDTH, IS_ACTIVITY_ITEM_HEIGHT)];
        _showView.c_Delegate =self;
//        [_showView setupScrollStateAction:^(id result) {
//            if (self.scrollStateAction) {
//                self.scrollStateAction(result);
//            }
//        }];
    }
    return _showView;
    
}
-(void)IS_CollectionViewDidSelectItem:(id)result{
    if (self.didSelectBlock) {
        self.didSelectBlock(result);
    }
}
- (void)addActionWithSelectBlock:(DidSelectBlock)didSelectBlock{
    self.didSelectBlock = didSelectBlock;
}
@end
