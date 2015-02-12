

#import "IS_SenceTempateItemCell.h"

@implementation IS_SenceTempateItemCell
-(void)setSenceTemplatePanModel:(IS_SenceTemplatePanModel *)senceTemplatePanModel{
    
    _senceTemplatePanModel = senceTemplatePanModel;
    
    //1.
    self.sence_image_view.image = [UIImage imageNamed:senceTemplatePanModel.s_img_name];
    
    //2.
    if (senceTemplatePanModel.s_name&&senceTemplatePanModel.s_name.length!=0) {
        self.sence_title_lab.text = senceTemplatePanModel.s_name;
        self.sence_title_lab.hidden=NO;
    }else{
        self.sence_title_lab.hidden=YES;
    }
    
    //3.
//    self.selected = senceTemplateModel.is_selected;
    if (senceTemplatePanModel.is_selected) {
        
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [IS_SYSTEM_COLOR CGColor];
        
        
    }else{
        self.contentView.layer.borderWidth = 0;
        self.contentView.layer.borderColor = [[UIColor clearColor]CGColor];
    }

}
//
//固定cell的frame，因为会不停动态改变
#define kCellBorderWidth 10
-(void)setFrame:(CGRect)frame{
    
    frame.origin.x = kCellBorderWidth;
    frame.origin.y += kCellBorderWidth;
    
   frame.size.width-=kCellBorderWidth ;
    frame.size.height-=kCellBorderWidth;
    
    [super setFrame:frame];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
 
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //[self setBackgroundView:@"" selectBackgroundView:@"sence_template_select"];
}
-(void)setBackgroundView:(NSString *)imgName
    selectBackgroundView:(NSString*)select_imgName{
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage resizedImage:imgName];
    self.backgroundView = bg;
    
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage imageNamed:select_imgName];
    self.selectedBackgroundView = selectedBg;
    self.backgroundColor = [UIColor clearColor];
}

@end
