//
//  IS_SenceCollectionController.m
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SenceCollectionController.h"
#import "IS_TemplateLayout.h"
#import "IS_TempateCollectionCell.h"
#import "iShare_Marco.h"
#import "UIView+JJ.h"
#import "IS_SenceCreateController.h"
@interface IS_SenceCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong)UICollectionView * collectionview;

@end

@implementation IS_SenceCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //0.
    self.view.backgroundColor = IS_SYSTEM_WHITE_COLOR;
    [self.view addSubview:self.collectionview];
    
    UINib * nib = [UINib nibWithNibName:IS_TempateCollectionCell_ID bundle:nil];
    [self.collectionview registerNib:nib forCellWithReuseIdentifier:IS_TempateCollectionCell_ID];
    
    //1.默认
    [self addDefault];
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
  
}

#pragma mark
-(UICollectionView *)collectionview{
    
    if (!_collectionview) {
        IS_TemplateLayout * layout = [[IS_TemplateLayout alloc]init];
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, self.view.height-40) collectionViewLayout:layout];
        _collectionview.delegate =self;
        _collectionview.dataSource =self;
        _collectionview.backgroundColor = [UIColor clearColor];
        
    }
    return _collectionview;
    
}
#pragma mark - ...
-(void)addDefault{
    
    NSMutableArray * arrayM = [NSMutableArray array];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_1];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_2];
    [arrayM addObjectsFromArray:TEMPLATE_THEME_3];
    
    self.template_dataSource = arrayM;
    
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.template_dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IS_TempateCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IS_TempateCollectionCell_ID forIndexPath:indexPath];
    NSDictionary * dic = self.template_dataSource [indexPath.row];
    cell.senceTemplatePanModel = [[IS_SenceTemplatePanModel alloc]initWithDictionary:dic];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IS_SenceCreateController * sc = [[IS_SenceCreateController alloc]init];
    [self.navigationController pushViewController:sc animated:YES];
    
}
@end
