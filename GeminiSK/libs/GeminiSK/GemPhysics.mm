//
//  GemPhysics.mm
//  GeminiSDK
//
//  Created by James Norton on 9/9/12.
//
//

#import "GemPhysics.h"
#include "Box2D.h"
#import "GemEvent.h"
#include "LGeminiShape.h"
#import "GemPhysicsBody.h"
//#import "GemCollisionEvent.h"
//#import "GemCircle.h"
//#import "GemRectangle.h"
//#import "GemConvexShape.h"
//#import "GemPhysicsJoint.h"
//#include "GemMathUtils.h"

#define RAD_TO_DEG(x) (x * M_PI / 180.0)
#define PIXELS_PER_METER (100.0)

// handles collisions between objects
class GemContactListener : public b2ContactListener {
public:
    void BeginContact(b2Contact* contact){
        /* handle begin event */
    }
    void EndContact(b2Contact* contact) {
        /* handle end event */
    }
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
        /* handle pre-solve event */
        const b2Body* bodyA = contact->GetFixtureA()->GetBody();
        const b2Body* bodyB = contact->GetFixtureB()->GetBody();
       /* GemDisplayObject *objA = (__bridge GemDisplayObject *)bodyA->GetUserData();
        GemDisplayObject *objB = (__bridge GemDisplayObject *)bodyB->GetUserData();
        
        GemCollisionEvent *event = [[GemCollisionEvent alloc] initWithLuaState:objA.L Target:objA Source:objB];
        event.name = @"collision";
        event.phase = GEM_COLLISION_PRESOLVE;
        [objA handleEvent:event];
        
        event = [[GemCollisionEvent alloc] initWithLuaState:objB.L Target:objB Source:objA];
        event.name = @"collision";
        event.phase = GEM_COLLISION_PRESOLVE;
        [objB handleEvent:event];*/
        
    }
    
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
        /* handle post-solve event */
        const b2Body* bodyA = contact->GetFixtureA()->GetBody();
        const b2Body* bodyB = contact->GetFixtureB()->GetBody();
       /* GemDisplayObject *objA = (__bridge GemDisplayObject *)bodyA->GetUserData();
        GemDisplayObject *objB = (__bridge GemDisplayObject *)bodyB->GetUserData();
        
        GemCollisionEvent *event = [[GemCollisionEvent alloc] initWithLuaState:objA.L Target:objA Source:objB];
        event.name = @"collision";
        event.phase = GEM_COLLISION_POSTSOLVE;
        [objA handleEvent:event];
        
        event = [[GemCollisionEvent alloc] initWithLuaState:objB.L Target:objB Source:objA];
        event.name = @"collision";
        event.phase = GEM_COLLISION_POSTSOLVE;
        [objB handleEvent:event];*/
    }
};


@implementation GemPhysics {
    b2World *world;
    BOOL paused;
    float timeStep;
    double accumulator;
}

@synthesize drawMode;

