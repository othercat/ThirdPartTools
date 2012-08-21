//
//  IACTestMessageData.m
//
//  Created by tommy zhang on 08-11-27.
//  Copyright 2008. All rights reserved.
//

#import "IACMessageData.h"


@implementation IACMessageData
@synthesize intArg,boolArg,message,idArg;

+(IACMessageData *)sendMessage: (EnumIACMessage)messageToBeSent
					IdArgument:(id)FirstArg
				   IntArgument:(int) SecondArg
				  BoolArgument:(bool) ThirdArg
{
	IACMessageData *temp = [[IACMessageData alloc] autorelease];
	[temp setMessage: messageToBeSent];
	[temp setIdArg: FirstArg];
	[temp setIntArg:SecondArg];
	[temp setBoolArg:ThirdArg];
	return [temp retain];
}

+(IACMessageData *)sendMessage:(EnumIACMessage)messageToBeSent
					IdArgument:(id)FirstArg
{
	IACMessageData *temp = [[IACMessageData alloc] autorelease];
	[temp setMessage: messageToBeSent];
	[temp setIdArg: FirstArg];
	[temp setIntArg:0];
	[temp setBoolArg:YES];
	return [temp retain];
}

+(IACMessageData *)sendMessage:(EnumIACMessage)messageToBeSent
				   IntArgument:(int)SecondArg;
{
	IACMessageData *temp = [[IACMessageData alloc] autorelease];
	[temp setMessage: messageToBeSent];
	[temp setIdArg: nil];
	[temp setIntArg:SecondArg];
	[temp setBoolArg:YES];
	return [temp retain];
}
+(IACMessageData *)sendMessage:(EnumIACMessage)messageToBeSent
				  BoolArgument:(bool)ThirdArg;
{
	IACMessageData *temp = [[IACMessageData alloc] autorelease];
	[temp setMessage: messageToBeSent];
	[temp setIdArg: nil];
	[temp setIntArg:0];
	[temp setBoolArg:ThirdArg];
	return [temp retain];
}
@end



