//
//  UserInfoModel.h
//  ReadCard
//
//  Created by 夜猫子 on 2023/10/20.
//

#import <Foundation/Foundation.h>
#import "ImageProcessor.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject

/// 名字
@property(nonatomic,copy)NSString *userName;

/// 身份证号码
@property(nonatomic,copy)NSString *identificationCard;


/// 生日
@property(nonatomic,copy)NSString *birthday;

/// 性别
@property(nonatomic,copy)NSString *gender;

/// 传入字符串，获取用户名称和身份证字号
/// - Parameters:
///   - text: 字符串
///   - cardType: 卡片类型
+ (UserInfoModel *)extractUserInfoFromText:(NSString *)text withCardType:(CardType)cardType;

@end

NS_ASSUME_NONNULL_END
