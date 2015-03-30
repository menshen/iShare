@protocol IS_WebCoverViewDelegate <NSObject>

- (void)IS_WebCoverViewDidBackAction:(id)result;

- (void)IS_WebCoverViewDidScroll:(id)result;

@end

#import <UIKit/UIKit.h>
#import "IS_CaseModel.h"

@interface IS_WebCoverView : UIView
@property (strong,nonatomic)IS_CaseModel * caseModel;
@property (assign,nonatomic)id<IS_WebCoverViewDelegate>delegate;

@end
