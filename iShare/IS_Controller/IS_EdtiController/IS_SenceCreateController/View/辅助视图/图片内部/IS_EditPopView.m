

#import "IS_EditPopView.h"
@implementation IS_EditPopView{

    UIView * _editActionView;

    
}
-(instancetype)initWithFrame:(CGRect)frame
            popViewBtnAction:(IS_PopViewBtnAction)popViewBtnAction{

    
    
    if ((self = [self initWithFrame:frame])) {
        
        self.popViewBtnAction= popViewBtnAction;
        [self setupEditActionView];
    }
    return self;
   
}


- (void)setupEditActionView{
    
    _editActionView =  [[UIView alloc]initWithFrame:CGRectMake(40, 0, 220, 40)];//[[NSBundle mainBundle]loadNibNamed:@"IS_EditActionView" owner:nil options:nil][0];
 //
    _editActionView.backgroundColor = [UIColor blackColor];
    self.customView = _editActionView;
    [self addSubview:self.customView];
    
    [self setup4btn];

}
#define NUM  4
- (void)setup4btn{
    CGFloat WIDTH = _editActionView.width /NUM -20;
    NSArray * btnImgs =@[@"img_icon_exchange",@"img_icon_rotate",@"img_icon_zoom_in",@"img_icon_zoom_in"];
    for (int i = 0; i<NUM; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH * i+40, 0, WIDTH, _editActionView.height)];
        [btn setImage:[UIImage imageNamed:btnImgs[i]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editActionView addSubview:btn];
    }
}
- (void)btnAction:(UIButton *)sender{
    if (self.popViewBtnAction) {
        self.popViewBtnAction (sender);
    }
    
}
@end
