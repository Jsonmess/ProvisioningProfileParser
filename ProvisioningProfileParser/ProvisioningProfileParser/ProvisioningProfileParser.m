//
//  ProvisioningProfileParser.m
//  ProvisioningProfileParser
//
//  Created by jsonmess on 2023/10/13.
//

#import "ProvisioningProfileParser.h"
@interface ProvisioningProfileParser()
@property(strong,nonatomic)NSDateFormatter *dateFormatter;

@property (strong, nonatomic)  NSBundle *mBundle;//当前描述文件所在bundle
@property (copy, nonatomic)  NSString *mFileName;//当前描述文件名称

@end
@implementation ProvisioningProfileParser


- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    //初始化日期格式(根据目前provisioning file 描述文件date 格式来定义配置)
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setLocale: [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [self.dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [self.dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    //初始化 访问目录
    self.mBundle = [NSBundle mainBundle];
    self.mFileName = @"embedded.mobileprovision";
}

//获取   默认mainBundle 下“embedded.mobileprovision”
- (void)fetchLocaProvisioningProfile:(void (^)(ProvisionProfileInfo *profile, NSError *error))completion {
    
    //缺省目录 为默认
    self.mBundle = [NSBundle mainBundle];
    self.mFileName = @"embedded.mobileprovision";
    [self parserProvisionfileWithCompleted:completion];
}

//获取指定的provisionProfile 文件
- (void)fetchLocaProvisioningProfileWithBundle:(NSBundle*)bundle
                                                        fileName:(NSString*)fileName
                                                       completed:(void (^)(ProvisionProfileInfo *profile, NSError *error))completion{
    self.mBundle = bundle;
    self.mFileName = fileName;
    [self parserProvisionfileWithCompleted:completion];
}


- (void)parserProvisionfileWithCompleted:(void (^)(ProvisionProfileInfo *profile, NSError *error))completion {
    NSBundle *bundle = self.mBundle;
    NSString *fileName = self.mFileName;
    //1.判断空情况处理
    NSURL *fileUrl = [bundle URLForResource:fileName withExtension:nil];
    if (nil == fileUrl) {
        NSError * error = [NSError errorWithDomain:@"fetch provisioningfile faild，file not exist" code:-1001  userInfo:nil];
        completion ? completion(nil,error): NULL;
        return;
    }
    NSData *fileData = [NSData dataWithContentsOfURL:fileUrl];
    NSString *fileContent = [[NSString alloc] initWithData:fileData encoding:NSASCIIStringEncoding];
    if (nil == fileContent) {
        NSError * error = [NSError errorWithDomain:@"fetch provisioningfile data content faild" code:-1001  userInfo:nil];
        completion ? completion(nil,error): NULL;
        return;
    }
    //2.开始解析
    ProvisionProfileInfo *profileInfo = [[ProvisionProfileInfo alloc] init];
    //2.1 CreationDate，创建日期
    NSString *creationDateStr = [self extractValueFrom:@"CreationDate" type:@"date" content:fileContent];
    if (creationDateStr) {
        profileInfo.certificateCreateTime = creationDateStr;
        profileInfo.certificateCreateDate = [self.dateFormatter dateFromString:creationDateStr];
    }
    //2.2 ExpirationDate，过期日期
    NSString *expirationDateStr = [self extractValueFrom:@"ExpirationDate" type:@"date" content:fileContent];
    if (expirationDateStr) {
        profileInfo.provisionExpiry = expirationDateStr;
        profileInfo.provisionExpiryDate = [self.dateFormatter dateFromString:expirationDateStr];
    }
    //2.3 provisioning Name
    NSString *nameStr = [self extractValueFrom:@"Name" type:@"string" content:fileContent];
    profileInfo.provisionName = nameStr;
    //2.4 TeamName
    NSString *teamName = [self extractValueFrom:@"TeamName" type:@"string" content:fileContent];
    profileInfo.team = teamName;
    
    completion ? completion(profileInfo,nil): NULL;
}

- (nullable NSString *)extractValueFrom:(NSString *)key type:(NSString*)type content:(NSString*)fileContent {
    NSScanner *scanner = [NSScanner scannerWithString:fileContent];
    //1.扫描到<key>${key}<key>这位置
    NSString *keyReg = [NSString stringWithFormat:@"<key>%@</key>",key];
    BOOL status =  [scanner scanUpToString:keyReg intoString:nil];
    //2.扫描下一行，就是value 对 ，如 <date>xxx</date>
    NSString *typeReg = [NSString stringWithFormat:@"<%@>",type];
    status = [scanner scanUpToString:typeReg intoString:nil];
    //3.提取value
    status = [scanner scanString:typeReg intoString:nil];
    NSString *theValue = nil;
    NSString *endTypeReg = [NSString stringWithFormat:@"</%@>",type];
    status =  [scanner scanUpToString:endTypeReg intoString:&theValue];
    return  theValue;
}

@end
