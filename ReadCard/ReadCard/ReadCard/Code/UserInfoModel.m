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



/// 调用此方法，获取用户姓名身份证号码信息
/// - Parameters:
///   - inputImage: 图片
///   - cardType: 卡片类型
///   - completion 模型回调
+ (void)getUserInfoModelWithImage:(UIImage *)inputImage withCardType:(CardType)cardType completion:(void (^_Nullable)(UserInfoModel * _Nullable))completion {
    
    ImageProcessor *imageProcessor = [[ImageProcessor alloc] init];
    
    UIImage *image = [imageProcessor processIDCardImage:inputImage withCardType:cardType];
    
    if (image) {
        
        [SwitfTool recognizeTextWithImage:image completion:^(NSString * recognizedText) {
            if (recognizedText) {
                NSLog(@"识别到的文本：%@", recognizedText);
                
                UserInfoModel *model = [UserInfoModel getParsingUserInformationWithStr:recognizedText withCardType:cardType];
                completion(model);
                
            } else {
                NSLog(@"未能识别到文本");
                completion(nil);
            }
        }];
        
    } else {
        NSLog(@"身份证截取图片失败");
        completion(nil);
    }
}


+ (UserInfoModel *)getParsingUserInformationWithStr:(NSString *)recognizedText withCardType:(CardType)cardType {
    
    UserInfoModel *model = [UserInfoModel extractUserInfoFromText:recognizedText withCardType:cardType];
    
    if(model) {
        
        return model;
    }
    
    NSLog(@"未匹配到用户信息");
    return nil;
    
    
}




/// 传入字符串，获取用户名称和身份证字号
/// - Parameters:
///   - text: 字符串
///   - cardType: 卡片类型
+ (UserInfoModel *_Nullable)extractUserInfoFromText:(NSString *_Nullable)text withCardType:(CardType)cardType {
    
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
