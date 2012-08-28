//
//  DBData.m
//  MPNBurn
//
//  Created by Grace on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// 2009/07/21 update by Grace Liu

#import "DBData.h"
#import "DBConnect.h"

@implementation DBData

// 用途:查詢model name
// 輸入:void
// 輸出:Array
- (NSArray *)getModel
{
	@try{
		// Read connection data
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];
		
		// Load MPN datas
		DBConnect *ModelDBConnect = [[DBConnect alloc] init];
		NSArray * ModelArray = [ModelDBConnect queryDataUseIACPBsqldb:userName 
															 password:passWord 
														   servername:serverName 
															   dbname:dbName
															 commands:@"exec uspSFCGetModelList"];
		[DBConnections release];
		[ModelDBConnect release];
		return [ModelArray autorelease];
	}
	@catch (NSException *exception) {
		// NSRunAlertPanel(@"Exception", [NSString stringWithFormat:@"Error: %@", [exception reason]],@"OK",nil,nil);
		NSRunAlertPanel(@"Exception", [NSString stringWithFormat:@"Error: SFC is not ready:%@", [exception reason]],@"OK",nil,nil);
		return nil;
	}
	return nil; 
}

// 用途:查詢Region Key
// 輸入:NSString (model name)
// 輸出:NSString (Region Key)
- (NSString *)getRegionKey:(NSString *)modelName
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];
		
		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCGetModelRegionKey '%@'",modelName];
		
		DBConnect *regionKeyDBConnect = [[DBConnect alloc] init];
		NSArray * regionKeyArray = [regionKeyDBConnect queryDataUseIACPBsqldb:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
   										       commands:commandString];
		NSString *regionKey = [[NSString alloc] initWithFormat:@"%@",[regionKeyArray objectAtIndex:0]];
		[DBConnections release];
		[regionKeyDBConnect release];
		[regionKeyArray release];
	if([[[regionKey substringFromIndex:3] substringToIndex:1]isEqualToString:@" "] )
		return [[regionKey substringToIndex:3] autorelease];
	else
		return [[regionKey substringToIndex:4] autorelease];
		//return [regionKey autorelease];									   
}


// 用途:查詢MPN Code
// 輸入:NSString (model name)
// 輸出:NSString (MPN Code)
- (NSString *)getMPNCode:(NSString *)modelName
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];
		
		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCGetModelMPN '%@'",modelName];
		
		DBConnect *mpnDBConnect = [[DBConnect alloc] init];
		NSArray * mpnArray = [mpnDBConnect queryDataUseIACPBsqldb:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
											   commands:commandString];
		NSString *mpnCode = [[NSString alloc] initWithFormat:@"%@",[mpnArray objectAtIndex:0]];
		[DBConnections release];
		[mpnDBConnect release];
		[mpnArray release];

		return [[mpnCode substringToIndex:5] autorelease];									   
}


// 用途:check MLBSN(13碼序號) & return FGSN(11碼序號)
// 輸入:MLBSN(13碼序號) ＆ station name
// 輸出:以Array方式輸出, array[0]為0(成功)或1(失敗), array[1]為錯誤訊息, array[2]為FGSN(11碼序號)
- (NSArray *)checkCMLBSNWC:(NSString *)MLBSN station:(NSString *)stationName
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];
		
		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCCheckCMBSNWc '%@', '%@'",MLBSN,stationName];
		
		DBConnect *CMBSNDBConnect = [[DBConnect alloc] init];
		NSArray * CMBSNArray = [CMBSNDBConnect queryDataRetWithSemicolon:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
											   commands:commandString];
		[DBConnections release];
	if ([[CMBSNArray objectAtIndex:0] isEqualToString:@"3"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号验证失败,正确站别:%@",[CMBSNArray objectAtIndex:2]];
		[tmpArray addObject:@"3"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CMBSNArray objectAtIndex:0] isEqualToString:@"1"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"客户序号验证失败,序号不存在"];
		[tmpArray addObject:@"1"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CMBSNArray objectAtIndex:0] isEqualToString:@"2"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"站点验证失败,此站点不存在"];
		[tmpArray addObject:@"2"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CMBSNArray objectAtIndex:0] isEqualToString:@"7"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"MLB序号:%@ 验证失败,序号不存在",MLBSN];
		[tmpArray addObject:@"7"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else
	{
		return [CMBSNArray autorelease];
	}
}

