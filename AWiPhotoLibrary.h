//
//  AWiPhotoController.h
//  AWiPhotoController
//
//  Created by Alex Winston on 4/10/10.
//  Copyright 2010 ComFrame Software Corporation. All rights reserved.
//

#import "AWiPhotoEvent.h"
#import "AWiPhotoDocument.h"


@interface AWiPhotoLibrary : NSObject {
}
+ (AWiPhotoLibrary *)libraryWithPath:(NSString *)filePath;
- (AWiPhotoLibrary *)initWithPath:(NSString *)filepath;
- (NSString *)name;
- (NSString *)filePath;
- (NSArray *)events;
- (BOOL)containsEventWithId:(NSString *)eventId;
- (BOOL)containsEventWithName:(NSString *)aName;
- (BOOL)containsDocumentWithId:(NSString *)documentId forEventId:(NSString *)eventId;
- (NSString *)addEvent:(AWiPhotoEvent *)anEvent;
- (NSString *)addDocument:(AWiPhotoDocument *)aDocument forEventId:(NSString *)eventId;
- (AWiPhotoEvent *)eventWithId:(NSString *)eventId;
- (AWiPhotoEvent *)eventWithName:(NSString *)aName;
- (AWiPhotoDocument *)documentWithId:(NSString *)documentId;
@end
