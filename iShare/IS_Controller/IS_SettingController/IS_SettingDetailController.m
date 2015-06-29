//
//  IS_RegisterAfterController.m
//  iShare
//
//  Created by 伍松和 on 15/1/20.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_RegisterAfterController.h"
#import "LXActionSheet.h"
#import "IS_EditAssetPickerView.h"
#import "UzysAssetsPickerController.h"
#import "KVNProgress.h"

@interface IS_RegisterAfterController ()<UzysAssetsPickerControllerDelegate>

@property (strong,nonatomic)UIButton * imgBtnView;

@end

@implementation IS_RegisterAfterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    // Do any additional setup after loading the view.
    [self setup];

}

- (void)setup{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IS_AccountModel *)account{
    if (!_account) {
        _account = [IS_AccountModel sharedAccount];
    }
    return _account;
}

#define FOOTER_H 220
#define IMG_BTN_WIDTH   SCREEN_WIDTH/2.5
#define IMG_BTN_X      (SCREEN_WIDTH-IMG_BTN_WIDTH)/2
#define IMG_BTN_Y       20

-(UIView*)getHeaderView{
    
    
    _imgBtnView = [[UIButton alloc]initWithFrame:CGRectMake(IMG_BTN_X, IMG_BTN_Y, IMG_BTN_WIDTH, IMG_BTN_WIDTH)];
    _imgBtnView.layer.cornerRadius  = IMG_BTN_WIDTH/2;
    _imgBtnView.layer.masksToBounds = YES;
    _imgBtnView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgBtnView.layer.borderWidth = .5;
    _imgBtnView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imgBtnView addTarget:self action:@selector(imgBtnViewAction:) forControlEvents:UIControlEventTouchUpInside];
    if ( self.account.avatorImage) {
        [_imgBtnView setImage:self.account.avatorImage forState:UIControlStateNormal];
    }else{
        [_imgBtnView setImage:IS_PLACE_IMG forState:UIControlStateNormal];

    }
    UIImageView * hView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, FOOTER_H)];
    hView.image = [UIImage resizedImage:@"i_cell_bkg"];
    hView.backgroundColor = [UIColor whiteColor];
    hView.userInteractionEnabled = YES;
    [hView addSubview:_imgBtnView];
    return hView;
    
}

-(void)setupGroup0{
    
    
   
//    BaseSettingItem *item0=[BaseSettingItem itemWithTitle:@"头像" avatorImage: self.account.avatorImage option:nil];
    BaseSettingItem *item0=[BaseSettingItem itemWithIcon:nil title:@"昵称" subTitle:self.account.user_name?self.account.user_name:@"无" settingItemSytle:BaseSettingItemSytleArrow option:nil];

    
    
    BaseSettingGroup *group = [BaseSettingGroup group];
    group.items=@[item0];
    group.headerView = [self getHeaderView];
    self.tableView.rowHeight=40;
    
    self.groups[0]=group;
    
    
}
-(void)setupGroup1{
    
    
    
    BaseSettingItem *item0=[BaseSettingItem itemWithIcon:nil title:nil subTitle:@"修改密码" settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingGroup *group = [BaseSettingGroup group];
    group.items=@[item0];
    self.tableView.rowHeight=50;
    
    self.groups[1]=group;
    
    
}
-(void)setupGroup2{
    
    
    
    BaseSettingItem *item0=[BaseSettingItem itemWithIcon:nil title:nil subTitle:@"退出登录" settingItemSytle:BaseSettingItemSytleArrow option:nil];
    BaseSettingGroup *group = [BaseSettingGroup group];
    group.items=@[item0];
    self.tableView.rowHeight=50;
    
    self.groups[2]=group;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 200;

    }else{
        return 0.5;
    }

}
#pragma mark - 换图片

- (void)imgBtnViewAction:(UIButton*)btn{
    
    

//    LXActionSheet * actionSheet = [[LXActionSheet alloc]DidSelectBloc];
    LXActionSheet * actionSheet = [[LXActionSheet alloc] initWithTitle:@"更换头像" cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@[@"图片库"]  DidSelectBlock:^(id result) {
        
        NSInteger tag = [result integerValue];
        if (tag==2) {
            
        }else{
            UzysAssetsPickerController * picker = [[UzysAssetsPickerController alloc]init];
            picker.maximumNumberOfSelectionPhoto = 1;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        
       
    }];

    [actionSheet showInView:self.view];
    
}
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    UIImage  *image = [UIImage imageWithCGImage:[[[assets lastObject] defaultRepresentation] fullResolutionImage]];
    self.account.avatorImage = image;
    [IS_AccountModel updatePropertyName:@"avatorImage" newProperty:image where:ACCOUNT_ID];

    [self setup];
    
    NSDictionary * params = @{TOKEN:self.account.token};
    [HttpTool upLoadimage:image path:MODIFY_DATA_API param:params imageKey:HEAD_IMG_KEY success:^(id result) {
        [IS_AccountModel updatePropertyName:@"avatorImage" newProperty:image where:ACCOUNT_ID];
    } failure:^(NSError *error) {
        [KVNProgress showError];
    }];
    
  
    
}

@end
