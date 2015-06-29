



#import "IS_SenceCreateController.h"
#import "IS_EditTemplateModel.h"
#import "IS_EditCardCollectionView.h"
#import "IS_SenceGirdController.h"
#import "IS_SenceEditTool.h"
#import "UIImage+ImageEffects.h"
#import "IS_SceneCollectionController.h"
#import "IS_EditBottomView.h"
#import "IS_WebContentController.h"
#import "KVNProgress.h"
#import "IS_EditChoosePageController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IS_TextActionSheet.h"
#import "PhotoPickerTool.h"
#import "IS_AccountModel.h"
#import "IS_HomeLoginController.h"
#import "IS_EditAssetPickerView.h"
#import "IS_EditShareController.h"
#import "LXActionSheet.h"
#import "ZYQAssetPickerController.h"
#import "AppDelegate.h"
#import "IS_EditMusicController.h"
@interface IS_SenceCreateController ()<IS_SenceGirdControllerDelegate,
IS_CardCollectionViewDelegate,ImageAddPreViewDelegate>

/**
  滚动视图
 */
@property (nonatomic,weak)IBOutlet IS_EditCardCollectionView * collectionView;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (nonatomic, strong) ZYQAssetPickerController *picker;

@end

@implementation IS_SenceCreateController{

    UIPageControl * _pageControl;
    IS_EditBottomView * _editView;
    MPMoviePlayerViewController * moviePlayer;
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
    //2.
    [self setupBottomView];
    
    //1.
    [self setupSenceSubView];



    
}
//#pragma mark -加载
#pragma mark -加载视图
-(void)setupSenceSubView{
    
    //A.
    
 
    
    self.collectionView.collection_delegate = self;
    [self.collectionView addDefaultWithSenceName:self.sceneEditModel.a_id];
    

    
    [self setupPageControl];
    
}
#pragma mark - PageControl
#define PAGE_CONTROL_H 15
- (void)setupPageControl{
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(10, ScreenHeight-_editView.height-PAGE_CONTROL_H-5, ScreenWidth-20, PAGE_CONTROL_H)];
    _pageControl.center = CGPointMake(self.view.center.x,_pageControl.center.y);
    _pageControl.numberOfPages =2;
    _pageControl.currentPage  =0;
    _pageControl.defersCurrentPageDisplay =YES;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = IS_SYSTEM_COLOR;
    [self.view addSubview:_pageControl];
    
    
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
               
                case IS_BottomEditViewButtonTypeAdd:
                {
                    
                    [self addTemplateToCollection];
                    
                    
                    
                    break;
                }
                case IS_BottomEditViewButtonTypeMenu:
                {
                    [self jumpToMenuAction:btn];
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
//    [_editView IS_BottomEditViewButtonEnableState:NO tag:0];

    
}


#pragma mark - Action


#pragma mark - 跳转到总览九宫格界面
- (void)jumpToMenuAction:(id)sender {
 
    
    IS_SenceGirdController * GirdCtrl = [[IS_SenceGirdController alloc]init];
    GirdCtrl.delegate=self;
    GirdCtrl.sence_array = self.collectionView.senceDataSource;
    [self presentNextController:GirdCtrl];

}
- (IBAction)changeBtnAction:(UIButton*)sender {
    if (sender.tag==1) {
        [self jumpToScenePageController];
    }else{
        [self jumpToTemplateSheetAction:YES];
    }
}
#pragma mark - 跳转到场景

- (void)jumpToScenePageController{
    IS_SceneCollectionController * pvc = [[IS_SceneCollectionController alloc]init];
    pvc.sceneChooseType = IS_SceneChooseTypeChange;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:pvc];
    [self presentViewController:nav animated:YES completion:nil];
    
}
#pragma mark  - 跳转到模板选择界面
- (void)jumpToTemplateSheetAction:(BOOL)change {
    
    IS_EditChoosePageController * editChoosePageVC = [[IS_EditChoosePageController alloc]initWithDidSelectBlock:^(id result) {
        
           [self.collectionView collectionToChangeTemplate:result];
        
    } DismissBlock:^(id result) {
        if (!change) {
            [self.collectionView deleteCurrentItem];
        }

    }];
    
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:editChoosePageVC];
        [self presentViewController:nav animated:YES completion:nil];


