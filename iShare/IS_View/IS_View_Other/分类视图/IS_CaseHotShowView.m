/*
 
 1. 首页的头部视图，为了视图的频繁调用，所以用UICollectionView的头部显示
 
    a.活动
    b.数据: 排行榜,热门,温情等等

 */


#import "IS_HomeHeaderView.h"
#import "IS_ActivityShowView.h"
#import "IS_ActionShowView.h"

@implementation IS_HomeHeaderView
{

    IS_ActivityShowView *_activityShowView;//活动滚动视图
    IS_ActionShowView * _actionShowView;//就是查看数据视图
}
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setup];
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
    [self setupActionShowView];
}
- (void)setupActivityShowView{

    _activityShowView = [[IS_ActivityShowView alloc]initWithFrame:CGRectMake(0, 0, IS_ACTIVITY_ITEM_WIDTH, IS_ACTIVITY_ITEM_HEIGHT)];
    [_activityShowView setupScrollStateAction:^(id result) {
        if (self.scrollStateAction) {
            self.scrollStateAction(result);
        }
    }];
    [self addSubview:_activityShowView];
}
- (void)setupActionShowView{
    
    NSString * IS_ActionShowView_ID = NSStringFromClass([IS_ActionShowView class]);
    _actionShowView = [[NSBundle mainBundle]loadNibNamed:IS_ActionShowView_ID owner:nil options:nil][0];
    _actionShowView.frame =CGRectMake(0, _activityShowView.bottom, IS_SHOWRANK_ITEM_WIDTH, IS_SHOWRANK_ITEM_HEIGHT);
//     = [[IS_ActionShowView alloc]initWithFrame];
    
    [self addSubview:_actionShowView];

}
@end
