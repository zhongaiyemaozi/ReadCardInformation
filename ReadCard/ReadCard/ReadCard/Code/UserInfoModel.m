//
//  UserInfoModel.m
//  ReadCard
//
//  Created by 夜猫子 on 2023/10/20.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (NSString *)userName {
    if(!_userName) {
        _userName = @"";
    }
    return _userName;
}

- (NSString *)identificationCard {
    if(!_identificationCard) {
        _identificationCard = @"";
    }
    return _identificationCard;
}

- (NSString *)birthday {
    if(!_birthday) {
        _birthday = @"";
    }
    return _birthday;
}

- (NSString *)gender {
    if(!_gender) {
        _gender = @"";
    }
    return _gender;
}

/// 传入字符串，获取用户名称和身份证字号
/// - Parameters:
///   - text: 字符串
///   - cardType: 卡片类型
+ (UserInfoModel *)extractUserInfoFromText:(NSString *)text withCardType:(CardType)cardType {
    
    UserInfoModel *model = [[UserInfoModel alloc] init];
    
    NSString *nameRegexPattern = (cardType == CardTypeSocialSecurityCard) ?
    @"姓名\\s(\\S+)" :
    @"姓名(\\S+)\\s.";
    
    // 提取姓名
    NSRegularExpression *nameRegex = [NSRegularExpression regularExpressionWithPattern:nameRegexPattern options:0 error:nil];
    NSTextCheckingResult *nameMatch = [nameRegex firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
    
    if (nameMatch) {
        NSString *name = [UserInfoModel matchedStringForRange:[nameMatch rangeAtIndex:1] inText:text];
        model.userName = name;
    } else {
        NSLog(@"未匹配到姓名");
    }

    // 提取身份证号码或社会保障号码
    NSString *idNumberRegexPattern = (cardType == CardTypeSocialSecurityCard) ?
        @".*社会保障号码\\s(\\d{18})" :
        @".*身份证号码\\s(\\d{18})";

    NSRegularExpression *idNumberRegex = [NSRegularExpression regularExpressionWithPattern:idNumberRegexPattern options:0 error:nil];
    NSTextCheckingResult *idNumberMatch = [idNumberRegex firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];

    if (idNumberMatch) {
        NSString *idNumber = [UserInfoModel matchedStringForRange:[idNumberMatch rangeAtIndex:1] inText:text];
        model.identificationCard = idNumber;
        
        // 更新生日和性别信息
        model = [UserInfoModel updateUserInfoWithBirthdayAndGender:model];
    } else {
        NSLog(@"未匹配身份证号码或社会保障号码");
    }

    // 如果姓名或身份证号码任意一个匹配成功，则返回模型
    if (model.userName.length > 0 || model.identificationCard.length > 0) {
        return model;
    }

    return nil;
}


+ (NSString *)matchedStringForRange:(NSRange)range inText:(NSString *)text {
    return (range.location != NSNotFound) ? [text substringWithRange:range] : @"";
}


+ (UserInfoModel *)updateUserInfoWithBirthdayAndGender:(UserInfoModel *)userInfo {
    
    if (userInfo.identificationCard.length == 18) {
        NSString *year = [userInfo.identificationCard substringWithRange:NSMakeRange(6, 4)];
        NSString *month = [userInfo.identificationCard substringWithRange:NSMakeRange(10, 2)];
        NSString *day = [userInfo.identificationCard substringWithRange:NSMakeRange(12, 2)];

        // 根据身份证号码获取生日
        userInfo.birthday = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];

        // 根据身份证号码获取性别
        NSInteger genderDigit = [[userInfo.identificationCard substringWithRange:NSMakeRange(16, 1)] integerValue];
        userInfo.gender = (genderDigit % 2 == 0) ? @"女" : @"男";
    }

    return userInfo;
}



@end
