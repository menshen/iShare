//
//  SI_SencePanView.m
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SencePanView.h"
#import "IS_SenceTempateItemCell.h"
#import "UIImage+JJ.h"
#import "MJRefresh.h"

@interface IS_SencePanView()


@end

@implementation IS_SencePanView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        //0
//        self.dataSource = [NSMutableArray array];
        
        [self addSubview:self.bottomImageView];
        //1.添加视图到底部
        [self.bottomImageView addSubview:self.tableView];
    }
    return self;
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    //0
    [self addSubview:self.bottomImageView];
   //1.添加视图到底部
    [self.bottomImageView addSubview:self.tableView];
}
-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
    
}
-(UIImageView *)bottomImageView{
    
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bottomImageView.userInteractionEnabled=YES;
        _bottomImageView.image = [UIImage resizedImage:@"IS_Toolbar_up"];
    }
    
    return _bottomImageView;
}

#pragma mark -表视图
-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 0, self.bottomImageView.height, self.bottomImageView.width) style:UITableViewStylePlain];
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.scrollsToTop = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.center = CGPointMake(self.width / 2, self.height / 2+5);
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2); //逆时针旋转90度
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor = [UIColor clearColor];
//        ScreenHeight
//        _tableView.pagingEnabled=YES;
        _tableView.contentInset =UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}
#pragma mark -UITableView_Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return self.dataSource.count;}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 80;}

#pragma mark -动作


//1.
-(void)reloadPanData{
    
    [self.tableView reloadData];

}
//2.点击
-(void)selectPanItem:(IS_SencePanItemDidSelectBlock)sencePanItemDidSelectBlock{self.sencePanItemDidSelectBlock=sencePanItemDidSelectBlock;}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

@end
