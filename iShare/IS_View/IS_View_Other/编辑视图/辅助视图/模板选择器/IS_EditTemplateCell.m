

#import "IS_EditTemplateCell.h"

@implementation IS_EditTemplateCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
#define IMG_MARGIN 10
#define LAB_MARGIN 10
- (void)setupImgView{
    [super setupImgView];
}
-(void)setTemplatePanModel:(IS_EditTemplateSelectModel *)templatePanModel{
    
    _templatePanModel = templatePanModel;
    //1.
    self.imgView.image = [UIImage imageNamed:templatePanModel.s_img_name];
    //2.
    
    if (templatePanModel.isScene) {
        self.imgView.frame = CGRectMake(10, 10, self.width-IMG_MARGIN*2, self.height-IMG_MARGIN*4);
        self.titleLab.frame = CGRectMake(LAB_MARGIN, self.imgView.bottom+LAB_MARGIN, self.width-IMG_MARGIN*2, IMG_MARGIN*2);
        self.titleLab.text = @"牵手";

    }else{
        self.imgView.frame = CGRectMake(10, 10, self.width-IMG_MARGIN*2, self.height-IMG_MARGIN);
        self.titleLab.frame = CGRectZero;
        
    }
    
    
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
    
    if(selected)
    {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeScale(0.97, 0.97);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeScale(1.03, 1.03);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
        
    }
}
-(void)drawRect:(CGRect)rect{

    if (self.selected)
    {
        self.contentView.layer.borderWidth = 2;
        self.contentView.layer.borderColor = IS_SYSTEM_COLOR.CGColor;
    }
    else
    {
        self.contentView.layer.borderWidth = 0;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
}

@end