// 用途:check FGSN(11碼序號)
// 輸入:FGSN(11碼序號) ＆ station name
// 輸出:以Array方式輸出, array[0]為0(成功)或1(失敗), array[1]為錯誤訊息
- (NSArray *)checkCFGSNWC:(NSString *)FGSN station:(NSString *)stationName UserID:(NSString *)userId linename:(NSString *)LineName
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];
		
		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCCheckCFGSNWc '%@', '%@', '%@', '%@'",FGSN,stationName,userId,LineName];
		
		DBConnect *CFGSNDBConnect = [[DBConnect alloc] init];
		NSArray * CFGSNArray = [CFGSNDBConnect queryDataRetWithSemicolon:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
											   commands:commandString];
		[DBConnections release];
	
	if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"3"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,正确站别:%@",FGSN,[CFGSNArray objectAtIndex:2]];
		[tmpArray addObject:@"3"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"1"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,序号不存在:",FGSN];
		[tmpArray addObject:@"1"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"2"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"站点验证失败,此站点不存在"];
		[tmpArray addObject:@"2"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else
	{
		return [CFGSNArray autorelease];
	}
}


// 用途:check FGSN(11碼序號),回傳MLB序號 and Build ID
// 輸入:FGSN(11碼序號) ＆ station name
// 輸出:以Array方式輸出, array[0]為0(成功)或1(失敗), array[1]為錯誤訊息, array[2]為MLB序號, array[3] is Build ID
- (NSArray *)checkCFGSNWCRetCMBSN:(NSString *)FGSN station:(NSString *)stationName
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];
		
		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCCheckCFGSNWcRetCMBSN '%@', '%@'",FGSN,stationName];
		
		DBConnect *CFGSNDBConnect = [[DBConnect alloc] init];
		NSArray * CFGSNArray = [CFGSNDBConnect queryDataRetWithSemicolon:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
											   commands:commandString];
		[DBConnections release];
	if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"3"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,正确站别:%@",FGSN,[CFGSNArray objectAtIndex:2]];
		[tmpArray addObject:@"3"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"1"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,序号不存在",FGSN];
		[tmpArray addObject:@"1"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"2"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"站点验证失败,此站点不存在"];
		[tmpArray addObject:@"2"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else
	{
		return [CFGSNArray autorelease];
	}
}

// 用途:check FGSN(11碼序號),回傳Battery序號
// 輸入:FGSN(11碼序號) ＆ station name
// 輸出:以Array方式輸出, array[0]為0(成功)或1(失敗), array[1]為錯誤訊息, arrary[2]為Battery序號, array[3] Grape SN
- (NSArray *)checkCFGSNWCRetBattSN:(NSString *)FGSN station:(NSString *)stationName
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];
		
		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCCheckCFGSNWcRetBattSN '%@', '%@'",FGSN,stationName];
		
		DBConnect *CFGSNDBConnect = [[DBConnect alloc] init];
		NSArray * CFGSNArray = [CFGSNDBConnect queryDataRetWithSemicolon:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
											   commands:commandString];
		[DBConnections release];
	if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"3"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,正确站别:%@",FGSN,[CFGSNArray objectAtIndex:2]];
		[tmpArray addObject:@"3"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"1"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,序号不存在",FGSN];
		[tmpArray addObject:@"1"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"2"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"站点验证失败,此站点不存在"];
		[tmpArray addObject:@"2"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"6"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,电池序号不存在",FGSN];
		[tmpArray addObject:@"6"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else
	{
		return [CFGSNArray autorelease];
	}
}


// 用途:check upload MLB測試結果至DB是否成功
// 輸入:MLBSN(13碼序號) ＆ station name & software version(V1.0) & 測試結果(Pass or Fail)
// 輸出:以Array方式輸出, array[0]為0(成功)或1(失敗), array[1]為錯誤訊息
- (NSArray *)uploadResultCMLBSN:(NSString *)MLBSN station:(NSString *)stationName SWVersion:(NSString *)version TestResult:(NSString *)testResult
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];

		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCUploadResultCMBSN '%@', '%@', '%@', '%@'",MLBSN,stationName,version,testResult];
		
		DBConnect *uploadCMBSNDBConnect = [[DBConnect alloc] init];
		NSArray * uploadCMBSNResult = [uploadCMBSNDBConnect queryDataRetWithSemicolon:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
											   commands:commandString];
		[DBConnections release];
		return [uploadCMBSNResult autorelease];
}


