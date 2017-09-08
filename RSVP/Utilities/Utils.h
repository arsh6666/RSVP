//
//  Utils.h
//  Antilog Vacations
//
//  Created by Arshdeep Singh on 15/06/15.
//  Copyright (c) 2015 Rootfly Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (BOOL)isValidEmail:(NSString *)checkString;
+ (NSString *)removeWhiteSpaces:(NSString *)strInput;
+ (BOOL)compareStr:(NSString *)str1 with:(NSString *)str2;
+ (void)addPaddingOf:(int)padd to:(UITextField *)txtField;
+ (void)addCustomFont:(NSString *)fontName size:(CGFloat)sizeFont to:(id)idField;
+ (void)okAlert:(NSString *)title message:(NSString *)message;
+ (CGSize)calculateHeightForString:(NSString *)str havingWidth:(CGFloat)widthValue FontSize : (CGFloat)fontSize;
+ (NSString *)encodeToBase64String:(UIImage *)image;
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;
+(UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (NSDictionary *)dictionaryByReplacingNullsWithStrings :(NSDictionary *)Dict;
+(NSString *) stringByStrippingHTML:(NSString *)str;
+(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
