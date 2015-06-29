
#import <UIKit/UIKit.h>
#import "IS_CaseModel.h"
@interface IS_WebContentController : UIViewController
/*!
 *  整个场景+模板+数据
 */
@property (strong,nonatomic)IS_CaseModel * caseModel;
/*!
 *  URL
 */
@property (copy,nonatomic)NSString * urlString;

- (void)loadAddress:(NSString *)url;
@end
