//
//  GraphicsView.h
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "vector.hpp"
#import "OBJLoader.h"
@interface GraphicsView : NSView
@property NSImage* image;
-(void) render;
@end
#include "vector.hpp"
//				AABBGGRR
#define GREEN 0x00FF00FF
#define RED 0xFF0000FF
#define BLUE 0x0x0000FFFF
#define MAGENTA 0xFFFF00FF
#define PURPLE 0x8400FF