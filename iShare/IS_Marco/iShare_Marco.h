
#ifndef iShare_iShare_Marco_h
#define iShare_iShare_Marco_h

#import "OtherMacro.h"
#import "CategoryMarco.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "FrameMarco.h"

#define WX_APPID      @"wx1963e5988407bbc7"
#define WX_APPSECRET  @"118982dc53b8fa79cc68ca55f08f6b9b"

///1.系统颜色

#define IS_SYSTEM_COLOR Color(84, 163, 250,1)
#define IS_SYSTEM_WHITE_COLOR Color(250, 250, 250,1)
#define IS_HOME_TABLE_COLOR Color(247,247,247,1)

//2.系统通知

#define IS_NOTIFICATION_OPTION @"IS_NOTIFICATION_OPTION"

//3.系统占位符
#define IS_PLACE_IMG_NAME @"IS_icon-1"
#define IS_PLACE_IMG [UIImage imageNamed:IS_PLACE_IMG_NAME]

//D.手势在变化

#define BIG_IMAGE_GESTURE_COLLECTION_VIEW @"BIG_IMAGE_GESTURE_COLLECTION_VIEW"





#pragma mark  -***临时**
/*!
 *  临时数据
 */

#define temp_url    [[NSBundle mainBundle]URLForResource:@"iShare-Temp" withExtension:@"plist"]
#define temp_dic    [NSDictionary dictionaryWithContentsOfURL:temp_url]
#define List_URL_1      [[NSBundle mainBundle]URLForResource:@"iShare_Template_List_1" withExtension:@"plist"]
#define List_DIC_1      [NSDictionary dictionaryWithContentsOfURL:List_URL_1]

#define SENCE_1_ARRAY               List_DIC_1[@"Sence_1"]
#define TEMPLATE_THEME_1            List_DIC_1[@"TEMPLATE_THEME_1"]
#define TEMPLATE_THEME_2            List_DIC_1[@"TEMPLATE_THEME_2"]
#define TEMPLATE_THEME_3            List_DIC_1[@"TEMPLATE_THEME_3"]



#endif