-(id)init {
    self = [super init];
    if (self) {
        b2Vec2 gravity(0.0f, -9.8f);
        bool doSleep = true;
        world = new b2World(gravity);
        world->SetAllowSleeping(doSleep);
        GemContactListener *listener = new GemContactListener();
        world->SetContactListener(listener);
        
        scale = PIXELS_PER_METER; // pixels per meter
        timeStep = 1.0 / 60.0; // sec
        accumulator = 0;
        paused = NO;
        
        _simulationSpeed = 1.0;
        
        drawMode = GEM_PHYSICS_NORMAL;
        
        joints = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return self;
    
}

-(void)addBodyToNode:(SKNode *)node WithParams:(NSDictionary *)params {
    b2BodyDef bodyDef;
    GemPoint p = {node.position.x, node.position.y};
    GemPoint pp = [self toPhysicsCoord:p];
    bodyDef.position.Set(pp.x, pp.y);
    bodyDef.angle = node.zRotation; // TODO - should this be cascaded?
    
    b2BodyType type = b2_staticBody;
    //b2BodyType type = b2_dynamicBody;
    
    if ([params objectForKey:@"type"] != nil) {
        NSString *typeStr = [params objectForKey:@"type"];
        if ([typeStr isEqualToString:@"dynamic"]) {
            type = b2_dynamicBody;
        } else if ([typeStr isEqualToString:@"kinematic"]){
            type = b2_kinematicBody;
        }
    }
    
    bodyDef.type = type;
    
    bodyDef.linearDamping = 0;
    bodyDef.angularDamping = 0.1;
    bodyDef.fixedRotation = false;
    bodyDef.angle = node.zRotation;
    
    b2Body* body = world->CreateBody(&bodyDef);
    
    // debug shape support
    CGMutablePathRef debugPath = CGPathCreateMutable();
    CGPathMoveToPoint(debugPath, NULL, 0, 0); // forces a line from center of shape to outline - useful for debugging rotations
    
    NSDictionary *fixtures = [params objectForKey:@"fixtures"];
    [fixtures enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        
        NSDictionary *fixtureParams = value;
        
        b2FixtureDef fixtureDef;
        b2PolygonShape polyShape;
        b2CircleShape circle;
        
        if ([fixtureParams objectForKey:@"shape"] != nil) {
            // use a polygon shape
            NSArray *points = (NSArray *)[fixtureParams objectForKey:@"shape"];
            b2Vec2 *verts = (b2Vec2 *)malloc([points count]/ 2 * sizeof(b2Vec2));
            
            for (int i=0; i<[points count]/2; i++) {
                float x = [(NSNumber *)[points objectAtIndex:i*2] floatValue];
                float y = [(NSNumber *)[points objectAtIndex:i*2+1] floatValue];
                if (i == 0) {
                    CGPathMoveToPoint(debugPath, NULL, x, y);
                } else {
                    CGPathAddLineToPoint(debugPath, NULL, x, y);
                }
                verts[i].Set(x/scale, y/scale);
            }
            
            float x = [(NSNumber *)[points objectAtIndex:0] floatValue];
            float y = [(NSNumber *)[points objectAtIndex:1] floatValue];
            
            CGPathAddLineToPoint(debugPath, NULL, x, y);
            
            polyShape.Set(verts, [points count]/2);
            fixtureDef.shape = &polyShape;
            free(verts);
            
           
            
        } else if ([fixtureParams objectForKey:@"radius"] != nil){
            // use a circle shape
            float radius = [(NSNumber *)[fixtureParams objectForKey:@"radius"] floatValue] / scale;
            
            
            NSArray *posArray = (NSArray *)[fixtureParams objectForKey:@"position"];
            float x = [(NSNumber *)[posArray objectAtIndex:0] floatValue];
            float y = [(NSNumber *)[posArray objectAtIndex:1] floatValue];
            
            CGPathAddArc(debugPath, NULL, x, y, radius  * scale, 0, 2*M_PI, NO);
            
            circle.m_p.Set(x/scale, y/scale);
            circle.m_radius = radius;
            fixtureDef.shape = &circle;
            
        } else if ([fixtureParams objectForKey:@"width"] != nil) {
            // use box shape
            float width = [(NSNumber *)[fixtureParams objectForKey:@"width"] floatValue] / scale;
            float height = [(NSNumber *)[fixtureParams objectForKey:@"height"] floatValue] / scale;
            
            polyShape.SetAsBox(width / 2.0, height / 2.0);
            fixtureDef.shape = &polyShape;
            
            CGPathAddRect(debugPath, NULL, CGRectMake(node.position.x, node.position.y, width * scale, height * scale));
            
        } else {
            NSString *luaType = [node.userData objectForKey:@"LUA_TYPE"];
            
            if ([luaType isEqualToString:[NSString stringWithFormat:@"%s", GEMINI_CIRCLE_LUA_KEY]]) {
                NSNumber *radius = [node.userData objectForKey:@"RADIUS"];
                circle.m_radius = [radius floatValue] / scale - RENDER_PADDING;
                fixtureDef.shape = &circle;
               CGPathAddArc(debugPath, NULL, 0, 0, [radius floatValue] - RENDER_PADDING * scale, 0, 2*M_PI, NO);
            } else {
                // use box shape for everything else
                float width = (node.frame.size.width) / scale - 2*RENDER_PADDING;
                float height = (node.frame.size.height) / scale - 2*RENDER_PADDING;
                
                polyShape.SetAsBox(width / 2.0, height / 2.0);
                fixtureDef.shape = &polyShape;
                
                CGPathAddRect(debugPath, NULL, CGRectMake(node.position.x, node.position.y, width * scale, height * scale));
            }
            
        }
        
        float density = 1.0;
        if ([fixtureParams objectForKey:@"density"] != nil) {
            density = [(NSNumber *)[fixtureParams objectForKey:@"density"] floatValue];
        }
        
        float friction = 1.0;
        if ([fixtureParams objectForKey:@"friction"] != nil) {
            friction = [(NSNumber *)[fixtureParams objectForKey:@"friction"] floatValue];
        }
        
        float restitution = 0;
        // support "bounce" or "restitution" keyword
        if ([fixtureParams objectForKey:@"bounce"] != nil) {
            restitution = [(NSNumber *)[fixtureParams objectForKey:@"bounce"] floatValue];
        }
        if ([fixtureParams objectForKey:@"restitution"] != nil) {
            restitution = [(NSNumber *)[fixtureParams objectForKey:@"restitution"] floatValue];
        }
        
        bool isSensor = false;
        if ([fixtureParams objectForKey:@"isSensor"] != nil) {
            isSensor = [(NSNumber *)[fixtureParams objectForKey:@"isSensor"] boolValue];
        }
        
        fixtureDef.density = density;
        fixtureDef.friction = friction;
        fixtureDef.restitution = restitution;
        fixtureDef.isSensor = isSensor;
        
        body->CreateFixture(&fixtureDef);
    }];
    
    // create a default fixture if none are supplied
    if (fixtures == nil || [fixtures count] == 0) {
        b2FixtureDef fixtureDef;
        b2CircleShape circleShape;
        b2PolygonShape polyShape;
        
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.1;
        fixtureDef.restitution = 0.5;
        
        NSString *luaType = [node.userData objectForKey:@"LUA_TYPE"];
        
        if ([luaType isEqualToString:[NSString stringWithFormat:@"%s", GEMINI_CIRCLE_LUA_KEY]]) {
            NSNumber *radius = [node.userData objectForKey:@"RADIUS"];
            
            circleShape.m_radius = [radius floatValue] / scale;
            fixtureDef.shape = &circleShape;
            
            CGPathAddEllipseInRect(debugPath, NULL, CGRectMake(0, 0, [radius floatValue], [radius floatValue]));
        } else if ([luaType isEqualToString:[NSString stringWithFormat:@"%s", GEMINI_RECTANGLE_LUA_KEY]]) {
            NSNumber *width = [node.userData objectForKey:@"WIDTH"];
            NSNumber *height = [node.userData objectForKey:@"HEIGHT"];
            
            float w = [width floatValue] / scale;
            float h = [height floatValue] /scale;
            
            polyShape.SetAsBox(w / 2.0, h / 2.0);
            fixtureDef.shape = &polyShape;
            
            CGPathAddRect(debugPath, NULL, CGRectMake(-w*scale/2.0, -h*scale/2.0, w*scale, h*scale));
            
        } else {
            // use box shape for everything else
            float width = node.frame.size.width / scale;
            float height = node.frame.size.height / scale;
            
            polyShape.SetAsBox(width / 2.0, height / 2.0);
            fixtureDef.shape = &polyShape;
            
            CGPathAddRect(debugPath, NULL, CGRectMake(-width*scale/2.0, -height*scale/2.0, width * scale, height * scale));
        }
        
        body->CreateFixture(&fixtureDef);

    }
    
    body->SetUserData((__bridge void*)node);
    NSMutableDictionary *wrapper = node.userData;
    GemPhysicsBody *gBody = [[GemPhysicsBody alloc] init];
    gBody.body = body;
    [wrapper setObject:gBody forKey:[NSString stringWithFormat:@"%s", GEMINI_PHYSICS_BODY_LUA_KEY ]];
    
    // debug
    if (drawMode == GEM_PHYSICS_DEBUG || drawMode == GEM_PHYSICS_HYBRID) {
        // add a debug shape on top
        SKShapeNode *debugNode = [[SKShapeNode alloc] init];
        debugNode.path = debugPath;
        
        UIColor *fillColor;
        UIColor *strokeColor;
        
        if (bodyDef.type == b2_staticBody) {
            fillColor = [UIColor colorWithRed:0.7 green:0 blue:0 alpha:0.7];
            strokeColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.9];
        } else if (bodyDef.type == b2_dynamicBody) {
            fillColor = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:0.7];
            strokeColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.9];
        } else {
            // kinematic
            fillColor = [UIColor colorWithRed:0 green:0 blue:0.7 alpha:0.7];
            strokeColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.9];
        }
        
        [debugNode setFillColor:fillColor];
        [debugNode setStrokeColor:strokeColor];
        debugNode.zPosition = 10;
        
        [node addChild:debugNode];
        
    }
    
}

