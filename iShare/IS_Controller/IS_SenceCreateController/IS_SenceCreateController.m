

#import "UzysAssetsPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "IS_SenceCreateController.h"
#import "IS_ShareMenuController.h"
#import "IS_EditTemplateModel.h"
#import "IS_EditCardCollectionView.h"
#import "IS_EditTemplateActionView.h"


#import "UIImage+ImageEffects.h"
#import "UIWindow+JJ.h"
#import "IS_SenceGirdController.h"
#import "IS_SenceEditTool.h"
#import "IS_SceneCollectionController.h"
#import "IS_EditBottomView.h"
#import "KVNProgress.h"
#import "IS_EditPageControl.h"
#import "IS_EditMusicActionSheet.h"
#import "IS_WebContentController.h"


@interface IS_SenceCreateController ()<UzysAssetsPickerControllerDelegate,IS_SenceGirdControllerDelegate,
IS_CardCollectionViewDelegate>




/**
  滚动视图
 */
@property (nonatomic,weak)IBOutlet IS_EditCardCollectionView * collectionView;

/**
 * 选择条
 */
@property (weak, nonatomic) IBOutlet IS_EditPageControl *editPageControl;




@end

@implementation IS_SenceCreateController{
    
    IS_EditBottomView * _editView;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;

}
- (void)viewDidLoad {

    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor =kColor(244, 244, 244);//[UIColor redColor];// kColor(240, 240, 240);


    //1.加载子视图
    [self setupSubview];
}

#pragma mark - 视图初始化
- (void)setupSubview{
    
    [self setupHeaderViews];

    
    //1.
    [self setupSenceSubView];

    //2.
    [self setupBottomView];
    
}
//#pragma mark -加载
#pragma mark -加载视图
-(void)setupSenceSubView{
    
    //A.
    
 
    
    self.collectionView.collection_delegate = self;
    [self.collectionView addDefaultWithSenceType:_firstEditModel.type
                                    SubSenceType:_firstEditModel.sub_type
                                       ExistData:_senceModel.templateArray];
    

    
    
    [self setupPageControl];
}
#pragma mark - PageControl
- (void)setupPageControl{
    
    _editPageControl.numberOfPages = 2;
    _editPageControl.indicatorMargin = 8;
    _editPageControl.indicatorDiameter = 1;
    [_editPageControl setPageIndicatorImage:[UIImage imageNamed:@"edit_dot_gray"]];
    [_editPageControl setImage:[UIImage imageNamed:@"edit_dot_lightgray"] forPage:0];
    _editPageControl.currentPage = 1;
    _editPageControl.curPageText = [NSString stringWithFormat:@"%d",(int)_editPageControl.currentPage];
    [_editPageControl setNeedsDisplay];
    
    
}
- (void)spacePageControl:(SMPageControl *)sender

{
    
    _editPageControl.curPageText = [NSString stringWithFormat:@"%d",(int)_editPageControl.currentPage];
    [_editPageControl setNeedsDisplay];
}
#pragma mark - A.头部

//#import "UIButton+JJ.h"
-(void)setupHeaderViews{
  
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"返回" themeColor:IS_SYSTEM_WHITE_COLOR target:self action:@selector(backToRoot:)];
    
    //0.标题
    self.title  =@"编辑";

}
#pragma mark  -底部视图
- (void)setupBottomView{
    
    CGRect rect = CGRectMake(0, ScreenHeight-50, ScreenWidth, 50);
    _editView = [[IS_EditBottomView alloc]initWithFrame:rect btnBlock:^(id result) {
        if (!result) {
            return;
        }else{
            UIButton * btn = result;
            IS_BottomEditViewButtonType type = btn.tag;
            switch (type) {
                case IS_BottomEditViewButtonTypeTemplate:
                {
                    [self jumpToTemplateSheetAction:btn];
                break;
                }
                case IS_BottomEditViewButtonTypeMenu:
                {
                    [self jumpToMenuAction:btn];
                    break;
                }
                 case IS_BottomEditViewButtonTypeAdd:
                {
                    [self addTemplateToCollection];
                    break;
                }
                case IS_BottomEditViewButtonTypeTrash:
                {
                    [self trashTemplateFromCollection];
                    break;
                }
                case IS_BottomEditViewButtonTypeMusic:
                {
                    [self jumpToMusicAction];
                    break;
                }
                case IS_BottomEditViewButtonTypeDone:
                {
                    [self createSence:nil];
                    break;
                }
                    
                    
                    
                default:
                    break;
            }
        }
       
        
        
        
    }];
    [self.view addSubview:_editView];
    [_editView IS_BottomEditViewButtonEnableState:NO tag:0];

    
}


#pragma mark - Action


