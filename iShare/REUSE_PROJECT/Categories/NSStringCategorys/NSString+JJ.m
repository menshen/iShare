//
//  NSString+JJ.m
//  易商
//
//  Created by 伍松和 on 14/10/23.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "NSString+JJ.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (JJ)
/**
 *  MD5Hash
 */
- (NSString *)MD5Hash{
    
    if(self.length == 0) {
        return nil;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}
/**
 *  stringByTrimingWhitespace
 */
- (NSString *)stringByTrimingWhitespace{

    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

}
/**
 *  行数
 */
- (NSUInteger)numberOfLines{

    return [[self componentsSeparatedByString:@"\n"] count] + 1;

}
/**
 *  计算文章size
 */
- (CGSize)sizeWithFont:(UIFont*)font
               maxSize:(CGSize)maxSize{

    NSDictionary * attrs=@{NSFontAttributeName: font};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/**
 *  URL解码

 */
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    
    return result;	
}
#pragma mark -json->对象
+ (id)objectFromJsonFilePath:(NSString*)jsonPath{

    //处理json数据
//    if ([NSFileManager defaultManager) {
//        <#statements#>
//    }
    
    //0.默认是 mainBundle
    NSURL * json_file_url = [[NSBundle mainBundle]URLForResource:jsonPath withExtension:@"json"];
    
    //1.不是就是沙盒
    if (!json_file_url) {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:json_file_url];
    
    
    NSError * error= nil;
   id jsonObejct = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return jsonObejct;

}
+ (NSString*)jsonFromObject:(id)object{

    
    if ([NSJSONSerialization isValidJSONObject:object])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

@end
