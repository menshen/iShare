

#import "IS_ActionSheet.h"


typedef void(^IS_TextActionSheetInputDoneBlock)(id result);
typedef void(^IS_TextActionSheetInputIngBlock)(id inputText);
typedef void(^IS_TextActionSheetImageUploadBlock)(id result);

@interface IS_TextActionSheet : IS_ActionSheet


@property (copy,nonatomic)IS_TextActionSheetInputDoneBlock inputDoneBlock;
@property (copy,nonatomic)IS_TextActionSheetInputIngBlock   inputIngBlock;
@property (copy,nonatomic)IS_TextActionSheetImageUploadBlock imageUploadBlock;

- (void)showActionSheetAtView:(UIView *)view
                    PlaceText:(NSString*)placeText
              inputDoneBlock:(IS_TextActionSheetInputDoneBlock)inputDoneBlock
         inputIngBlock:(IS_TextActionSheetInputIngBlock)inputIngBlock
             imageUploadBlock:(IS_TextActionSheetImageUploadBlock)imageUploadBlock;

@end
