//
//  OBJLoader.m
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import "OBJLoader.h"

@implementation OBJLoader

+(void)createModelFromFile:(NSString *)file model:(Model*)model{
	
	NSString *objData = [NSString stringWithContentsOfFile:file];
	int vertexCount = 0, faceCount = 0;
	// Iterate through file once to discover how many vertices, normals, and faces there are
	NSArray *lines = [objData componentsSeparatedByString:@"\n"];
	for(NSString* line in lines){
		if([line hasPrefix:@"v "])vertexCount++;
		else if([line hasPrefix:@"f "])faceCount++;
	}
	NSMutableArray<Vec3f*>* vertices = [NSMutableArray new];
	NSMutableArray<Face*>* faces= [NSMutableArray new];
	NSMutableArray<Vec2f*>* uvs = [NSMutableArray new];
	NSMutableArray<Vec3f*>* normals =[NSMutableArray new];
	model.vertices = vertices;
	model.normals = normals;
	model.faces = faces;
	model.numFaces = faceCount;
	model.numVertices = vertexCount;
	model.uvs = uvs;
	
	vertexCount = 0, faceCount = 0;
	for(NSString* line in lines){
		if([line hasPrefix:@"v "]){
			NSString *lineTrunc = [line substringFromIndex:2];
			NSArray *lineVertices = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			Vec3f* vertex = [Vec3f new];
			vertex.x = [[lineVertices objectAtIndex:0] floatValue];
			vertex.y = [[lineVertices objectAtIndex:1] floatValue];
			vertex.z = [[lineVertices objectAtIndex:2] floatValue];
			[vertices addObject:vertex];
			//NSLog(@"V: %f, %@", [[lineVertices objectAtIndex:0]floatValue], [lineVertices objectAtIndex:0] );
		}
		else if([line hasPrefix:@"vt "]){
			NSString *lineTrunc = [line substringFromIndex:4];
			NSArray *lineVertices = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			Vec2f* vertex = [Vec2f new];
			vertex.x = [[lineVertices objectAtIndex:0] floatValue];
			vertex.y = [[lineVertices objectAtIndex:1] floatValue];
			[uvs addObject:vertex];
			//NSLog(@"V: %f, %@", [[lineVertices objectAtIndex:0]floatValue], [lineVertices objectAtIndex:0] );
		}
		if([line hasPrefix:@"vn "]){
			NSString *lineTrunc = [line substringFromIndex:4];
			NSArray *lineVertices = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			Vec3f* vertex = [Vec3f new];
			vertex.x = [[lineVertices objectAtIndex:0] floatValue];
			vertex.y = [[lineVertices objectAtIndex:1] floatValue];
			vertex.z = [[lineVertices objectAtIndex:2] floatValue];
			[normals addObject:vertex];
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
			Face* face = [Face new];
			NSString *oneGroup = [faceIndexGroups objectAtIndex:0];
			NSArray *groupParts = [oneGroup componentsSeparatedByString:@"/"];
			face.v1 = [[groupParts objectAtIndex:0] intValue]-1;// indices in file are 1-indexed, not 0 indexed
			face.uv1 = [[groupParts objectAtIndex:1] intValue]-1;
			face.n1 = [[groupParts objectAtIndex:2] intValue]-1;
			oneGroup = [faceIndexGroups objectAtIndex:1];
			groupParts = [oneGroup componentsSeparatedByString:@"/"];
			face.v2 = [[groupParts objectAtIndex:0] intValue]-1;
			face.uv2 = [[groupParts objectAtIndex:1] intValue]-1;
			face.n2 = [[groupParts objectAtIndex:2] intValue]-1;
			oneGroup = [faceIndexGroups objectAtIndex:2];
			groupParts = [oneGroup componentsSeparatedByString:@"/"];
			face.v3 = [[groupParts objectAtIndex:0] intValue]-1;
			face.uv3 = [[groupParts objectAtIndex:1] intValue]-1;
			face.n3 = [[groupParts objectAtIndex:2] intValue]-1;
			[faces addObject:face];
			faceCount++;
			
		}
	}
	NSLog(@"Vertices: %d, faces: %d, normals: %d, uvs: %d",[vertices count], [faces count], [normals count], [uvs count]);
	
}
@end
