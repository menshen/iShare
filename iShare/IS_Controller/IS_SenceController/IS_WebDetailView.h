

#import <UIKit/UIKit.h>
#import "IS_CaseModel.h"

@protocol IS_WebDetailViewDelegate <NSObject>

- (void)IS_WebDetailViewDidBackAction:(id)result;

@end

@interface IS_WebDetailView : UIView
/*!
 *  整个场景+模板+数据
 */
@property (strong,nonatomic)IS_CaseModel * caseModel;
@property (assign,nonatomic)id<IS_WebDetailViewDelegate>delegate;
@end
