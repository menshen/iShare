



#import <Foundation/Foundation.h>

@interface NSString (JJ)
/**
 *  MD5Hash
 */
- (NSString *)MD5Hash;
/**
 *  stringByTrimingWhitespace
 */
- (NSString *)stringByTrimingWhitespace;
/**
 *  行数
 */
- (NSUInteger)numberOfLines;
/**
 *  计算文章size
 */
- (CGSize)sizeWithFont:(UIFont*)font
              maxSize:(CGSize)maxSize;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

/**
 *  用 json 路径生成对象
 *
 *  @param jsonPath json路径
 *
 *  @return 数组/字典/etc
 */
+ (id)objectFromJsonFilePath:(NSString*)jsonPath;
/**
 *  对象转 json
 */
+ (NSString*)jsonFromObject:(id)object;
@end