/*-(void)deleteBodyForObject:(GemDisplayObject *)obj {
    if (obj.physicsBody != NULL) {
        world->DestroyBody((b2Body *)obj.physicsBody);
    }
}

// this method creates a Box2D joint and then returns it wrapped in a GemPhysicsJoint
-(id)addJoint:(void *)jDef forLuaState:(lua_State *)L{
    
    b2JointDef *jointDef = (b2JointDef *)jDef;
    
    b2Joint *joint =  world->CreateJoint(jointDef);
    
    // TEST
    ((b2RevoluteJoint *)joint)->SetMaxMotorTorque(100000);
    GemPhysicsJoint *gemJoint = [[GemPhysicsJoint alloc] initWithLuaState:L];
    
    gemJoint.joint = joint;
    
    [joints addObject:gemJoint];
    
    return gemJoint;
}*/

// block 
void (^updatePhysics)(double, double &, double, b2World *, GemPhysics *self) = ^(double deltaT, double &accumulator, double timeStep, b2World *world, GemPhysics *self) {
    int velocityIterations = 8;
    int positionIterations = 3;
    
    
    if (deltaT > 0.25) {
        deltaT = 0.25;// note: max frame time to avoid spiral of death
    }
    
    dispatch_queue_t my_queue = dispatch_get_global_queue(0, 0);

    
    accumulator += deltaT;
    
    while ( accumulator >= timeStep ) {
        if (accumulator < timeStep * 2.0) {
            // only update if on last simulation loop
        
            dispatch_sync(my_queue, ^{
                for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
                    
                    b2Vec2 position = b->GetPosition();
                    GemPoint pPoint = {position.x, position.y};
                    GemPoint point = [self fromPhysicsCoord:pPoint];
                    float32 angle = b->GetAngle();
                    
                    SKNode *node = (__bridge  SKNode *)b->GetUserData();
                    node.zRotation = angle;
                    double x = point.x;
                    double y = point.y;
                    
                    node.position = CGPointMake(x, y);
                    
                    /*if ([node.name isEqualToString:@"mario"]){  // TODO - remove this when finished
                      GemLog(@"(name: x,y,theta) = (%@: %4.2f, %4.2f, %4.2f)\n", node.name, position.x, position.y, angle);
                    }*/
                    
                }
            });
            
            
        }
        
        
        world->Step(timeStep, velocityIterations, positionIterations);
        
        
        accumulator -= timeStep;
    }
    
    // interpolate remainder of update
    const double alpha = accumulator / timeStep;
    
    dispatch_sync(my_queue, ^{
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
        
        b2Vec2 position = b->GetPosition();
        GemPoint pPoint = {position.x, position.y};
        GemPoint point = [self fromPhysicsCoord:pPoint];
        float32 angle = b->GetAngle();
        
//        GemDisplayObject *gdo = (__bridge GemDisplayObject *)b->GetUserData();
        SKNode *node = (__bridge  SKNode *)b->GetUserData();
        node.zRotation = alpha * angle + (1.0-alpha)*node.zRotation;
        double x = alpha * point.x + (1.0 - alpha)*node.position.x;
        double y = alpha * point.y + (1.0-alpha)*node.position.y;
        
        node.position = CGPointMake(x, y);
        
    }
    });
};

