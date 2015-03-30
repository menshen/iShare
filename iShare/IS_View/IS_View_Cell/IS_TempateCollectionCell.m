

#import "IS_TempateCollectionCell.h"

@implementation IS_TempateCollectionCell
-(void)setSenceTemplatePanModel:(IS_SenceTemplatePanModel *)senceTemplatePanModel{
    
    _senceTemplatePanModel = senceTemplatePanModel;
    
    //1.
    self.imgView.image = [UIImage imageNamed:senceTemplatePanModel.s_img_name];
    
}

@end