//    


  

}
#pragma mark - 跳转到音乐页面
- (void)jumpToMusicAction{
    
    IS_EditMusicController * editMusicController = [[IS_EditMusicController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:editMusicController];
    [self presentViewController:nav animated:YES completion:nil];
    //        _caseModel.musicURl = result;

    

}

#pragma mark - 生成场景
-(void)createSence:(UIBarButtonItem*)item{
    
    
    if (![IS_AccountModel getToken]) {
        
        
        //没账号
        IS_HomeLoginController * login = [[IS_HomeLoginController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
        return;
    }else{
        //有账号
        IS_EditShareController * editShareController  = [[IS_EditShareController alloc]initWithCompleteBlock:^(id result) {
            if (result) {
                IS_CaseModel * caseModel =result;
                [IS_SenceEditTool saveSenceModelWithSenceModel:caseModel TemplateArray:self.collectionView.senceDataSource  CompleteBlock:^(id results) {
                    
                    if ([results isKindOfClass:[IS_CaseModel class]]) {
                        IS_WebContentController * webVC = [[IS_WebContentController alloc]init];
                        webVC.caseModel = results;
                        [self.navigationController pushViewController:webVC animated:YES];
                    }
                    
                    
                }];
            }
            
            
            
        }];
        [self presentNextController:editShareController];
    
    }
    
   


}
#pragma mark - 增加页数
- (void)addTemplateToCollection{
    
    [self.collectionView addCurrentItem:IS_AddTypeTypeByHand];

    
}
#pragma mark - 删除模板

- (void)trashTemplateFromCollection{
    
    LXActionSheet * actionSheet = [[LXActionSheet alloc]initWithTitle:@"是否删除" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil DidSelectBlock:^(id result) {
        if ([result integerValue]==0) {
            [self.collectionView deleteCurrentItem];

        }
    }];
    [actionSheet showInView:nil];
    
    
}
#pragma mark  -保存并且离开


-(void)backToRoot:(UIBarButtonItem*)item{

   [self.navigationController popViewControllerAnimated:YES];
 
}

#pragma mark ------------------------------代理方法--------------------------------------


#pragma mark - IS_CardCollectionVoewDelegate
-(void)IS_CardCollectionViewDidEndOperation:(id)itemData ActionType:(IS_ContentImageActionType)type{
    
    
    switch (type) {
        case IS_ContentImageActionTypeDidSelect:
            [self startPicker];

            break;
        case IS_ContentImageActionTypeAdd:
            [self addItemAction];

            break;
        case IS_ContentImageActionTypeDel:
            
            [self delItemAction];
            
            break;
            
        default:
            break;
    }
    

}
#pragma mark - 跳出图片选择
- (void)startPicker
{
    if (_picker == nil) {
        _picker = [[ZYQAssetPickerController alloc] init];
        _picker.maximumNumberOfSelection = 9;
        _picker.assetsFilter = [ALAssetsFilter allPhotos];
        _picker.showEmptyGroups=NO;
        //        _picker.delegate = self;
    }
    _picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    //    if (IOS7) {
    //        _picker.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1fbba6"];
    //    }
    [D_Main_Appdelegate showPreView];
    _picker.vc =self;
    [self presentViewController:_picker animated:YES completion:NULL];
    [D_Main_Appdelegate preview].delegateSelectImage = self;
    [[D_Main_Appdelegate preview] reMoveAllResource];
    
    
}

#pragma mark ImageAddPreViewDelegate
- (void)startPintuAction:(ImageAddPreView *)sender
{
    if ([sender.imageassets count] >= 2) {
        [_picker dismissViewControllerAnimated:YES completion:nil];
        [self.collectionView insertAssetIntoEditView:sender.imageassets WithAssetURLArray:nil]; // sender.imageassets;
    }else if([sender.imageassets count] == 1){
    }else{
        
        
        
    }
    
}
-(void)deletePintuAction:(ImageAddPreView *)sender{}
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker{
    [_picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 加一页
- (void)addItemAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self jumpToTemplateSheetAction:NO];
        
    });
    [self IS_SceneVCDidPageChange:_collectionView.senceDataSource.count];

}
#pragma mark - 删除一页
- (void)delItemAction{
    if (_collectionView.currentIndexPath.row+1==_collectionView.senceDataSource.count) {
        [self IS_SceneVCDidPageChange:_collectionView.currentIndexPath.row];
    }else{
        [self IS_SceneVCDidPageChange:_collectionView.currentIndexPath.row-1];
        
    }
}

#pragma mark - 滑动之后
-(void)IS_CardCollectionViewDidEndDecelerating:(id)itemData userinfo:(NSDictionary *)userinfo{
    
   
    NSInteger row = [itemData integerValue];
    [self IS_SceneVCDidPageChange:row];
    //2.
    
    self.changeBtn.tag=(row==0);
    if (row==0) {
        [self.changeBtn setImage:[UIImage imageNamed:@"edit_icon_change_scene"] forState:UIControlStateNormal];
        
    }else{
         [self.changeBtn setImage:[UIImage imageNamed:@"edit_icon_change_template"] forState:UIControlStateNormal];
    }
    

}
#pragma mark - 滑点变化
- (void)IS_SceneVCDidPageChange:(NSInteger)row{
    //1.滑点
 
 
    _pageControl.numberOfPages = _collectionView.senceDataSource.count;
    _pageControl.currentPage =row;
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
