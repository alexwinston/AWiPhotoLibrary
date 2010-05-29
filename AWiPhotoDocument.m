//
//  AWiPhotoPhoto.m
//  AWiPhotoController
//
//  Created by Alex Winston on 4/11/10.
//  Copyright 2010 Alex Winston. All rights reserved.
//

#import "AWiPhotoDocument.h"


@interface AWiPhotoDocument (Private)
NSString *_filePath;
@end

@implementation AWiPhotoDocument
@synthesize id=_id;
@synthesize caption=_caption;
@synthesize comments=_comments;
@synthesize createdDate=_createdDate;
@synthesize documentType=_documentType;
@synthesize editState=_editState;
@synthesize fileData=_fileData;
@synthesize thumbnailImage=_thumbnailImage;

+ (AWiPhotoDocument *)documentWithPath:(NSString*)filePath {
    return [[[self alloc] initWithPath:filePath] autorelease];
}

- (AWiPhotoDocument *)initWithPath:(NSString *)filePath {
    if ((self = [super init])) {
		_filePath = [[filePath copy] retain];
	}
	
	return self;
}

- (void)dealloc {
    [_filePath release];
    [super dealloc];
}

@end
