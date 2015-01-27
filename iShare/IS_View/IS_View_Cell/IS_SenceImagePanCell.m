

#import "IS_SenceImagePanCell.h"
@implementation IS_SenceImagePanCell


-(void)setSenceImageModel:(IS_SenceImageModel *)senceImageModel{

    
    _senceImageModel = senceImageModel;
    
    //1.
    if (senceImageModel.imageData) {
        [self.sencn_image_btn_view setBackgroundImage:senceImageModel.imageData forState:UIControlStateNormal];
//        [self.sencn_image_btn_view setImage:senceImageModel.imageData forState:UIControlStateNormal];
    }else{
         [self.sencn_image_btn_view setImage:[UIImage imageNamed:senceImageModel.image_path] forState:UIControlStateNormal];
     

    }
    
    //2.
        self.sence_image_selected_num_lab.hidden=!senceImageModel.image_selected_num;
        self.sence_image_selected_num_lab.text=[NSString stringWithFormat:@"%@",@(senceImageModel.image_selected_num)];
    
}

- (void)awakeFromNib {
    // Initialization code
    
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#define kCellBorderWidth 10
-(void)setFrame:(CGRect)frame{
    
    frame.origin.x = kCellBorderWidth;
    frame.origin.y += kCellBorderWidth;
    
    frame.size.width-=kCellBorderWidth *2;
    frame.size.height-=kCellBorderWidth;
    
    [super setFrame:frame];
}
@end