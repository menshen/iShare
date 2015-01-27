

#import "IS_SenceTempateItemCell.h"

@implementation IS_SenceTempateItemCell
-(void)setSenceTemplateModel:(IS_SenceTemplateModel *)senceTemplateModel{
    
    _senceTemplateModel = senceTemplateModel;
    
    //1.
    self.sence_image_view.image = [UIImage imageNamed:senceTemplateModel.s_img_name];
    
    //2.
    if (senceTemplateModel.s_name&&senceTemplateModel.s_name.length!=0) {
        self.sence_title_lab.text = senceTemplateModel.s_name;
        self.sence_title_lab.hidden=NO;
    }else{
        self.sence_title_lab.hidden=YES;
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
    
    // Configure the view for the selected state
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundView:@"" selectBackgroundView:@"sence_template_select"];
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
