//
//  DBConnect.h
//  Test1
//
//  Created by Grace on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DBConnect : NSObject {
	NSTask *task;
	NSPipe *pipe;	
	NSArray *queryDatas;
}

- (void)writeScript:(NSString *)fileName script:(NSString *)contentOfScript;
// use bsqldb
- (NSArray *)queryDataUseBsqldbWithNoOutputFile:(NSString *)userName password:(NSString *)passWord servername:(NSString *)serverName dbname:(NSString *)dbName inputfile:(NSString *)inputFile;

//use iacp_bsqldb
- (NSArray *)queryDataUseIACPBsqldb:(NSString *)userName password:(NSString *)passWord servername:(NSString *)serverName dbname:(NSString *)dbName commands:(NSString *)command;

- (NSArray *)queryDataRetWithSemicolon:(NSString *)userName password:(NSString *)passWord servername:(NSString *)serverName dbname:(NSString *)dbName commands:(NSString *)command;

@end

