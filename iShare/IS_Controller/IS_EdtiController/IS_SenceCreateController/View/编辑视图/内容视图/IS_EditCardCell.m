

#import "IS_EditCardCell.h"

@interface IS_EditCardCell()<IS_EditContentViewDelegate>


@end

@implementation IS_EditCardCell
#pragma mark - 数据
-(void)setSenceTemplateModel:(IS_EditTemplateModel *)senceTemplateModel{

    _senceTemplateModel = senceTemplateModel;
    
    //1,大视图 ,小视图
    CGRect frame = CGRectZero;
    if (self.senceTemplateModel.senceTemplateShape==IS_SenceTemplateShapeCard) {
        //a.尺寸

        frame  = CGRectMake((self.width-IS_CARD_ITEM_WIDTH)/2, 30, IS_CARD_ITEM_WIDTH, IS_CARD_ITEM_HEIGHT);
        //b,
        self.close_btn.hidden=YES;
    }else{
//
        frame = CGRectMake(0, 0, IS_CARD_LITTER_ITEM_WIDTH, IS_CARD_LITTER_ITEM_HEIGHT);
        
        //b
        self.close_btn.hidden=NO;
    }
    self.senceCreateEditView.frame =frame;
    self.senceCreateEditView.senceTemplateModel=senceTemplateModel;
    self.senceCreateEditView.backgroundColor = [UIColor whiteColor];

    
    

    
    //3.
   
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //0
        [self setupEditView];
        [self setupCloseBtn];

    }
    return self;

}
#pragma mark - 主要编辑视图
- (void)setupEditView{

    _senceCreateEditView = [[IS_EditContentView alloc]initWithFrame:CGRectZero];
    _senceCreateEditView.backgroundColor = [UIColor clearColor];
    _senceCreateEditView.delegate = self;
    [self.contentView addSubview:_senceCreateEditView];

}

#pragma mark - 删除按钮
- (void)setupCloseBtn{
    
    _close_btn = [[UIButton alloc]initWithFrame:CGRectMake(-5, -10, 20, 20)];
    [_close_btn setBackgroundImage:[UIImage imageNamed:@"IS_Edit_Close"] forState:UIControlStateNormal];
    [_close_btn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_close_btn];

}
#pragma mark - 委托方法
- (void)closeBtnAction:(UIButton *)sender{
    
    [self.delegate IS_EditCellDidDeleteAction:sender];

}

#pragma mark - 子视图交换后数据整理
-(void)IS_EditViewDidChangeDataAction:(id)itemData userinfo:(NSDictionary *)userinfo{
    
    if (!itemData) {
        return;
    }
    [self.delegate IS_EditCellDidDataChangeAction:itemData userinfo:userinfo];
   
}
#pragma mark - 子视图点击 1.图片点击(跳出选择图片控制器) 2.文字点击(文字处理控制器) 3.等等
-(void)IS_EditContentViewDidSelectItem:(id)itemData userinfo:(NSDictionary *)userinfo{
    //1.代理
    if (!itemData) {
        return;
    }
    
    [self.delegate IS_EditCellDidSelectItemAction:itemData userinfo:userinfo];

  }


@end
