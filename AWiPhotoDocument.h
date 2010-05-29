//
//  AWiPhotoPhoto.h
//  AWiPhotoController
//
//  Created by Alex Winston on 4/11/10.
//  Copyright 2010 Alex Winston. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define kEditStateOriginal 0
#define kEditStateEdited 1
#define kDocumentTypePicture 7
#define kDocumentTypeVideo 8

@interface AWiPhotoDocument : NSObject {
	NSString *_id;
	NSString *_caption;
	NSString *_comments;
	NSDate *_createdDate;
	NSInteger _documentType;
	NSInteger _editState;
	NSData *_fileData;
	NSImage *_thumbnailImage;
}
+ (AWiPhotoDocument *)documentWithPath:(NSString *)filePath;
- (AWiPhotoDocument *)initWithPath:(NSString *)filePath;
@property (copy) NSString *id;
@property (copy) NSString *caption;
@property (copy) NSString *comments;
@property (nonatomic, retain) NSDate *createdDate;
@property NSInteger documentType;
@property NSInteger editState;
@property (nonatomic, retain) NSData *fileData;
@property (nonatomic, retain) NSImage *thumbnailImage;
@end
