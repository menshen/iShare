//
//  iShare_Marco.h
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#ifndef iShare_iShare_Marco_h
#define iShare_iShare_Marco_h

#import "OtherMacro.h"
#import "CategoryMarco.h"


#define temp_url    [[NSBundle mainBundle]URLForResource:@"iShare-Temp" withExtension:@"plist"]
#define temp_dic    [NSDictionary dictionaryWithContentsOfURL:temp_url]
#define temp_array_1  temp_dic[@"iShare_Edit_List"]
#define temp_array_2  temp_dic[@"iShare_Done_List"]
#define temp_array_3  temp_dic[@"iShare_Best_List"]


#define List_URL_1      [[NSBundle mainBundle]URLForResource:@"iShare_Template_List_1" withExtension:@"plist"]
#define List_DIC_1      [NSDictionary dictionaryWithContentsOfURL:List_URL_1]

#define SENCE_1_ARRAY               List_DIC_1[@"Sence_1"]
#define TEMPLATE_THEME_1            List_DIC_1[@"TEMPLATE_THEME_1"]
#define TEMPLATE_THEME_2            List_DIC_1[@"TEMPLATE_THEME_2"]
#define TEMPLATE_THEME_3            List_DIC_1[@"TEMPLATE_THEME_3"]



///1.系统颜色

#define IS_SYSTEM_COLOR Color(84, 163, 250,1)
#define IS_SYSTEM_WHITE_COLOR Color(250, 250, 250,1)
#define IS_HOME_TABLE_COLOR Color(247,247,247,1)

//2.系统通知

#define IS_NOTIFICATION_OPTION @"IS_NOTIFICATION_OPTION"


//D.手势在变化

#define BIG_IMAGE_GESTURE_COLLECTION_VIEW @"BIG_IMAGE_GESTURE_COLLECTION_VIEW"

#pragma mark - ** 一些控件的SIZE

#define IS_NAV_BAR_HEIGHT 65

#define IS_MAIN_TABBAR_HEIGHT 45
#define IS_MAIN_TABBAR_NUM    3
#define IS_MAIN_TABBAR_ITEM_WIDTH  ScreenWidth/IS_MAIN_TABBAR_NUM



#pragma mark - ** UICollectionViewLayoutItemSize **
//1.制作见面卡片大小控制
#define IS_CARD_ITEM_WIDTH  (ScreenWidth-80)
#define IS_CARD_ITEM_HEIGHT (ScreenHeight-65-80-20)
#define IS_CARD_LAYOUT_WIDTH 40
#define IS_CARD_LAYOUT_HEIGHT 10


#define IS_CARD_ZOOM_NUM 3
#define IS_CARD_LITTER_ITEM_WIDTH  (IS_CARD_ITEM_WIDTH)/IS_CARD_ZOOM_NUM
#define IS_CARD_LITTER_ITEM_HEIGHT (IS_CARD_ITEM_HEIGHT)/IS_CARD_ZOOM_NUM

//首页活动展示宏
#define IS_ACTIVITY_ITEM_WIDTH  ScreenWidth
#define IS_ACTIVITY_ITEM_HEIGHT 180

//展示排行视图
#define IS_SHOWRANK_ITEM_WIDTH  ScreenWidth
#define IS_SHOWRANK_ITEM_HEIGHT 100

///案例
#define IS_CASE_ITEM_WIDTH  (ScreenWidth/2 -10)
#define IS_CASE_ITEM_HEIGHT (CASE_ITEM_WIDTH * 1.5)

/**
 *  模板选择器
 */
#define IS_TEMPLATE_ITEM_WIDTH  (ScreenWidth/3 -10)
#define IS_TEMPLATE_ITEM_HEIGHT (IS_TEMPLATE_ITEM_WIDTH * 1.5)




#endif
