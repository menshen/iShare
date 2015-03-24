#import "IS_CaseCollectionCell.h"
#import "Masonry.h"
#import "View+MASAdditions.h"
@interface IS_CaseCollectionCell()
@end
@implementation IS_CaseCollectionCell


- (void)awakeFromNib {

    [super awakeFromNib];
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
     self.imgBtnView.imageView.contentMode = UIViewContentModeScaleAspectFill;
  
    
  
    switch (self.caseType) {
        case IS_CaseCollectionTypeHome:
        {
          
            [self setupWithinHome];
            break;
        }
        case IS_CaseCollectionTypeMineShare:
        {

            [self setupWithinMineShare];
            
            break;
        }
           
            
        default:
            break;
    }
    
}
- (void)setupWithinMineShare{
    self.editStateIcon.hidden = NO;
    self.editBtn.hidden = NO;
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.trailing.equalTo(self.mas_trailing).with.offset(-40);
        make.trailing.equalTo(self.mas_trailing).with.offset(-40);
        
        
    }];
}
- (void)setupWithinHome{
    self.editStateIcon.hidden = YES;
    self.editBtn.hidden = YES;
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.trailing.equalTo(self.mas_trailing).with.offset(-40);
        make.trailing.equalTo(self.mas_trailing).with.offset(0);
        
        
    }];
  

}
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}
@end
