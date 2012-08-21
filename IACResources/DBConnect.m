//
//  DBConnect.m
//  Test1
//
//  Created by Grace on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBConnect.h"


@implementation DBConnect

// Rewrite the script file
- (void)writeScript:(NSString *)fileName script:(NSString *)contentOfScript
{
	NSError *e;
	// Read the contents of file
	NSData *d = [NSData dataWithContentsOfFile:fileName options:0 error:&e];
	NSString *contentsOfString = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
	NSLog(@"%@",contentsOfString);
	if (d == nil)
	{
		NSLog(@"Read failed: %@", [e localizedDescription]);
	}
	
	// Set Data
	const char *utfString = [contentOfScript UTF8String];
	NSData *d2 = [NSData dataWithBytes:utfString length:strlen(utfString)];
	
	NSString *newContentsOfString2 = [[NSString alloc] initWithData:d2 encoding:NSUTF8StringEncoding];
	NSLog(@"%@",newContentsOfString2);
	
	// rewrite the contents of file
	[d2 writeToFile:fileName options:0 error:&e];
	if (d2 == nil)
	{
		NSLog(@"Write failed: %@", [e localizedDescription]);
	}
}

// use bsqldb
- (NSArray *)queryDataUseBsqldbWithNoOutputFile:(NSString *)userName password:(NSString *)passWord servername:(NSString *)serverName dbname:(NSString *)dbName inputfile:(NSString *)inputFile
{
	task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/local/freetds/bin/bsqldb"];
	NSArray *args = [NSArray arrayWithObjects:@"-U", userName, @"-P", passWord, @"-S", serverName, @"-D", dbName, @"-i", inputFile, nil];
	
	[task setArguments:args];
		
	// release the old pipe
	[pipe release];
	// Create a new pipe
	pipe = [[NSPipe alloc] init];
	[task setStandardOutput:pipe];
	[pipe release];
		
	// Star the process
	[task launch];
		
	// Read the output
	NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
		
	[task waitUntilExit];
	[task release];
	
	// Convert to a string
	NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	// Release the old filenames
	[queryDatas release];
	// Break the string into lines
	queryDatas = [[aString componentsSeparatedByString:@"\n"] retain];

	// Release the string
	[aString release];
	
	return queryDatas;
}


// use iacp_bsqldb
- (NSArray *)queryDataUseIACPBsqldb:(NSString *)userName password:(NSString *)passWord servername:(NSString *)serverName dbname:(NSString *)dbName commands:(NSString *)command
{
	task = [[NSTask alloc] init];
	//[task setLaunchPath:@"/usr/local/freetds/bin/iacp_bsqldb"];
	[task setLaunchPath:@"/usr/local/freetds/bin/bsqldb"];
	NSArray *args = [NSArray arrayWithObjects:@"-U", userName, @"-P", passWord, @"-S", serverName, @"-D", dbName, @"-I", command, nil];
	
	[task setArguments:args];
		
	// release the old pipe
	[pipe release];
	// Create a new pipe
	pipe = [[NSPipe alloc] init];
	[task setStandardOutput:pipe];
	[pipe release];
		
	// Star the process
	[task launch];
		
	// Read the output
	NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
		
	[task waitUntilExit];
	[task release];
	
	// Convert to a string
	NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	// Release the old filenames
	[queryDatas release];
	// Break the string into lines
	queryDatas = [[aString componentsSeparatedByString:@"\n"] retain];

	// Release the string
	[aString release];
	
	return queryDatas;
}


// use iacp_bsqldb
- (NSArray *)queryDataRetWithSemicolon:(NSString *)userName password:(NSString *)passWord servername:(NSString *)serverName dbname:(NSString *)dbName commands:(NSString *)command
{
	task = [[NSTask alloc] init];
	//[task setLaunchPath:@"/usr/local/freetds/bin/iacp_bsqldb"];
	[task setLaunchPath:@"/usr/local/freetds/bin/bsqldb"];
	NSArray *args = [NSArray arrayWithObjects:@"-U", userName, @"-P", passWord, @"-S", serverName, @"-D", dbName, @"-I", command, nil];
	
	[task setArguments:args];
	
	// release the old pipe
	[pipe release];
	// Create a new pipe
	pipe = [[NSPipe alloc] init];
	[task setStandardOutput:pipe];
	[pipe release];
	
	// Star the process
	[task launch];
	
	// Read the output
	NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
	
	[task waitUntilExit];
	[task release];
	
	// Convert to a string
	NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	// Release the old filenames
	[queryDatas release];
	// Break the string into lines
	queryDatas = [[aString componentsSeparatedByString:@";"] retain];
	
	// Release the string
	[aString release];
	
	return queryDatas;
}

@end
