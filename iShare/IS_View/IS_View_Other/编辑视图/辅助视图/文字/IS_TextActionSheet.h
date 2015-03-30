

#import "IS_ActionSheet.h"

typedef void(^IS_TextActionSheetBlock)(id inputText);
@interface IS_TextActionSheet : IS_ActionSheet

@property (copy,nonatomic)IS_TextActionSheetBlock textActionSheetBlock;
- (void)showActionSheetAtView:(UIView *)view
                    PlaceText:(NSString*)placeText
              actonSheetBlock:(IS_ActonSheetBlock)actonSheetBlock
         textActionSheetBlock:(IS_TextActionSheetBlock)textActionSheetBlock;
@end
