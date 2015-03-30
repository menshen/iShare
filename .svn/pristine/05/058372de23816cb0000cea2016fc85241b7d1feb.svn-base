//
//  IS_SenceShareController.m
//  iShare
//
//  Created by 伍松和 on 15/3/10.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SenceShareController.h"
#import "OrderedDictionary.h"
#import "IS_ShareMusicCell.h"
@interface IS_SenceShareController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UIView * share_view;

@property (nonatomic ,strong)UICollectionView * effect_collectionView;

@property (nonatomic ,strong)NSMutableArray * musicArrayM;

@end

@implementation IS_SenceShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     MutableOrderedDictionary*sectionDic=[[MutableOrderedDictionary alloc]initWithCapacity:0];
    
    
    //1.
    [sectionDic setObject:@[self.share_view]?@[self.share_view]:[NSNull null] forKey:@"A 分享语"];
    
    //2.效果
//    [sectionDic setObject:a2?a2:[NSNull null] forKey:@"B 正在申请企业"];
    
    //3.背景音乐
    NSArray * arrayM = @[@"无",@"甜蜜蜜",@" sweet",@"someone like you"];
    [sectionDic setObject:arrayM?arrayM:[NSNull null] forKey:@"C 背景音乐"];
    
    self.sectionDictionary=sectionDic;

    
}
#pragma mark - A
-(UIView * )share_view{
    
    UIView * a = [[NSBundle mainBundle]loadNibNamed:@"IS_SenceShareController" owner:nil options:nil][1];
    return a;
    

}
-(UICollectionView *)effect_collectionView{
    
    return nil;
}
-(NSMutableArray *)musicArrayM{

    if (!_musicArrayM) {
        _musicArrayM = [NSMutableArray array];
    }
    return _musicArrayM;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 0:
        {
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
            
            IS_ShareMusicCell * cell = [tableView dequeueReusableCellWithIdentifier:IS_ShareMusicCell_ID];
            [UITableViewCell configureCellWithClass:[IS_ShareMusicCell class] WithCellID:IS_ShareMusicCell_ID WithTableView:tableView];
            
            return cell;
             break;
        }
           
            
        default:
            break;
    }
    
    return nil;
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
