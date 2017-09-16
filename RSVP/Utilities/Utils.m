//
//  Utils.m
//  Antilog Vacations
//
//  Created by Arshdeep Singh on 15/06/15.
//  Copyright (c) 2015 Rootfly Infotech. All rights reserved.
//

#import "Utils.h"

@implementation Utils


/**
 **     Check email format is correct
 **/
+ (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
/**
 **     Check strings are equal
 **/
+ (BOOL)compareStr:(NSString *)str1 with:(NSString *)str2
{
    if ([str1 isEqualToString:str2])
        return YES;
    return NO;
}
/**
 **     Add Padding to TextField
 **/
+ (void)addPaddingOf:(int)padd to:(UITextField *)txtField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padd, padd)];
    txtField.leftView = paddingView;
    txtField.leftViewMode = UITextFieldViewModeAlways;
}

/**
 **     Add Padding to TextField
 **/
+ (void)addCustomFont:(NSString *)fontName size:(CGFloat)sizeFont to:(id)idField
{
    UIFont *font = [UIFont fontWithName:fontName size:sizeFont];
    if ([idField isKindOfClass:[UITextField class]])
    {
        UITextField *txf = (UITextField *)idField;
        [txf setFont:font];
    }
    else
        if ([idField isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)idField;
            [btn.titleLabel setFont:font];
        }
        else
            if ([idField isKindOfClass:[UILabel class]])
            {
                UILabel *lbl = (UILabel *)idField;
                [lbl setFont:font];
            }
}

/**
 **     Remove white Spaces
 **/
+ (NSString *)removeWhiteSpaces:(NSString *)strInput
{
    NSCharacterSet *whitespace  = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString     = [strInput stringByTrimmingCharactersInSet:whitespace];
    return trimmedString;
}

/**
 **     OK Alert
 **/
+ (void)okAlert:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
        [appDelegate().window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alert addAction:ok];
    [appDelegate().window.rootViewController presentViewController:alert animated:YES completion:nil];
}


//>>>>>>>>> Image Merge Method <<<<<<<<<<<<//


+(UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    
    UIImage *image = nil;
    
    CGSize newImageSize = CGSizeMake(MAX(firstImage.size.width, secondImage.size.width), MAX(firstImage.size.height, secondImage.size.height));

    UIGraphicsBeginImageContext(newImageSize);
    

    [firstImage drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
    [secondImage drawAtPoint:CGPointMake(roundf((newImageSize.width-secondImage.size.width)/2),
                                         roundf((newImageSize.height-secondImage.size.height)/2))];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            processImage(imageData);
        });
    });
}

//>>>>>>>>>>>>> Remove Null Value from Dictionory <<<<<<<<<<<< //

+ (NSDictionary *)dictionaryByReplacingNullsWithStrings :(NSDictionary *)Dict {
    const NSMutableDictionary *replaced = [Dict mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for(NSString *key in Dict) {
        const id object = [Dict objectForKey:key];
        if(object == nul) {
            //pointer comparison is way faster than -isKindOfClass:
            //since [NSNull null] is a singleton, they'll all point to the same
            //location in memory.
            [replaced setObject:blank
                         forKey:key];
        }
    }
    
    return [replaced copy];
}



//>>>>>>>> Calucalte Height of String <<<<<<<<<<<<//

+ (CGSize)calculateHeightForString:(NSString *)str havingWidth:(CGFloat)widthValue FontSize:(CGFloat)fontSize
{
    CGSize size = CGSizeZero;
    
    UIFont *labelFont = [UIFont systemFontOfSize:fontSize];
    
    CGRect rect = [str boundingRectWithSize:(CGSize){widthValue, MAXFLOAT}
                                    options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:labelFont }
                                        context:nil];
                                    //   you need to specify the some width, height will be calculated
    size = CGSizeMake(rect.size.width, rect.size.height + 5); //padding
    
    return size;
    
    
}

//>>>>>>>>> Base64 <<<<<<<<<//

+ (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

// >>>>>>>>> Color to Image <<<<<<<<//

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//>>>>>> Remove HTML Tag <<<<<<<<<<<<//

+(NSString *) stringByStrippingHTML:(NSString *)str{
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
    return [attr string];

}

//>>>>> Time Compare <<<<<<<<<<<<//

+(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate {
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    hour = [components hour];
    minutes = [components minute];
    
    if (days > 0) {
        
        if (days > 1) {
            
           // days
            
            durationString = [NSString stringWithFormat:@"%ld", (long)days];
        }
        else {
            
           // day
            durationString = [NSString stringWithFormat:@"%ld", (long)days];
        }
        return durationString;
    }
    
    if (hour > 0) {
        
        if (hour > 1) {
           // hours
            durationString = [NSString stringWithFormat:@"%ld", (long)hour];
        }
        else {
            //hour
            durationString = [NSString stringWithFormat:@"%ld", (long)hour];
        }
        return durationString;
    }
    
    if (minutes > 0) {
        
        if (minutes > 1) {
            
            //minutes
            durationString = [NSString stringWithFormat:@"%ld", (long)minutes];
        }
        else {
            //minute
            durationString = [NSString stringWithFormat:@"%ld", (long)minutes];
        }
        return durationString;
    }
    
    return @"";
}

// Compress image Size ///

+(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}


@end
