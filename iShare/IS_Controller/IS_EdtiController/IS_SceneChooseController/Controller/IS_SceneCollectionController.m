//
//  IS_SenceCollectionController.m
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SceneCollectionController.h"
#import "IS_SenceCreateController.h"
#import "IS_EditTemplateCell.h"
#import "IS_SenceEditTool.h"
#import "UIImage+JJ.h"
#import "IS_MineCaseHeaderView.h"

@interface IS_SceneCollectionController ()

@property (strong,nonatomic)UIButton * closeButton;
@end

@implementation IS_SceneCollectionController

-(void)viewDidLoad{

    
    [self appendDatasource:nil];

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title =@"场景选择";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:nil themeColor:nil target:self action:nil];
    [self setupClosebtn];
    [self.collectionView reloadData];

}
#define NUM_OF_ROW 2
#define SECTION_MARGIN 10
#define W (ScreenWidth-SECTION_MARGIN*2-5)/2
#define H W*1.8


#define CLOSE_BUTTON_WIDTH 40
#define BOTTOM_VIEW_H CLOSE_BUTTON_WIDTH*1.2


- (void)setupLayout{
    self.commonLayout.sectionInset = UIEdgeInsetsMake(SECTION_MARGIN, SECTION_MARGIN, 2*SECTION_MARGIN,SECTION_MARGIN);
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.commonLayout.minimumLineSpacing  =SECTION_MARGIN/2;
    self.commonLayout.minimumInteritemSpacing  =SECTION_MARGIN/2;
    self.commonLayout.itemSize = CGSizeMake(W, H);
    self.commonLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);

}
- (void)setupCollectionView{
    
    [super setupCollectionView];
    [self setupLayout];
    [self.collectionView registerClass:[IS_EditTemplateCell class] forCellWithReuseIdentifier:IS_EditTemplateCell_ID];
    self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-BOTTOM_VIEW_H);
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    [self setupCollectionViewRegisterClass:NSStringFromClass([IS_MineCaseHeaderView class])
                                     isNib:YES
                                  isHeader:YES];
    
    
    

}

-(void)setupClosebtn{
    
    
    UIImageView * bottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight-BOTTOM_VIEW_H, ScreenWidth, BOTTOM_VIEW_H)];
    bottom.userInteractionEnabled = YES;
    bottom.image = [UIImage resizedImage:@"IS_Toolbar_up"];
    [self.view addSubview:bottom];
    
    _closeButton = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-CLOSE_BUTTON_WIDTH)/2, 5, CLOSE_BUTTON_WIDTH,CLOSE_BUTTON_WIDTH)];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"IS_Edit_Close"] forState:UIControlStateNormal];
    [bottom addSubview:_closeButton];
//    self.view.window
}

- (void)closeButtonAction:(UIButton*)btn{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}
#pragma mark -  外部结果

-(void)appendDatasource:(NSMutableArray *)datasource{
    self.datasource = [NSMutableArray array];
    NSArray * arrayM = [IS_SenceEditTool getArrayFromReadJSONFileType:IS_TemplateStyleScene];
    self.datasource =[NSMutableArray arrayWithArray:arrayM];
    


    
}

#pragma mark - Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datasource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary * dic =  self.datasource[section];
    NSArray * arrayM = dic[DATA_KEY];
    return arrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IS_EditTemplateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_EditTemplateCell_ID forIndexPath:indexPath];
    NSDictionary * dic =  self.datasource[indexPath.section];
    NSArray * arrayM = dic[DATA_KEY];
    NSDictionary * editDic = arrayM[indexPath.row];
    cell.editShowModel =[[IS_EditShowModel alloc]initWithDictionary:editDic];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IS_SenceCreateController * sc = [[IS_SenceCreateController alloc]init];
    
    NSDictionary * dic =  self.datasource[indexPath.section];
    NSArray * arrayM = dic[DATA_KEY];
    NSDictionary * editDic = arrayM[indexPath.row];
    IS_EditShowModel * sModel =[[IS_EditShowModel alloc]initWithDictionary:editDic];
    sc.sceneEditModel = sModel;
    
    if (self.sceneChooseType==IS_SceneChooseTypeCreate) {
        
        [self.navigationController pushViewController:sc animated:YES];
    }
    else{
            
            if (self.actonSheetBlock) {
                self.actonSheetBlock(sModel);

                [self dismissCollectionViewControllerSheet];
            }
        

    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSDictionary * dict = self.datasource[indexPath.section];
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        IS_MineCaseHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([IS_MineCaseHeaderView class]) forIndexPath:indexPath];
        headerView.titleLab.text = dict[@"title"];
        headerView.titleLab.textColor = [UIColor colorWithHexString:dict[@"color"]];
        headerView.lineView.backgroundColor = [UIColor colorWithHexString:dict[@"color"]];
        
        reusableview = headerView;
    }
    
    
    return reusableview;
    
    
    
    
    
}

@end
