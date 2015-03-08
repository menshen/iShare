//
//  IS_HomeController.m
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_HomeController.h"
#import "IS_SenceCreateController.h"
#import "IS_WebContentController.h"
#import "IS_LoginController.h"


#import "IS_SenceModel.h"
#import "IS_BaseCell.h"
#import "IS_SenceEditTool.h"
#import "IS_SencePageController.h"
#import "IS_SenceCollectionController.h"

@interface IS_HomeController ()
@end

@implementation IS_HomeController
-(void)viewDidLoad{
    //0.
    
    [super viewDidLoad];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=kColor(249, 249, 249);
    self.title = @"爱分享";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_add_icon"
                                                           highlightedIcon:@"nav_add_icon"
                                                                    target:self
                                                                     action:@selector(jumpToSenceChooseController:)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_list_icon"
                                                           highlightedIcon:@"nav_list_icon"
                                                                    target:self
                                                                    action:@selector(jumpToSenceList:)];

    
    //1.
    WEAKSELF;
    [self.tableView addHeaderWithCallback:^{
      
        [weakSelf loadLocalData];
    }];
//    [self loadLocalData];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self loadLocalData];
}
-(void)loadMoreData{
    
    NSMutableArray * a1=[self.sectionDictionary objectForKey:@"C 优秀案例"];
    IS_SenceModel * senceModel = [[IS_SenceModel alloc]initWithDictionary:@{@"i_image":@"IS_icon-1",
                                                                            @"i_name":@"插入",
                                                                            @"i_title":@"车市"}];
    [a1 addObject:senceModel];
    [self.sectionDictionary setObject:a1 forKey:@"C 优秀案例"];

    
    NSIndexPath  * indexPath  = [NSIndexPath indexPathForRow:a1.count-1 inSection:2];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView headerEndRefreshing];

}

#pragma mark -加载数据
-(void)loadLocalData{

    
    //1.
    NSArray * sence_array_1 =temp_array_1;
    NSMutableArray * arrayM1= [NSMutableArray array];
//    for (NSDictionary * dic in sence_array_1) {
//        IS_SenceModel * senceModel = [[IS_SenceModel alloc]initWithDictionary:dic];
//      //  [arrayM1 addObject:senceModel];
//      
//        
//        
//    }
    //b.还有数据库的
    NSMutableArray * array_sence= [IS_SenceModel queryFormDB:nil orderBy:nil count:10 success:nil];
    [arrayM1 addObjectsFromArray:array_sence];
    [self.sectionDictionary setObject:arrayM1 forKey:@"A 编辑中"];
    
    //2.
    NSArray * sence_array_2 =temp_array_2;
    NSMutableArray * arrayM2= [NSMutableArray array];
    for (NSDictionary * dic in sence_array_2) {
        IS_SenceModel * senceModel = [[IS_SenceModel alloc]initWithDictionary:dic];
        [arrayM2 addObject:senceModel];
    }
    [self.sectionDictionary setObject:arrayM2 forKey:@"B 已完成"];
    
    
    //3.
    NSArray * sence_array_3 =temp_array_3;
    NSMutableArray * arrayM3= [NSMutableArray array];
    for (NSDictionary * dic in sence_array_3) {
        IS_SenceModel * senceModel = [[IS_SenceModel alloc]initWithDictionary:dic];
        [arrayM3 addObject:senceModel];
    }
    [self.sectionDictionary setObject:arrayM3 forKey:@"C 优秀案例"];
    
    
    [self reloadTableData];
}
#pragma mark -跳转到模板选择器
-(void)jumpToSenceChooseController:(UIBarButtonItem*)item{
    
    IS_SenceCollectionController * SencePageController = [[IS_SenceCollectionController alloc]init];
//    IS_SencePageController * SencePageController = [[IS_SencePageController alloc]init];
//    IS_SenceCreateController * sence_choose_ctrl = [[IS_SenceCreateController alloc]init];//
        [self.navigationController pushViewController:SencePageController animated:YES];

}
#pragma mark -选择菜单
-(void)jumpToSenceList:(UIBarButtonItem*)item{
        // Init dropdown view
    
    IS_LoginController * loginCtrl = [[IS_LoginController alloc]init];
    [self.navigationController pushViewController:loginCtrl animated:YES];

}
#pragma mark -Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID= @"sence_cell";
    
  
    
    
    IS_BaseCell * cell = [IS_BaseCell configureCellWithClass:[IS_BaseCell class] WithCellID:cellID WithTableView:tableView];
    
    NSArray * arrayM=self.sectionDictionary.allValues;
    cell.indexPath=indexPath;
    cell.senceModel=arrayM[indexPath.section][indexPath.row];
    cell.rightButtons=[self createRightButtons];
    
    cell.tag=indexPath.row;
    
    return cell;

}

-(NSArray *) createRightButtons
{
    NSMutableArray * result = [NSMutableArray array];
    NSArray * titleArray =@[@"     删除     ",@"   编辑     "];
    NSArray *colorArray=@[[UIColor redColor],[UIColor lightGrayColor]];;
    for (int i = 0; i < titleArray.count; ++i)
    {
        
        MGSwipeButton * button=nil;
        button.tag=i;
        if (i==0) {
            button = [MGSwipeButton buttonWithTitle:titleArray[i] backgroundColor:colorArray[i] callback:^BOOL(MGSwipeTableCell *sender) {
      
                return YES;
            }];
        }else if (i==1){
            button = [MGSwipeButton buttonWithTitle:titleArray[i] backgroundColor:colorArray[i] callback:^BOOL(MGSwipeTableCell *sender) {
                //[self jumpToPerson:indexPath];
                NSArray * a1 = [self.sectionDictionary objectForKey:@"A 编辑中"];
                IS_SenceModel * s =  a1[sender.tag];
                if (s) {
                    IS_SenceCreateController * senceCreateController = [[IS_SenceCreateController alloc]init];
                    senceCreateController.senceModel = s;
                    [self.navigationController pushViewController:senceCreateController animated:YES];
                }
                return YES;
            }];
        }
        
        
        [result addObject:button];
    }
    return result;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //0.
    NSArray * arrayM=self.sectionDictionary.allValues;
    IS_SenceModel * senceModel = arrayM[indexPath.section][indexPath.row];
    
    //1
//    IS_SenceController * senceController = [[IS_SenceController alloc]initWithURLString:senceModel.i_url];
//    
//    //2.
//    senceController.title=senceModel.i_title;
    
    
    IS_SencePageController * sv = [[IS_SencePageController alloc]init];
    
    //3.
    [self.navigationController pushViewController:sv animated:YES];

    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 75;}
@end
