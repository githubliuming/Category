//
//  NSString+Common.m
//  Category
//
//  Created by liuming on 16/7/12.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

+ (NSString *)emptyString { return @""; }
- (BOOL)isEmptyOrNil
{
    if (self.length > 0)
    {
        NSString *temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (temp.length > 0)
        {
            if ([self isEqualToString:@"nil"] || [self isEqualToString:@"null"] || [self isEqualToString:@"(null)"])
            {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

+ (NSString *)joinArray:(NSArray<NSString *> *)array withString:(NSString *)astring
{
    NSMutableString *temp = [[NSMutableString alloc] init];
    [array enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

        if (idx == 0)
        {
            [temp appendString:obj];
        }
        else
        {
            [temp appendFormat:@"%@%@", astring, obj];
        }
    }];

    return temp;
}
- (BOOL)contains:(NSString *)string { return [self rangeOfString:string].location != NSNotFound; }
- (NSString *)addNewString:(NSString *)aString
{
    if ([self isKindOfClass:[NSMutableString class]])
    {
        [(NSMutableString *)self appendString:aString];
        return self;
    }
    else
    {
        NSString *resultStr = [NSString stringWithFormat:@"%@%@", self, aString];

        return resultStr;
    }
}

- (NSString *)insert:(NSString *)string atIndex:(NSInteger)index
{
    index = MAX(index, 0);
    index = MIN(index, self.length);
    NSString *preString = [self substringToIndex:index];
    NSString *lastString = [self substringFromIndex:index + 1];
    return [NSString stringWithFormat:@"%@%@%@", preString, string, lastString];
}

- (NSString *)deleteString:(NSString *)aString
{
    NSString *tempString = [self stringByReplacingOccurrencesOfString:aString withString:@""];
    return tempString;
}
- (NSString *)convertString
{
    NSInteger count = self.length;
    if (count == 1)
    {
        return self;
    }
    else
    {
        NSMutableString *string = [[NSMutableString alloc] init];
        for (NSInteger i = count - 1; i >= 0; i--)
        {
            NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
            [string appendString:s];
        }

        return string;
    }
}
- (NSInteger)indexOfString:(NSString *)astring { return [self rangeOfString:astring].location; }
- (NSInteger)indexOfArray:(NSArray<NSString *> *)array
{
    __block NSInteger index = NSNotFound;
    [array enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

        if ([obj isEqualToString:self])
        {
            index = idx;
        }
    }];

    return index;
}
- (NSInteger)indexOfArrayCaseInsensitiveSearch:(NSArray<NSString *> *)array
{
    __block NSInteger index = NSNotFound;
    if ([self isEmptyOrNil])
    {
        return index;
    }
    [array enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

        NSComparisonResult result = [self compare:obj options:NSCaseInsensitiveSearch];
        if (result == NSOrderedSame)
        {
            index = idx;
            *stop = YES;
        }
    }];

    return index;
}
- (NSString *)stringAt:(NSInteger)index
{
    if (index < 0 || index > self.length)
    {
        return [NSString emptyString];
    }

    if ([self isEmptyOrNil])
    {
        return [NSString emptyString];
    }

    return [self substringWithRange:NSMakeRange(index, 1)];
}
- (NSString *)stringAt:(NSInteger)index length:(NSInteger)length
{
    if (index < 0 || index > self.length || self.length < index + length)
    {
        return [NSString emptyString];
    }
    if ([self isEmptyOrNil])
    {
        return [NSString emptyString];
    }
    NSRange range = NSMakeRange(index, length);
    return [self substringWithRange:range];
}

- (NSInteger)firstIndexOf:(NSString *)pattern
{
    NSInteger index = NSNotFound;
    for (int i = 0; i < self.length - pattern.length; i++)
    {
        int j = 0;
        while (j < pattern.length)
        {
            NSString *c = [self stringAt:i + j];
            NSString *s = [pattern stringAt:j];

            if (![c isEqualToString:s])
            {
                break;
            }
            j++;
        }
        if (j == pattern.length)
        {
            return i;
        }
    }
    return index;
}
- (NSInteger)lastIndexOf:(NSString *)pattern
{
    for (NSInteger i = self.length - pattern.length; i >= 0; i--)
    {
        int j = 0;
        while (j < pattern.length)
        {
            NSString *c = [self stringAt:i + j];
            NSString *s = [pattern stringAt:j];

            if (![c isEqualToString:s])
            {
                break;
            }
            j++;
        }

        if (j == pattern.length)
        {
            return i;
        }
    }
    return NSNotFound;
}
#pragma mark - 验证
#define MaxEmailLength 254
- (BOOL)isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validEmail = [emailTest evaluateWithObject:self];
    if (validEmail && self.length <= MaxEmailLength) return YES;
    return NO;
}

- (BOOL)isPhone
{
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"self matches %@", phoneRegex];
    BOOL isPhone = [phoneTest evaluateWithObject:self];
    return isPhone;
}
- (BOOL)isValidUrl
{
    NSString *regex = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [urlTest evaluateWithObject:self];
}
@end