// 用途:check upload FGSN測試結果至DB是否成功
// 輸入:FGSN(11碼序號), station name, software version(V1.0), 測試結果(Pass or Fail), Model Name(MPNBurn傳此參數),
//     FixtureID(測試站的設備名稱), User ID(測試站執行人員的工號), Line Name(測試站的線別名稱),
//	   MLN SN, Nand Size, WIFI MacAddress, BT MacAddress, Battery SN, Grape SN, LCD Panel ID,
//	   BuildMatrixType, BuildMatrixConfig, BuildMatrixUnitNumber, ReTest
//     總共19個參數
// 輸出:以Array方式輸出, array[0]為0(成功)或1(失敗), array[1]為錯誤訊息
- (NSArray *)uploadResultCFGSN:(NSString *)FGSN
                       station:(NSString *)stationName
                     SWVersion:(NSString *)SoftWareVersion
                    TestResult:(NSString *)testResult
                     Modelname:(NSString *)ModelName
                     FixtureID:(NSString *)fixtureId
						UserID:(NSString *)userId
                      linename:(NSString *)LineName
                         MLBSN:(NSString *)MLBSerialNumber
                      NandSize:(NSString *)nandSize
                WIFIMACAddress:(NSString *)wifiMacAddress
                  BTMACAddress:(NSString *)btMacAddress
                     BatterySN:(NSString *)batterySN
                       GrapeSN:(NSString *)grapeSN
                    LCDPanelID:(NSString *)LCDPanelId
               BuildMatrixType:(NSString *)matrixType
             BuildMatrixConfig:(NSString *)matrixConfig
         BuildMatrixUnitNumber:(NSString *)matrixUnitNumber
						ReTest:(NSString *)retest
                       TopFlex:(NSString *)topFlex
                       IsWaive:(NSString *)isWaive
						NandID:(NSString *)nandId
{
    // 讀取DBConnections.plist
    NSBundle *bundleDBConnection = [NSBundle mainBundle];
    NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
    NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
    // 依據不同需求,選擇不同的connection
    NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
    
    NSString *userName = [connectionData objectForKey:@"username"];
    NSString *passWord = [connectionData objectForKey:@"password"];
    NSString *serverName = [connectionData objectForKey:@"servername"];
    NSString *dbName = [connectionData objectForKey:@"dbname"];
    
    // 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
    NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCUploadResultCFGSN '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@','%@','%@','%@'",FGSN,stationName,SoftWareVersion,testResult,ModelName,fixtureId,userId,LineName,MLBSerialNumber,nandSize,wifiMacAddress,btMacAddress,batterySN,grapeSN,LCDPanelId,matrixType,matrixConfig,matrixUnitNumber,retest,topFlex,isWaive,nandId];
    
    DBConnect *uploadCFGSNDBConnect = [[DBConnect alloc] init];
    NSArray * uploadCFGSNResult = [uploadCFGSNDBConnect queryDataRetWithSemicolon:userName
                                                                         password:passWord 
                                                                       servername:serverName 
                                                                           dbname:dbName
                                                                         commands:commandString];
    [DBConnections release];
    return [uploadCFGSNResult autorelease];
    
}


