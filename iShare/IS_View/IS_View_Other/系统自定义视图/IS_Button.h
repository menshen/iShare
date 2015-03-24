typedef NS_ENUM(NSInteger, ButtonPositionType){
    
    ButtonPositionTypeNone,
    ButtonPositionTypeBothCenter,
    ButtonPositionTypeTitleLeft,
    ButtonPositionTypeNoneTitle,
    ButtonPositionTypeNoneImageView,
};

#import <UIKit/UIKit.h>

@interface IS_Button : UIButton
/**
 *  按钮位置类型
 */
@property (nonatomic,assign)ButtonPositionType buttonPosition;
/**
 *  初始化按钮
 */
-(instancetype)initWithFrame:(CGRect)frame
          ButtonPositionType:(ButtonPositionType)type;
- (void)setBtnSelecteAction;
@end
