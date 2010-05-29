#import "AWiPhotoLibrary.h"
#import "FMDatabase.h"

void testDecodeAux();
void testDecodeMain();
void testLibraryName(AWiPhotoLibrary *iPhoto);
void testEvents(AWiPhotoLibrary *iPhoto);
void testEventWithId(AWiPhotoLibrary *iPhoto);
void testEventWithName(AWiPhotoLibrary *iPhoto);

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    AWiPhotoLibrary *iPhoto = [AWiPhotoLibrary libraryWithPath:@"/Users/alexwinston/Pictures/Pihoto Library"];
    if (!iPhoto) { 
		[pool drain];
		return 0;
	}
	
	/*testDecodeAux();
	testDecodeMain();
	testLibraryName(iPhoto);*/
	testEvents(iPhoto);
	testEventWithId(iPhoto);
	testEventWithName(iPhoto);
	
	[pool release];
	return 0;
}

void testDecodeAux() {
	NSLog(@"testDecodeAux");
	FMDatabase* db = [FMDatabase databaseWithPath:@"/Users/alexwinston/Pictures/Pihoto Library/iPhotoAux.db"];
	[db open];

	FMResultSet *rs = [db executeQuery:@"select * from SqPhotoInfoEdit"];
	while ([rs next]) {
		NSUnarchiver *unarchiver = [[NSUnarchiver alloc] initForReadingWithData:[rs dataForColumn:@"editListDictionary"]];
		NSLog(@"%@", [[unarchiver decodeObject] description]);
	}
	
	rs = [db executeQuery:@"select * from SqGlobalsShare"];
	while ([rs next]) {
		NSUnarchiver *unarchiver = [[NSUnarchiver alloc] initForReadingWithData:[rs dataForColumn:@"photoShareProperties"]];
		NSLog(@"%@", [[unarchiver decodeObject] description]);
	}
	
	[rs close];
	[db close];
}

void testDecodeMain() {
	NSLog(@"testDecodeMain");
	FMDatabase* db = [FMDatabase databaseWithPath:@"/Users/alexwinston/Pictures/Pihoto Library/iPhotoMain.db"];
	[db open];
	
	FMResultSet *rs = [db executeQuery:@"select * from SqEvent"];
	while ([rs next]) {
		NSUnarchiver *unarchiver = [[NSUnarchiver alloc] initForReadingWithData:[rs dataForColumn:@"rollDirectories"]];
		NSLog(@"%@", [[unarchiver decodeObject] description]);
	}
	
	rs = [db executeQuery:@"select * from SqGlobals"];
	while ([rs next]) {
		NSUnarchiver *unarchiver = [[NSUnarchiver alloc] initForReadingWithData:[rs dataForColumn:@"metaData"]];
		NSLog(@"%@", [[unarchiver decodeObject] description]);
	}
	
	[rs close];
	[db close];
}

void testLibraryName(AWiPhotoLibrary *iPhoto) {
	NSLog(@"Library Name: %@", iPhoto.name);
}

void testEvents(AWiPhotoLibrary *iPhoto) {
	NSArray *events = [iPhoto events];
	for (AWiPhotoEvent *event in events) {
		NSLog(@"Event: %@ %@ %@ %@", event.id, event.name, event.startDate, event.endDate);
		
		for (AWiPhotoDocument *photo in event.documents) {
			NSLog(@"Photo: %@ %@", photo.id, photo.createdDate);
		}
	}
}

void testEventWithId(AWiPhotoLibrary *iPhoto) {
	AWiPhotoEvent *event = [iPhoto eventWithId:@"0C904177-BCFD-4F8F-BE06-D5FB17B4437A"];
	NSLog(@"eventWithId: %@ %@", event.id, event.name);
}

void testEventWithName(AWiPhotoLibrary *iPhoto) {
	AWiPhotoEvent *event = [iPhoto eventWithName:@"Coen's Bouncer"];
	NSLog(@"AWiPhotoController eventWithName: %@ %@", event.id, event.name);
	
	for (AWiPhotoDocument *photo in event.documents) {
		NSLog(@"AWiPhotoEvent photos: %@ %@ %@", photo.id, photo.createdDate, photo.comments);
	}
}

