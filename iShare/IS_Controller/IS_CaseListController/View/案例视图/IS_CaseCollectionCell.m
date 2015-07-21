#import "IS_CaseCollectionCell.h"
#import "Masonry.h"
#import "View+MASAdditions.h"
#import "IS_Button.h"
#import "LXActionSheet.h"
@interface IS_CaseCollectionCell()
@property (strong, nonatomic)   UIImageView *imgView;
@property (strong, nonatomic)   UIView  *titleContentView;

@property (strong, nonatomic)   UILabel *titleLab;
@property (strong, nonatomic)   UIButton *readBtn;
@property (strong, nonatomic)   UILabel *readLab;

@property (strong, nonatomic)   UIButton *editBtn;

@property (weak, nonatomic)   UIButton *lockBtn;

@end
@implementation IS_CaseCollectionCell
- (void)awakeFromNib {

    [super awakeFromNib];

    self.editBtn.hidden = YES;
    self.lockBtn.hidden = YES;
    
  

}

#define TITLE_CONTENT_MARGIN 12
#define TITLE_CONTENT_H (iPhone5_5S?55:60)
#define TITLE_H TITLE_CONTENT_H/2
#define READ_BTN_H 15




- (void)setupSubViews{
    
    //0.
    
    self.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    //1.
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height-TITLE_CONTENT_H)];
    _imgView.userInteractionEnabled = NO;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
    [self.contentView addSubview:_imgView];
    
    //2.
    _titleContentView = [[UIView alloc]initWithFrame:CGRectMake(TITLE_CONTENT_MARGIN, _imgView.bottom+6, self.width-2*TITLE_CONTENT_MARGIN, TITLE_CONTENT_H-2*TITLE_CONTENT_MARGIN)];
    [self.contentView addSubview:_titleContentView];
    
    //3:
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _titleContentView.width, TITLE_H)];
    _titleLab.font = IS_HOME_CELL_TITLE_FONT;
    _titleLab.textColor = IS_HOME_CELL_TITLE_COLOR;
    _titleLab.numberOfLines =2;
    [_titleContentView addSubview:_titleLab];
    
    
    _readBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _titleLab.bottom+3, READ_BTN_H, READ_BTN_H)];
    [_readBtn setImage:[UIImage imageNamed:@"main_icon_look"] forState:UIControlStateNormal];
    [_titleContentView addSubview:_readBtn];
    
    
    _readLab = [[UILabel alloc]initWithFrame:CGRectMake(READ_BTN_H+3, _readBtn.y+1, 100, READ_BTN_H)];
    _readLab.font = IS_HOME_CELL_DES_FONT;
    _readLab.textColor = IS_HOME_CELL_READ_TITLE_COLOR;
    _readLab.textAlignment = NSTextAlignmentLeft;

    [_titleContentView addSubview:_readLab];

    
    
    
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - 数据源
-(void)setCaseModel:(IS_CaseModel *)caseModel{

    _caseModel = caseModel;
    
    //0.标题
    [self setTopicInfoLabText:caseModel.title];
//    self.titleLab.text = caseModel.title;
    [ self.titleLab alignTop];
    
    

    //1.图片
    
    
    NSString * thuinmaUrl = [NSString stringWithFormat:@"%@?imageView2/1/w/%d",caseModel.share_img,(int)ScreenWidth+50];
//
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:thuinmaUrl]
                                 placeholderImage:IS_PLACE_IMG options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 }];



    
    self.readLab.text = caseModel.read_count?caseModel.read_count:caseModel.uv;





    
}

- (void)addActionCompleteResultBlock:(CompleteResultBlock)completeResultBlock{
    self.completeResultBlock = completeResultBlock;
}
- (IBAction)editAction:(id)sender {
    if (self.completeResultBlock) {
        self.completeResultBlock(self);
    }
}


#pragma mark - UI控件

-(void)setHighlighted:(BOOL)highlighted{
    
    if (highlighted) {
        self.transform = CGAffineTransformMakeScale(0.95, 0.95);

    }else{
        [UIView animateWithDuration:.1 animations:^{
            self.transform = CGAffineTransformIdentity;
            
        }];
    }

    
}

- (void)setTopicInfoLabText:(NSString *)text{
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    _titleLab.attributedText = attributedString ;
}

#pragma mark - 动画



@end
