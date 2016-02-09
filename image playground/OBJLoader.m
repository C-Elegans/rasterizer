//
//  OBJLoader.m
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import "OBJLoader.h"
@implementation OBJLoader
-(id)init:(NSString *)file{
	self = [super init];
	NSString *objData = [NSString stringWithContentsOfFile:file];
	int vertexCount = 0, faceCount = 0;
	// Iterate through file once to discover how many vertices, normals, and faces there are
	NSArray *lines = [objData componentsSeparatedByString:@"\n"];
	for(NSString* line in lines){
		if([line hasPrefix:@"v "])vertexCount++;
		else if([line hasPrefix:@"f "])faceCount++;
	}
	self.vertices = malloc(sizeof(vec3)*vertexCount);
	self.faces = malloc(sizeof(face)*faceCount);
	self.numFaces = faceCount;
	self.numVertices = vertexCount;
	NSLog(@"vertices: %d, faces: %d",vertexCount,faceCount);
	NSLog(@"Vertices ptr: %p", self.vertices);
	vertexCount = 0, faceCount = 0;
	for(NSString* line in lines){
		if([line hasPrefix:@"v "]){
			NSString *lineTrunc = [line substringFromIndex:2];
			NSArray *lineVertices = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		
			self.vertices[vertexCount].x = [[lineVertices objectAtIndex:0] floatValue];
			self.vertices[vertexCount].y = [[lineVertices objectAtIndex:1] floatValue];
			self.vertices[vertexCount].z = [[lineVertices objectAtIndex:2] floatValue];
			//NSLog(@"V: %f, %@", [[lineVertices objectAtIndex:0]floatValue], [lineVertices objectAtIndex:0] );
		}
		else if([line hasPrefix:@"f "]) {
			NSString *lineTrunc = [line substringFromIndex:2];
			NSArray *faceIndexGroups = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			// Unrolled loop, a little ugly but functional
			/*
			 From the WaveFront OBJ specification:
			 o       The first reference number is the geometric vertex.
			 o       The second reference number is the texture vertex. It follows the first slash.
			 o       The third reference number is the vertex normal. It follows the second slash.
			 */
			NSString *oneGroup = [faceIndexGroups objectAtIndex:0];
			NSArray *groupParts = [oneGroup componentsSeparatedByString:@"/"];
			_faces[faceCount].x = [[groupParts objectAtIndex:0] intValue]-1; // indices in file are 1-indexed, not 0 indexed
			oneGroup = [faceIndexGroups objectAtIndex:1];
			groupParts = [oneGroup componentsSeparatedByString:@"/"];
			_faces[faceCount].y = [[groupParts objectAtIndex:0] intValue]-1;
			oneGroup = [faceIndexGroups objectAtIndex:2];
			groupParts = [oneGroup componentsSeparatedByString:@"/"];
			_faces[faceCount].z = [[groupParts objectAtIndex:0] intValue]-1;
			faceCount++;
			
		}
	}
	return self;
}
@end
