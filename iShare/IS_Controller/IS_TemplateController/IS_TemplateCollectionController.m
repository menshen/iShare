

#import "IS_TemplateCollectionController.h"
#import "IS_TemplateSheetView.h"
@interface IS_TemplateCollectionController ()
@property (nonatomic,strong)UIImageView * bottomView;
@end

@implementation IS_TemplateCollectionController{
    
    NSMutableArray * _btnArray;
    UIButton * _selectBtn;

}
#define OVERLAP_WINDOW_H (ScreenHeight/2-150)
#define BOTTOM_SHEET_VIEW_HEIGHT 50
#define TITLE_KEY @"title"
#define IMG_KEY   @"img"
#define BOTTOM_BTN_WIDTH ScreenWidth/5
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * headerView= [[UIView alloc]initWithFrame:CGRectMake(0, OVERLAP_WINDOW_H, ScreenWidth, 20)];
    headerView.backgroundColor = IS_SYSTEM_WHITE_COLOR;
    [self.view addSubview:headerView];
    
    self.collectionview.frame = CGRectMake(0, OVERLAP_WINDOW_H, ScreenWidth, ScreenHeight-OVERLAP_WINDOW_H-BOTTOM_SHEET_VIEW_HEIGHT);
    [self setupBottomView];

}
- (void)setupBottomView{
    
    
    _btnArray = [NSMutableArray array];
    
    _bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0,ScreenHeight- BOTTOM_SHEET_VIEW_HEIGHT, ScreenWidth, BOTTOM_SHEET_VIEW_HEIGHT)];
    _bottomView.userInteractionEnabled = YES;
    _bottomView.image = [UIImage resizedImage:@"IS_Toolbar_up"];
    [self.view addSubview:_bottomView];
    
    //1.5个数组
    NSArray * btn_infos =@[@{TITLE_KEY:@"",IMG_KEY:@"bottom_template_icon_cancel"},
                           @{TITLE_KEY:@"纯图",IMG_KEY:@""},
                           @{TITLE_KEY:@"少字",IMG_KEY:@""},
                           @{TITLE_KEY:@"多字",IMG_KEY:@""},
                           @{TITLE_KEY:@"",IMG_KEY:@"bottom_template_icon_comfire"}];
    for (int i = 0; i<5; i++) {
        CGRect frame = CGRectMake(BOTTOM_BTN_WIDTH * i, 0, BOTTOM_BTN_WIDTH, BOTTOM_SHEET_VIEW_HEIGHT);
        UIButton * btn = [[UIButton alloc]initWithFrame:frame];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:IS_SYSTEM_COLOR forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        NSDictionary * info = btn_infos[i];
        if ([info[IMG_KEY] length]==0&&info[TITLE_KEY]) {
            [btn setTitle:info[TITLE_KEY] forState:UIControlStateNormal];

        }else if ([info[TITLE_KEY] length]==0&&info[IMG_KEY]){
            [btn setImage:[UIImage imageNamed:info[IMG_KEY]] forState:UIControlStateNormal];

        }
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_btnArray addObject:btn];
        [_bottomView addSubview:btn];
        
    }
    
    UIButton * btn_3 = _btnArray[2];
    [self btnAction:btn_3];
    
    
}
-(void)btnAction:(UIButton *)btn{

    if (btn.tag==0||btn.tag==4) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        _selectBtn.selected = !_selectBtn.selected;
        btn.selected = YES;
        _selectBtn = btn;
    }
    
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)addDefault{
    
    NSMutableArray * arrayM = [NSMutableArray array];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_1];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_2];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_3];

    
    self.template_dataSource = arrayM;
    

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = self.template_dataSource [indexPath.row];
    IS_SenceTemplatePanModel * s =[[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
    
    if ([self.delegate respondsToSelector:@selector(IS_TemplateCollectionControllerDidSelectItem:)]) {
        [self.delegate IS_TemplateCollectionControllerDidSelectItem:s];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
  
    
}

@end
