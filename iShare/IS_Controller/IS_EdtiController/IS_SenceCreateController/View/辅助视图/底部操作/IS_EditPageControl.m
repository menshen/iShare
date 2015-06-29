
#import "IS_EditPageControl.h"

@implementation IS_EditPageControl
{
    UIImage*_activeImage;
    UIImage*_inactiveImage;
}
-(void)awakeFromNib{
    
    [super awakeFromNib];

}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame
//
//{
//    
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        
//        _activeImage= [UIImage imageNamed:@"btn_round_selected"];
//        
//        _inactiveImage= [UIImage imageNamed:@"btn_round_unselected"];
//        
//    }
//    
//    return self;
//    
//}

//- (void)updateDots
//
//{
//    
//    for(int i = 0; i< self.subviews.count;i++) {
//        
//        UIImageView* dot = [self.subviews objectAtIndex:i];
//         if(i == self.currentPage){
//            dot.image= _activeImage;
//         } else
//            
//            dot.image= _inactiveImage;
//        }
//    
//}
//
//
//- (void)setCurrentPage:(NSInteger)currentPage
//
//{
//    
//    [super setCurrentPage:currentPage];
//    [self updateDots];
//    
//}
@end
