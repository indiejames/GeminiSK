//
//  GemPhysics.h
//  GeminiSDK
//
//  Created by James Norton on 9/9/12.
//
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define RENDER_PADDING (0.0)

typedef enum {
    GEM_PHYSICS_NORMAL,
    GEM_PHYSICS_HYBRID,
    GEM_PHYSICS_DEBUG
} GemPhysicsDrawMode;

typedef struct {
    double x;
    double y;
} GemPoint;

@interface GemPhysics : NSObject {
    double scale;  // pixes per meter
    GemPhysicsDrawMode drawMode;
    NSMutableArray *joints;
}

@property (nonatomic) GemPhysicsDrawMode drawMode;
@property (nonatomic) float simulationSpeed;

-(void)setScale:(double)s;
-(float)getScale;
-(void *)getWorld; // cheap, but I need to let GemPhysicsBody use the world to make things and I don't
                  // want to pollute everything with C++
-(void)setContinous:(bool) cont;
-(void)setGravityGx:(float)gx Gy:(float)gy;
-(void)pause;
-(void)start;
-(GemPoint)toPhysicsCoord:(GemPoint)point;
-(GemPoint)fromPhysicsCoord:(GemPoint)point;
-(void)addBodyToNode:(SKNode *)node WithParams:(NSDictionary *)params;
//-(void)deleteBodyForObject:(GemDisplayObject *)obj;
//-(id)addJoint:(void *)jointDef forLuaState:(lua_State *)L;
-(void)update:(double)deltaT;
//-(BOOL)doesBody:(void *)body ContainPoint:(GLKVector2)point;
-(bool)isActiveBody:(void *)body;
-(void)setBody:(void *)body isActive:(bool)active;

@end