#pragma mark - 跳转到总览九宫格界面
- (void)jumpToMenuAction:(id)sender {
 
    
    IS_SenceGirdController * GirdCtrl = [[IS_SenceGirdController alloc]init];
    GirdCtrl.delegate=self;
    GirdCtrl.sence_array = self.collectionView.senceDataSource;
    [self presentNextController:GirdCtrl];

}
#pragma mark  - 跳转到模板选择界面
- (void)jumpToTemplateSheetAction:(id)sender {
    
    
    IS_EditTemplateActionView * a = [[IS_EditTemplateActionView alloc]initWithFrame:self.view.bounds];
    [a showActionSheetAtView:nil actonSheetBlock:^(id result) {
        [self.collectionView collectionToChangeTemplate:result];
        [a dismissActionSheet];

    }];

  

}
#pragma mark - 跳转到音乐页面
- (void)jumpToMusicAction{
    
    IS_EditMusicActionSheet * musicActionSheet = [[IS_EditMusicActionSheet alloc]initWithFrame:self.view.bounds];
    [musicActionSheet addDatasource:[NSMutableArray arrayWithArray:@[@"1",@"1",@"1",@"1",@"1",@"1"]]];
    [musicActionSheet showActionSheetAtView:nil actonSheetBlock:^(id result) {
        
    }];

}
#pragma mark - 生成场景
-(void)createSence:(UIBarButtonItem*)item{
    
    
    
    
//    [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: @"等等",
//                                             KVNProgressViewParameterFullScreen: @(YES)}];
    
    [IS_SenceEditTool saveSenceModelWithSenceID:nil TemplateArray:self.collectionView.senceDataSource SubTemplateDataArray:nil CompleteBlock:^(id results) {
        
        if ([results isKindOfClass:[IS_CaseModel class]]) {
            IS_WebContentController * webVC = [[IS_WebContentController alloc]init];
            webVC.caseModel = results;
            [self.navigationController pushViewController:webVC animated:YES];
        }
       
        
    }];
    
   

    
    
    
}
#pragma mark - 增加页数
- (void)addTemplateToCollection{
//    [self.collectionView addItem];
}
#pragma mark - 删除模板

- (void)trashTemplateFromCollection{
    
}
#pragma mark  -保存并且离开


-(void)backToRoot:(UIBarButtonItem*)item{

   [self.navigationController popViewControllerAnimated:YES];
 
}
/**
 * 
    1. 点击 '+'
    2. 点击视图中的占位符
 */
#pragma mark -图片选择器
-(void)pickImageAndVideo{

    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionPhoto = 9;
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    
    
    NSMutableArray * arrayM = [NSMutableArray array];
    NSMutableArray * assetURLM=[NSMutableArray array];
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc]init];
    
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         if([[obj valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
        {
//           [arrayM addObject:image];
//            [assetURLM addObject:representation.defaultRepresentation.url];

            ALAsset *representation = obj;
            [assetLibrary assetForURL:representation.defaultRepresentation.url resultBlock:^(ALAsset *asset) {
                UIImage  *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                NSData * imageData=UIImageJPEGRepresentation(image, 0.000000001);
                [arrayM addObject:[UIImage imageWithData:imageData]];
                [assetURLM addObject:representation.defaultRepresentation.url.absoluteString];

                if (arrayM.count==assets.count) {
                    [self.collectionView insertAssetIntoEditView:arrayM WithAssetURLArray:assetURLM];

                }
            } failureBlock:nil];
            
            

        }
    }];
//    [self IS_SenceImagePanViewDidInsertItems:arrayM];


    
    
}

#pragma mark ------------------------------代理方法--------------------------------------


#pragma mark - IS_CardCollectionVoewDelegate

/**
 *  当点击事件后
 */
- (void)IS_CardCollectionViewDidSelectImageViewItem:(id)itemData
                                           userinfo:(NSDictionary*)userinfo{
   
    if ([itemData img]) {
        //
    }else{
        [self pickImageAndVideo];
    }
}
#pragma mark - 滑动之后
-(void)IS_CardCollectionViewDidEndDecelerating:(id)itemData userinfo:(NSDictionary *)userinfo{
    
    //0.
    if (userinfo[@"action"]) {
        [self jumpToTemplateSheetAction:nil];
    }
    
    
    //1.滑点
    NSInteger row = [itemData integerValue];
    _editPageControl.currentPage =row;
    _editPageControl.numberOfPages = _collectionView.senceDataSource.count;

    if (row!=0) {

        _editPageControl.curPageText = [NSString stringWithFormat:@"%d",(int)row];
    
    }else{
        _editPageControl.curPageText = nil;///[NSString stringWithFormat:@"%d",(int)row];

    }
    [_editPageControl setNeedsDisplay];
    
    //2.
    if (row==0) {
        [_editView IS_BottomEditViewButtonEnableState:NO tag:0];
    }else{
        [_editView IS_BottomEditViewButtonEnableState:YES tag:0];

    }

}

-(void)IS_SenceGirdControllerDidUpdate:(id)itemData{
    
    if (!itemData) {
    }else{
        NSIndexPath * cur_indexPath = itemData;
        self.collectionView.currentIndexPath=cur_indexPath;
        [self.collectionView scrollToItemAtIndexPath:cur_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    }
       [self.collectionView reloadData];
}

#pragma mark -背景蒙板
- (void)presentNextController:(UIViewController*)destination
{
    CGSize windowSize = self.view.window.bounds.size;

    UIImage * snapshot =[UIImage getImageFromCurView:self.view];
    snapshot= [snapshot applyBlurWithRadius:10
                                  tintColor:Color(0, 0, 0, .3)
                      saturationDeltaFactor:0.6
                                  maskImage:nil];
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];
    backgroundImageView.frame =  CGRectMake(0, -windowSize.height, windowSize.width, windowSize.height);;
    [destination.view addSubview:backgroundImageView];
    [destination.view sendSubviewToBack:backgroundImageView];
//    destination backgroundImageView = backgroundImageView;
   
       
    [self presentViewController:destination animated:YES completion:nil];
    
    [destination.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            backgroundImageView.frame = CGRectMake(0, 0, windowSize.width, windowSize.height);
        }];
    } completion:nil];
}

@end
