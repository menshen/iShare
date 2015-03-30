#import "IS_CaseCollectionCell.h"
#import "Masonry.h"
#import "View+MASAdditions.h"
#import "IS_Button.h"
#import "LXActionSheet.h"
@interface IS_CaseCollectionCell()<LXActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *readNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *editStateIcon;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (strong,nonatomic)UIImageView * editToolbar;

@end
@implementation IS_CaseCollectionCell


- (void)awakeFromNib {

    [super awakeFromNib];
    [self setupEditToolBar];
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
  

}
-(void)layoutSubviews{
    [self callBack];


}
-(void)dealloc{
//    [self removeObserver:self forKeyPath:@"caseModel.status"];
    [self callBack];
}

#pragma mark - 数据源
-(void)setCaseModel:(IS_CaseModel *)caseModel{

    _caseModel = caseModel;
    
    //0.标题
    self.titleLab.text = caseModel.title;
    //1.图片
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:caseModel.share_img] placeholderImage:IS_PLACE_IMG options:SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    //2.阅读量
    self.readNumLab.text = caseModel.uv;//[NSString stringWithFormat:@"阅读量 %@"];

    
    //3.类型
   
    switch (caseModel.caseType) {
        case IS_CaseCollectionTypeHome:
        {
            
            [self setupWithinHome];
            break;
        }
        case IS_CaseCollectionTypeMineShare:
        {
            
            [self setupWithinMineShare];
            
            
            break;
        }
            
            
        default:
            break;
    }

    
}

- (IBAction)editAction:(id)sender {
    
    [UIView animateWithDuration:.2 animations:^{
        _editToolbar.x= 0;
        _editToolbar.hidden = NO;
    }];
}
- (void)litterbtnAction:(UIButton*)sender {
    
    switch (sender.tag) {
        case 0:
            break;
        case 1:
            [self callDel];
            break;
        case 2:
            [self callBack];
            break;
            
        default:
            break;
    }
  
}
#pragma mark - 删除
- (void)callDel{
    LXActionSheet * actionSheet = [[LXActionSheet alloc]initWithTitle:@"是否删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确实" otherButtonTitles:nil];
    [actionSheet showInView:nil];
    

}
-(void)didClickOnButtonIndex:(NSInteger)buttonIndex{
    
}
#pragma mark - 收回
- (void)callBack{
    [UIView animateWithDuration:.2 animations:^{
        _editToolbar.x= -self.width;

    } completion:^(BOOL finished) {
         _editToolbar.hidden = YES;
    }];
}

- (void)setupEditToolBar{
    
    _editToolbar = [[UIImageView alloc]initWithFrame:CGRectMake(-self.width, _titleLab.y, self.contentView.width-10, _titleLab.height)];
    _editToolbar.userInteractionEnabled = YES;
    _editToolbar.backgroundColor = [UIColor whiteColor];
//    _editToolbar.image = [UIImage resizedImage:@"IS_Toolbar_up"];
    NSArray * infoArray = @[@{@"img":@"scene_icon_edit",@"title":@"编辑"},
                            @{@"img":@"scene_icon_trash",@"title":@"删除"},
                            @{@"img":@"bottom_template_icon_cancel",@"title":@""}];
    CGFloat WIDTH = _editToolbar.width/3;
    CGFloat HEIGHT = _editToolbar.height;
    for (int i =0; i<3; i++) {
        IS_Button * btn = [[IS_Button alloc]initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH, HEIGHT) ButtonPositionType:ButtonPositionTypeBothCenter];
        [btn setImage:[UIImage imageNamed:infoArray[i][@"img"]] forState:UIControlStateNormal];
        [btn setTitle:infoArray[i][@"title"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(litterbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:8];
        btn.tag = i;
        [_editToolbar addSubview:btn];
    }
    
    [self.contentView addSubview:_editToolbar];
    [_editToolbar setHighlighted:YES];
}

- (void)setupWithinMineShare{
    self.editBtn.hidden = NO;
}
- (void)setupWithinHome{
    self.editStateIcon.hidden = YES;
    self.editBtn.hidden = YES;
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.trailing.equalTo(self.mas_trailing).with.offset(-40);
        make.trailing.equalTo(self.mas_trailing).with.offset(0);
        
        
    }];
  

}
//+ (BOOL)requiresConstraintBasedLayout
//{
//    return YES;
//}
@end
