

#import "IS_EditTemplateCell.h"

@implementation IS_EditTemplateCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
        
    }
    return self;
}
#define IMG_MARGIN 10
#define LAB_MARGIN 10
- (void)setupImgView{
    [super setupImgView];
}
-(void)setEditShowModel:(IS_EditShowModel *)editShowModel{
    
    _editShowModel = editShowModel;

    NSString * jpgPath = [editShowModel.a_id stringByAppendingString:@".jpg"];
    if ([UIImage imageNamed:jpgPath]) {
        self.imgView.image =[UIImage imageNamed:jpgPath];
    }else {
        NSString * pngPath = [editShowModel.a_id stringByAppendingString:@".png"];
        self.imgView.image = [UIImage imageNamed:pngPath];

    }
    //2.
    
    if (editShowModel.isScene) {
        self.imgView.frame = CGRectMake(0, 0, self.width, self.height-IMG_MARGIN*4);
        self.titleLab.frame = CGRectMake(LAB_MARGIN, self.imgView.bottom+LAB_MARGIN, self.width-IMG_MARGIN*2, IMG_MARGIN*2);
        self.titleLab.text = editShowModel.words;
        self.titleLab.textColor = [UIColor blackColor];

    }else{
        self.imgView.frame = CGRectMake(0, 0, self.width, self.height);
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
