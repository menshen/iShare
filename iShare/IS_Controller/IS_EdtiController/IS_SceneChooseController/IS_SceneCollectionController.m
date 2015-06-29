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

@interface IS_SceneCollectionController ()

@property (strong,nonatomic)UIButton * closeButton;
@end

@implementation IS_SceneCollectionController

-(void)viewDidLoad{

    
    [self appendDatasource:nil];

    [super viewDidLoad];
    self.title =@"场景选择";
    [self setupClosebtn];
    [self.collectionView reloadData];

}
#define NUM_OF_ROW 2
#define SECTION_MARGIN 10
#define W (ScreenWidth/NUM_OF_ROW-SECTION_MARGIN*2)
#define H W*1.6
#define CLOSE_BUTTON_WIDTH 40


- (void)setupLayout{
    self.commonLayout.sectionInset = UIEdgeInsetsMake(SECTION_MARGIN, 2*SECTION_MARGIN, 2*SECTION_MARGIN,2*SECTION_MARGIN);
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.commonLayout.minimumLineSpacing  =SECTION_MARGIN;
    self.commonLayout.minimumInteritemSpacing  =0;
    self.commonLayout.itemSize = CGSizeMake(W, H);
}
- (void)setupCollectionView{
    
    [super setupCollectionView];
    [self setupLayout];
    [self.collectionView registerClass:[IS_EditTemplateCell class] forCellWithReuseIdentifier:IS_EditTemplateCell_ID];
    self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-CLOSE_BUTTON_WIDTH);
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    
    

}

-(void)setupClosebtn{
    
    _closeButton = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-CLOSE_BUTTON_WIDTH)/2, ScreenHeight-CLOSE_BUTTON_WIDTH-10, CLOSE_BUTTON_WIDTH,CLOSE_BUTTON_WIDTH)];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"IS_Edit_Close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
//    self.view.window
}

- (void)closeButtonAction:(UIButton*)btn{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}
#pragma mark -  外部结果

-(void)appendDatasource:(NSMutableArray *)datasource{
    self.datasource = [NSMutableArray array];
    NSArray * array = [IS_SenceEditTool getArrayFromReadJSONFileType:IS_TemplateStyleScene];
    self.datasource =[NSMutableArray arrayWithArray:array];
    


    
}

#pragma mark - Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IS_EditTemplateCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_EditTemplateCell_ID forIndexPath:indexPath];
    cell.editShowModel =self.datasource [indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IS_SenceCreateController * sc = [[IS_SenceCreateController alloc]init];
    IS_EditShowModel * sModel =self.datasource [indexPath.row];
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

@end
