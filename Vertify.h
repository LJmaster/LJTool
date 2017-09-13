//
//  Vertify.h
//  News
//
//  Created by 杰刘 on 2017/9/13.
//  Copyright © 2017年 刘杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vertify : NSObject

/**
 *  验证手机号
 */
+ (BOOL)verifyPhoneNum:(NSString *)phone;

/**
 *  验证身份证号
 */
+ (BOOL)verifyIDCardNumber:(NSString *)value;

/**
 *  验证密码
 */
+ (BOOL)vertifyPassword:(NSString *)password;

/**
 *  验证新确认密码
 */
+ (BOOL)vertifyNewPassword:(NSString *)password andPassword:(NSString *)password;

/**
 *  验证验证码
 */
+ (BOOL)vertifyCode:(NSString *)code;

/**
 *  验证字符串是否为空
 */
//+ (BOOL)validString:(NSString *)vertifyCode;
+ (BOOL)validString:(NSString *)vertifyCode;




//过滤表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
