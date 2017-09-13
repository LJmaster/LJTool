//
//  Vertify.m
//  News
//
//  Created by 杰刘 on 2017/9/13.
//  Copyright © 2017年 刘杰. All rights reserved.
//

#import "Vertify.h"

@implementation Vertify
// 手机号码验证
+ (BOOL)verifyPhoneNum:(NSString *)phone
{
    if ([self validString:phone]) {
        return NO;
    }
    NSString *match = @"(^[1][34578][0-9]{9}$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@",match];
    return [predicate evaluateWithObject:phone];
}

// 身份证验证
+ (BOOL)verifyIDCardNumber:(NSString *)value
{
    if ([self validString:value]) {
        return NO;
    }
    // 去除特殊符号
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 判断传进来的参数是否为18位
    if ([value length] != 18) {
        return NO;
    }
    // 前两位(代表省份)必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    // 闰年的2月份是29天
    NSString *leapMmdd = @"0229";
    // 只是19和20开头的年份有效
    NSString *year = @"(19|20)[0-9]{2}";
    // 计算闰年年份
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    // 计算出生年月日
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    // 闰年的出生年月日
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    // 判断出生日期
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    // 地区
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    // 正则表达式
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    // 校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    // 余数 ＝ 校验和 % 11
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    // 最后一位的身份证号码为checkString
    NSString *checkString = @"10X98765432";
    // 判断校验位
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

// 密码验证
+ (BOOL)vertifyPassword:(NSString *)password {
    if (![self validString:password]) {
        if (password.length >=6 && password.length <= 12 ) {
            return YES;
        }
    }
    return NO;
}

// 确认密码验证
+ (BOOL)vertifyNewPassword:(NSString *)newPassword andPassword:(NSString *)password {
    if ([newPassword isEqualToString:password]) {
        return YES;
    }
    return NO;
}

// 验证码验证
+ (BOOL)vertifyCode:(NSString *)code {
    if (![self validString:code]) {
        if (code.length == 4) {
            code = [code stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
            if(code.length == 0)
            {
                return YES;
            }
        }
    }
    return NO;
}

// 验证字符串是否为空
+ (BOOL)validString:(NSString *)vertifyCode {
    NSString * verty = [vertifyCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (verty && ![verty isEqualToString:@""]) {
        return NO;
    }
    return YES;
}



//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
