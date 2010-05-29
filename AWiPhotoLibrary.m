//
//  AWiPhotoController.m
//  AWiPhotoController
//
//  Created by Alex Winston on 4/10/10.
//  Copyright 2010 Alex Winston. All rights reserved.
//

#import "AWiPhotoLibrary.h"
#import "AWiPhotoEvent+Protected.h"
#import "FMDatabase.h"


#define kSqlEvents @"select rollDirectories, uid, name, comment, datetime(rollDate +  julianday('2000-01-01 00:00:00')) as rollDate from SqEvent "
#define kSqlEventPhotos @"select SqPhotoInfo.uid, editState, caption, datetime(photoDate +  julianday('2000-01-01 00:00:00')) as photoDate, comments, imageWidth, imageHeight, relativePath from SqPhotoInfo join SqEvent on SqPhotoInfo.event = SqEvent.primaryKey join SqFileImage on SqPhotoInfo.primaryKey = photoKey join SqFileInfo on SqFileImage.sqFileInfo = SqFileInfo.primaryKey where imageType = 6 "

@interface AWiPhotoLibrary (Private)
FMDatabase *_libraryDatabase;
NSString *_libraryPath;
- (FMResultSet *)_executeQuery:(NSString *)sql, ...;
- (AWiPhotoEvent *)_eventWithResultSet:(FMResultSet *)rs;
- (AWiPhotoDocument *)_photoWithResultSet:(FMResultSet *)rs;
- (NSDate *)_dateWithString:(NSString *)julianDate;
@end

@implementation AWiPhotoLibrary

+ (AWiPhotoLibrary *)libraryWithPath:(NSString*)thePath {
    return [[[self alloc] initWithPath:thePath] autorelease];
}

- (AWiPhotoLibrary *)initWithPath:(NSString*)thePath {
    if ((self = [super init])) {
		NSString *databasePath = [thePath stringByAppendingString:@"/iPhotoMain.db"];
		_libraryDatabase = [[FMDatabase databaseWithPath:databasePath] retain];
		if (![_libraryDatabase open]) {
			NSLog(@"Could not open iPhoto Library at path %@", databasePath);
			return nil;
		}
		
		_libraryPath = [[thePath copy] retain];
	}
	
	return self;
}

- (NSString *)name {
	return [_libraryPath lastPathComponent];
}

- (NSString *)path {
	return _libraryPath;
}

- (NSArray *)events {
	NSMutableArray *events = [NSMutableArray arrayWithCapacity:10];
	
	FMResultSet *rs = [self _executeQuery:kSqlEvents];
	while ([rs next]) {
		[events addObject:[self _eventWithResultSet:rs]];
	}
	[rs close];
	
	return events;
}

- (AWiPhotoEvent *)eventWithId:(NSString *)theId {
	AWiPhotoEvent *event = nil;
	
	FMResultSet *rs = [self _executeQuery:[kSqlEvents stringByAppendingString:@"where uid = ?"], theId];
	if ([rs next]) {
		event = [self _eventWithResultSet:rs];
	}
	[rs close];
	
	return event;
}

- (AWiPhotoEvent *)eventWithName:(NSString *)theName {
	AWiPhotoEvent *event = nil;
	
	FMResultSet *rs = [self _executeQuery:[kSqlEvents stringByAppendingString:@"where name = ?"], theName];
	if ([rs next]) {
		event = [self _eventWithResultSet:rs];
	}
	[rs close];
	
	return event;
}

- (void)dealloc {
	[_libraryDatabase release];
	[_libraryPath release];
	[super dealloc];
}

- (FMResultSet *)_executeQuery:(NSString *)sql, ... {
	if ([_libraryDatabase open]) {
		va_list args;
		va_start(args, sql);

		FMResultSet *rs = [_libraryDatabase executeQuery:sql withArgumentsInArray:nil orVAList:args];
		va_end(args);
		
		if ([_libraryDatabase hadError]) {
			[rs close];
			
			NSLog(@"Error %d: %@", [_libraryDatabase lastErrorCode], [_libraryDatabase lastErrorMessage]);
			return nil;
		}
		
		return rs;
	}
	
	return nil;
}

- (AWiPhotoEvent *)_eventWithResultSet:(FMResultSet *)rs {
	AWiPhotoEvent *event = [[AWiPhotoEvent alloc] init];

	NSUnarchiver *unarchiver = [[NSUnarchiver alloc]
				initForReadingWithData:[rs dataForColumn:@"rollDirectories"]];
	NSArray *directories = [unarchiver decodeObject];
	//NSLog(@"%@", [directories description]);
	
	//NSLog(@"%@", [[rs dataForColumn:@"rollDirectories"] description]);
	event.id = [rs stringForColumn:@"uid"];
	event.name = [rs stringForColumn:@"name"];
	event.comment = [rs stringForColumn:@"comment"];
	
	NSMutableArray *documents = [NSMutableArray arrayWithCapacity:10];
	event.documents = documents;
	
	FMResultSet *rsPhotos = [self _executeQuery:[kSqlEventPhotos stringByAppendingString:@"and SqEvent.uid = ?"], [NSString stringWithFormat:@"%@", event.id]];
	while ([rsPhotos next]) {
		[event addDocument:[self _photoWithResultSet:rsPhotos]];
	}
	[rsPhotos close];
	
	return event;
}

- (AWiPhotoDocument *)_photoWithResultSet:(FMResultSet *)rs {
	AWiPhotoDocument *photo = [[AWiPhotoDocument alloc] initWithPath:[rs stringForColumn:@"relativePath"]];
	photo.id = [rs stringForColumn:@"uid"];
	photo.caption = [rs stringForColumn:@"caption"];
	photo.comments = [rs stringForColumn:@"comments"];
	photo.createdDate = [self _dateWithString:[rs stringForColumn:@"photoDate"]];
	photo.editState = [rs intForColumn:@"editState"];
	
	return photo;
}

- (NSDate *)_dateWithString:(NSString *)julianDate {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *d = [df dateFromString: julianDate];
	[df release];
	
	return d;
}

@end