// 用途:check upload FGSN測試結果至DB是否成功
// 輸入:FGSN(11碼序號), station name, software version(V1.0), 測試結果(Pass or Fail), Model Name(MPNBurn傳此參數),
//     FixtureID(測試站的設備名稱), User ID(測試站執行人員的工號), Line Name(測試站的線別名稱), 
//	   MLN SN, Nand Size, WIFI MacAddress, BT MacAddress, Battery SN, Grape SN, LCD Panel ID,
//	   BuildMatrixType, BuildMatrixConfig, BuildMatrixUnitNumber, ReTest
//     總共19個參數
// 輸出:以Array方式輸出, array[0]為0(成功)或1(失敗), array[1]為錯誤訊息
- (NSArray *)uploadResultCFGSN:(NSString *)FGSN 
						station:(NSString *)stationName 
						SWVersion:(NSString *)SoftWareVersion 
						TestResult:(NSString *)testResult 
						Modelname:(NSString *)ModelName 
						FixtureID:(NSString *)fixtureId 
						UserID:(NSString *)userId 
						linename:(NSString *)LineName
						MLBSN:(NSString *)MLBSerialNumber
						NandSize:(NSString *)nandSize
						WIFIMACAddress:(NSString *)wifiMacAddress
						BTMACAddress:(NSString *)btMacAddress
						BatterySN:(NSString *)batterySN
						GrapeSN:(NSString *)grapeSN
						LCDPanelID:(NSString *)LCDPanelId
						BuildMatrixType:(NSString *)matrixType
						BuildMatrixConfig:(NSString *)matrixConfig
						BuildMatrixUnitNumber:(NSString *)matrixUnitNumber
						ReTest:(NSString *)retest
						TopFlex:(NSString *)topFlex 
						IsWaive:(NSString *)isWaive 
						NandID:(NSString *)nandId
						ComputerName:(NSString *)computerName
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];

		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCUploadResultCFGSN '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@','%@','%@','%@','%@'",FGSN,stationName,SoftWareVersion,testResult,ModelName,fixtureId,userId,LineName,MLBSerialNumber,nandSize,wifiMacAddress,btMacAddress,batterySN,grapeSN,LCDPanelId,matrixType,matrixConfig,matrixUnitNumber,retest,topFlex,isWaive,nandId,computerName];

		DBConnect *uploadCFGSNDBConnect = [[DBConnect alloc] init];
		NSArray * uploadCFGSNResult = [uploadCFGSNDBConnect queryDataRetWithSemicolon:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
											   commands:commandString];
		[DBConnections release];
	if ([[uploadCFGSNResult objectAtIndex:0] isEqualToString:@"3"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,正确站别:%@",FGSN,[uploadCFGSNResult objectAtIndex:2]];
		[tmpArray addObject:@"3"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[uploadCFGSNResult objectAtIndex:0] isEqualToString:@"1"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,序号不存在",FGSN];
		[tmpArray addObject:@"1"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[uploadCFGSNResult objectAtIndex:0] isEqualToString:@"2"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"站点验证失败,此站点不存在"];
		[tmpArray addObject:@"2"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else
	{
		return [uploadCFGSNResult autorelease];
	}

}


// 用途:將測試fail的測試項目與其結果回傳至DB
// 輸入:9個參數
//		FGSN(11碼序號), station name, software version(V1.0), Line Name, 
//		Test Item, Test Value, Unit, Up Limit, Down Limit 
// 輸出:Array ,array[0]为status(upload fail item success/fail), array[1]为message
- (NSArray *)testFailCFGSN:(NSString *)FGSN station:(NSString *)stationName SWVersion:(NSString *)version linename:(NSString *)lineName testitem:(NSString *)testItem testvalue:(NSString *)testValue unit:(NSString *)Unit uplimit:(id)Up_LIM downlimit:(id)Down_LIM DefectCode:(NSString *)defectCode
{
		// 讀取DBConnections.plist 
		NSBundle *bundleDBConnection = [NSBundle mainBundle];
		NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
		NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
		// 依據不同需求,選擇不同的connection
		NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
		
		NSString *userName = [connectionData objectForKey:@"username"];
		NSString *passWord = [connectionData objectForKey:@"password"];
		NSString *serverName = [connectionData objectForKey:@"servername"];
		NSString *dbName = [connectionData objectForKey:@"dbname"];	
	
			
		// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
		NSMutableString *commandString = [[NSMutableString alloc] init];
		if([Unit isEqualToString:@"NA"])
		{
			commandString = [NSMutableString stringWithFormat:@"exec uspSFCTestFailCFGSN '%@', '%@', '%@', '%@', '%@', '%@', '%@', -1, -1, '%@'",
									FGSN,stationName,version,lineName,testItem,testValue,Unit,defectCode];
		}
		else
		{
			commandString = [NSMutableString stringWithFormat:@"exec uspSFCTestFailCFGSN '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@'",
									FGSN,stationName,version,lineName,testItem,testValue,Unit,Up_LIM,Down_LIM,defectCode];	
		}

		DLog(@"%@",commandString);
	
		DBConnect *testFailCFGSNDBConnect = [[DBConnect alloc] init];
		NSArray * testFailItems = [testFailCFGSNDBConnect queryDataRetWithSemicolon:userName 
											   password:passWord 
											 servername:serverName 
											     dbname:dbName
											   commands:commandString];
	[DBConnections release];	
	[testFailCFGSNDBConnect release];
	if ([[testFailItems objectAtIndex:0] isEqualToString:@"1"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,序号不存在",FGSN];
		[tmpArray addObject:@"1"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[testFailItems objectAtIndex:0] isEqualToString:@"2"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"站点验证失败,此站点不存在"];
		[tmpArray addObject:@"2"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else
	{
		return [testFailItems autorelease];
	}
		
}

// 用途:check user ID & password
// 輸入:user ID, password 
// 輸出:Array ,array[0]為0(成功)或1(失敗), array[1]為錯誤訊息, array[2]为line name
- (NSArray *)checkUserID:(NSString *)userID UserPassword:(NSString *)userPassword
{
	// 讀取DBConnections.plist 
	NSBundle *bundleDBConnection = [NSBundle mainBundle];
	NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
	NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
	// 依據不同需求,選擇不同的connection
	NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
	
	NSString *userName = [connectionData objectForKey:@"username"];
	NSString *passWord = [connectionData objectForKey:@"password"];
	NSString *serverName = [connectionData objectForKey:@"servername"];
	NSString *dbName = [connectionData objectForKey:@"dbname"];
	
	// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
	NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCCheckUserID '%@', '%@'",userID,userPassword];
	
	DBConnect *UserInfoDBConnect = [[DBConnect alloc] init];
	NSArray * UserInfoArray = [UserInfoDBConnect queryDataRetWithSemicolon:userName 
															password:passWord 
														  servername:serverName 
															  dbname:dbName
															commands:commandString];
	[DBConnections release];
	[UserInfoDBConnect release];
	if ([[UserInfoArray objectAtIndex:0] isEqualToString:@"9"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"帐号:%@ 验证失败,帐号不存在",userID];
		[tmpArray addObject:@"9"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[UserInfoArray objectAtIndex:0] isEqualToString:@"10"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"密码错误"];
		[tmpArray addObject:@"10"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else
	{
		return [UserInfoArray autorelease];
	}
}

- (NSArray *)GetWaiveDefect:(NSString *)CustomSN station:(NSString *)stationName
{
	// 讀取DBConnections.plist 
	NSBundle *bundleDBConnection = [NSBundle mainBundle];
	NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
	NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
	// 依據不同需求,選擇不同的connection
	NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
	
	NSString *userName = [connectionData objectForKey:@"username"];
	NSString *passWord = [connectionData objectForKey:@"password"];
	NSString *serverName = [connectionData objectForKey:@"servername"];
	NSString *dbName = [connectionData objectForKey:@"dbname"];
	
	// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
	NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCGetWaiveDefect '%@', '%@'",CustomSN,stationName];
	
	DBConnect *WaiveDBConnect = [[DBConnect alloc] init];
	NSArray * GetWaiveStatus = [WaiveDBConnect queryDataUseIACPBsqldb:userName 
																  password:passWord 
																servername:serverName 
																	dbname:dbName
																  commands:commandString];
	
	[DBConnections release];
	[WaiveDBConnect release];
	return [GetWaiveStatus autorelease];
}


- (NSArray *)getModelforMPNBurn
{
	// Read connection data
	NSBundle *bundleDBConnection = [NSBundle mainBundle];
	NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
	NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
	NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
	
	NSString *userName = [connectionData objectForKey:@"username"];
	NSString *passWord = [connectionData objectForKey:@"password"];
	NSString *serverName = [connectionData objectForKey:@"servername"];
	NSString *dbName = [connectionData objectForKey:@"dbname"];
	
	// Load MPN datas
	DBConnect *ModelDBConnect = [[DBConnect alloc] init];
	NSArray * ModelArray = [ModelDBConnect queryDataUseIACPBsqldb:userName 
														 password:passWord 
													   servername:serverName 
														   dbname:dbName
														 commands:@"exec uspSFCGetModelList"];
	[DBConnections release];
	[ModelDBConnect release];
	return [ModelArray autorelease];
}


// 用途:check FGSN(11碼序號)
// 輸入:FGSN(11碼序號) ＆ station name
// 輸出:以Array方式輸出, array[0]為0(成功)或1(失敗), array[1]為錯誤訊息
- (NSArray *)checkCFGSNWCforMPN:(NSString *)FGSN station:(NSString *)stationName UserID:(NSString *)userId linename:(NSString *)LineName model:(NSString *)ModelName
{
	// 讀取DBConnections.plist 
	NSBundle *bundleDBConnection = [NSBundle mainBundle];
	NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
	NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
	// 依據不同需求,選擇不同的connection
	NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
	
	NSString *userName = [connectionData objectForKey:@"username"];
	NSString *passWord = [connectionData objectForKey:@"password"];
	NSString *serverName = [connectionData objectForKey:@"servername"];
	NSString *dbName = [connectionData objectForKey:@"dbname"];
	
	// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
	NSString *commandString = [[NSString alloc] initWithFormat:@"exec uspSFCCheckCFGSNWc '%@', '%@', '%@', '%@', '%@'",FGSN,stationName,userId,LineName,ModelName];
	
	DBConnect *CFGSNDBConnect = [[DBConnect alloc] init];
	NSArray * CFGSNArray = [CFGSNDBConnect queryDataRetWithSemicolon:userName 
															password:passWord 
														  servername:serverName 
															  dbname:dbName
															commands:commandString];
	[DBConnections release];
	
	if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"3"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,正确站别:%@",FGSN,[CFGSNArray objectAtIndex:2]];
		[tmpArray addObject:@"3"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"1"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"序号:%@ 验证失败,序号不存在",FGSN];
		[tmpArray addObject:@"1"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else if ([[CFGSNArray objectAtIndex:0] isEqualToString:@"2"])
	{
		NSMutableArray	*tmpArray = [[NSMutableArray alloc] init];
		NSString *message = [[NSString alloc] initWithFormat:@"站点验证失败,此站点不存在"];
		[tmpArray addObject:@"2"];
		[tmpArray addObject:message];
		return tmpArray;
	}
	else
	{
		return [CFGSNArray autorelease];
	}
}



- (NSArray *)UploadCB:(NSString *)CustomSN station:(NSString *)stationName linename:(NSString *)lineName cmdname:(NSString *)testItem testvalue:(NSString *)testValue RetestCount:(NSString *)retestCount  UserID:(NSString *)userId
{
	// 讀取DBConnections.plist 
	NSBundle *bundleDBConnection = [NSBundle mainBundle];
	NSString *pathOfDBBundle = [bundleDBConnection pathForResource:@"DBConnections" ofType:@"plist"];
	NSDictionary *DBConnections = [[NSDictionary alloc] initWithContentsOfFile:pathOfDBBundle];
	// 依據不同需求,選擇不同的connection
	NSDictionary *connectionData = [DBConnections objectForKey:@"Connection2"];
	
	NSString *userName = [connectionData objectForKey:@"username"];
	NSString *passWord = [connectionData objectForKey:@"password"];
	NSString *serverName = [connectionData objectForKey:@"servername"];
	NSString *dbName = [connectionData objectForKey:@"dbname"];	
	
	
	// 利用NSString本身提供的方法,將字串與參數串連起來成為一個新字串
	NSMutableString *commandString = [[NSMutableString alloc] init];
	commandString = [NSMutableString stringWithFormat:@"exec uspSFCUploadCB '%@', '%@', '%@', '%@', '%@', '%@', '%@'",CustomSN,stationName,lineName,testItem,testValue,retestCount,userId];	
	
	DLog(@"%@",commandString);
	
	DBConnect *uploadCBConnect = [[DBConnect alloc] init];
	NSArray * uploadCB = [uploadCBConnect queryDataRetWithSemicolon:userName 
																	   password:passWord 
																	 servername:serverName 
																		 dbname:dbName
																	   commands:commandString];
	[DBConnections release];	
	[uploadCBConnect release];
	return [uploadCB autorelease];	
}
@end