-(void)update:(double)deltaT {
    
    if (paused) {
        return;
    }
    
    deltaT = _simulationSpeed * deltaT;
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(globalQueue, ^(){
        updatePhysics(deltaT, accumulator, timeStep, world, self);
    });

    
}

-(bool)isActiveBody:(void *)body {
    b2Body *physBody = (b2Body *)body;
    return physBody->IsActive();
}

-(void)setBody:(void *)body isActive:(bool)active {
    b2Body *physBody = (b2Body *)body;
    physBody->SetActive(active);
}

/*-(BOOL)doesBody:(void *)body ContainPoint:(GLKVector2)point {
    b2Body *physicsBody = (b2Body *)body;
    
    b2Vec2 p;
    p.x = point.x / scale;
    p.y = point.y / scale;
    
    b2Fixture* fixture = ((b2Body *)physicsBody)->GetFixtureList();
    while(fixture != NULL) {
        if (fixture->TestPoint(p)) {
            return YES;
        }
        
        fixture = fixture->GetNext();
    }
    
    return NO;

}*/

-(void)setScale:(double)s {
    scale = s;
}

-(float)getScale {
    return scale;
}

-(void *)getWorld {
    return world;
}

-(void)setContinous:(bool) cont{
    world->SetContinuousPhysics(cont);
}

-(void)setGravityGx:(float)gx Gy:(float)gy {
    b2Vec2 g(gx,gy);
    
    world->SetGravity(g);
}

-(void)pause {
    paused = YES;
}

-(void)start {
    paused = NO;
}

-(GemPoint)toPhysicsCoord:(GemPoint)point {
    GemPoint rval;
    rval.x = point.x / scale;
    rval.y = point.y / scale;
    
    return rval;
}

-(GemPoint)fromPhysicsCoord:(GemPoint)point {
    GemPoint rval;
    rval.x = point.x * scale;
    rval.y = point.y * scale;
    
    return rval;
}



@end

