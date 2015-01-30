//
//  iShare_Marco.h
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#ifndef iShare_iShare_Marco_h
#define iShare_iShare_Marco_h

#define temp_url    [[NSBundle mainBundle]URLForResource:@"iShare-Temp" withExtension:@"plist"]
#define temp_dic    [NSDictionary dictionaryWithContentsOfURL:temp_url]
#define temp_array_1  temp_dic[@"iShare_Edit_List"]
#define temp_array_2  temp_dic[@"iShare_Done_List"]
#define temp_array_3  temp_dic[@"iShare_Best_List"]


#define List_URL_1      [[NSBundle mainBundle]URLForResource:@"iShare_Template_List_1" withExtension:@"plist"]
#define List_DIC_1      [NSDictionary dictionaryWithContentsOfURL:List_URL_1]
#define List_Array_1    List_DIC_1[@"First_Template"]


#import "CategoryMarco.h"


///1.系统颜色

#define IS_SYSTEM_COLOR kColor(0, 157, 255)



//2.系统通知

#define IS_NOTIFICATION_OPTION @"IS_NOTIFICATION_OPTION"

//A.当点击大图时候

//#define IS_SenceCreateViewDidChangeImage @"IS_SenceCreateViewDidChangeImage"

#define BIG_IMAGE_TO_IMAGE_PAN  @"BIG_IMAGE_TO_IMAGE_PAN" //跳转到图片选择器,告诉它是否选择,选择的图片是什么,tag 是多少
#define BIG_IMAGE_TO_COLLECTION_VIEW @"BIG_IMAGE_TO_COLLECTION_VIEW" //告诉滑动视图,现在选择的数据改变了
#define BIG_IMAGE_TO_CONTROLLER @"BIG_IMAGE_TO_CONTROLLER" //告诉控制器，是否选择图片
//B.点击缩略图
//#define IS_SenceCreateViewDidChangeThumbnailImage @"IS_SenceCreateViewDidChangeThumbnailImage"
#define THUMBNAIL_IMAGE_TO_COLLECTION_VIEW @"THUMBNAIL_IMAGE_TO_COLLECTION_VIEW" //告诉滑动视图当前视图,插入或者替换
#define THUMBNAIL_IMAGE_TO_CONTROLLER @"THUMBNAIL_IMAGE_TO_CONTROLLER" //告诉控制器，是否选择图片


//C.当模板改变时候->选择模板,滑动改变模板时候
//#define IS_SenceCreateViewDidChangeTemplate @"IS_SenceCreateViewDidChangeTemplate"
#define TEMPLATE_TO_COLLECTION_VIEW_BY_TAP  @"TEMPLATE_TO_COLLECTION_VIEW_BY_TAP" //通过点击，通知滑动视图当前项改变
#define COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN  @"COLLECTION_VIEW_SCROLL_CHANGE_TEMPLATE_PAN" //滑动新视图/滚,令模板选择器适当高亮
#define TEMPLATE_TO_CONTROLLER_BY_SCROLL  @"TEMPLATE_TO_CONTROLLER_BY_SCROLL"





//D.手势在变化

#define BIG_IMAGE_GESTURE_COLLECTION_VIEW @"BIG_IMAGE_GESTURE_COLLECTION_VIEW"




#endif
