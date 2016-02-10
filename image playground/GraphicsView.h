//
//  GraphicsView.h
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "vector.h"
#import "OBJLoader.h"
@interface GraphicsView : NSView
@property NSImage* image;
-(void) render;
@end
#include "vector.h"
//				AABBGGRR
#define GREEN 0xff00FF00
#define RED 0xFF0000FF
#define BLUE 0xFFFF0000
#define MAGENTA 0xFFFF00FF