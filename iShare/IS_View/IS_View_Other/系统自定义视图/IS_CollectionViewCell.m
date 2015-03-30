
/*!
    基本类型:
 
  1.一个图片的
  2.一个UILabel的
 */

#import "IS_CollectionViewCell.h"

@implementation IS_CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        [self setup];
    }
    return self;
}
- (void)setup{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self setupImgView];
    [self setupTitleLab];

}

- (void)setupImgView{
    
    _imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:_imgView];

}
- (void)setupTitleLab{

    _titleLab =[[UILabel alloc]initWithFrame:CGRectZero];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_titleLab];
}
@end
