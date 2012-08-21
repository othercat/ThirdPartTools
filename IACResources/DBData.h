//
//  DBData.h
//  MPNBurn
//
//  Created by Grace on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DBData : NSObject {

}

- (NSArray *)getModel;
- (NSArray *)getModelforMPNBurn;
- (NSString *)getRegionKey:(NSString *)modelName;
- (NSString *)getMPNCode:(NSString *)modelName;

// check MLB
- (NSArray *)checkCMLBSNWC:(NSString *)MLBSN station:(NSString *)stationName;
// check SN
- (NSArray *)checkCFGSNWC:(NSString *)FGSN station:(NSString *)stationName UserID:(NSString *)userId linename:(NSString *)LineName;

// check SN return MLB SN
- (NSArray *)checkCFGSNWCRetCMBSN:(NSString *)FGSN station:(NSString *)stationName;
// check SN return Battery SN
- (NSArray *)checkCFGSNWCRetBattSN:(NSString *)FGSN station:(NSString *)stationName;

// upload MLB result
- (NSArray *)uploadResultCMLBSN:(NSString *)MLBSN station:(NSString *)stationName SWVersion:(NSString *)version TestResult:(NSString *)testResult;
// upload SN result
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
						ComputerName:(NSString *)computerName;

// test fail items
- (NSArray *)testFailCFGSN:(NSString *)FGSN station:(NSString *)stationName SWVersion:(NSString *)version linename:(NSString *)lineName testitem:(NSString *)testItem testvalue:(NSString *)testValue unit:(NSString *)Unit uplimit:(id)Up_LIM downlimit:(id)Down_LIM DefectCode:(NSString *)defectCode;

// check User ID & Password; return User Name & Line Name
- (NSArray *)checkUserID:(NSString *)userID UserPassword:(NSString *)userPassword;
- (NSArray *)GetWaiveDefect:(NSString *)CustomSN station:(NSString *)stationName;

// check SN for MPN BURN
- (NSArray *)checkCFGSNWCforMPN:(NSString *)FGSN station:(NSString *)stationName UserID:(NSString *)userId linename:(NSString *)LineName model:(NSString *)ModelName;

- (NSArray *)UploadCB:(NSString *)CustomSN station:(NSString *)stationName linename:(NSString *)lineName cmdname:(NSString *)testItem testvalue:(NSString *)testValue RetestCount:(NSString *)retestCount UserID:(NSString *)userId;

@end
