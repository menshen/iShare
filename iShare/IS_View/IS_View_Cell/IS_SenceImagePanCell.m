

#import "IS_SenceImagePanCell.h"
@implementation IS_SenceImagePanCell


-(void)setSenceImageModel:(IS_SenceSubTemplateModel *)senceImageModel{

    
    _senceImageModel = senceImageModel;
    
    //1.
    if (senceImageModel.image_data) {
        [self.sencn_image_btn_view setBackgroundImage:senceImageModel.image_data forState:UIControlStateNormal];
//        [self.sencn_image_btn_view setImage:senceImageModel.image_data forState:UIControlStateNormal];
    }else{
         [self.sencn_image_btn_view setImage:[UIImage imageNamed:senceImageModel.image_url] forState:UIControlStateNormal];
     

    }
    
    //2.
        self.sence_image_selected_num_lab.hidden=!senceImageModel.image_selected_num;
        self.sence_image_selected_num_lab.text=[NSString stringWithFormat:@"%@",@(senceImageModel.image_selected_num)];
    
    
    if (senceImageModel.image_selected) {
        
        self.sencn_image_btn_view.layer.borderWidth = 5;
        self.sencn_image_btn_view.layer.borderColor = [[UIColor redColor]CGColor];
        
        
    }else{
        self.sencn_image_btn_view.layer.borderWidth = 0;
        self.sencn_image_btn_view.layer.borderColor = [[UIColor clearColor]CGColor];
    }
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
