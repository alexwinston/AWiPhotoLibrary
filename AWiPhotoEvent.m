//
//  AWiPhotoEvent.m
//  AWiPhotoController
//
//  Created by Alex Winston on 4/11/10.
//  Copyright 2010 ComFrame Software Corporation. All rights reserved.
//

#import "AWiPhotoEvent.h"


@interface AWiPhotoEvent (Private)
@end

@implementation AWiPhotoEvent
@synthesize id=_id;
@synthesize name=_name;
@synthesize comment=_comment;
@synthesize documents=_documents;

- (NSDate *)startDate {
	return _startDate;
}

- (NSDate *)endDate {
	return _endDate;
}

- (void)dealloc {
	[_startDate release];
	[_endDate release];
	[super dealloc];
}

@end
