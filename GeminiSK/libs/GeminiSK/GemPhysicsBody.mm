//
//  GemPhysicsBody.m
//  GeminiSK
//
//  Created by James Norton on 9/8/13.
//  Copyright (c) 2013 James Norton. All rights reserved.
//

#import "GemPhysicsBody.h"
#import "Gemini.h"
#include "Box2D.h"

@interface GemPhysicsBody () {
    
    b2BodyDef bodyDef;
    b2Body *body;
    b2FixtureDef *fixtureDefs;
    unsigned int fixtureCount;
}

@end

@implementation GemPhysicsBody

-(id)init {
    self = [super init];
    if (self) {
        fixtureDefs = NULL;
        fixtureCount = 0;
        body = NULL;
        bodyDef.type = b2_dynamicBody;
        bodyDef.bullet = false;
        bodyDef.awake = true;
        bodyDef.linearDamping = 0;
        bodyDef.allowSleep = true;
        bodyDef.angularDamping = 0;
        bodyDef.fixedRotation = false;
        bodyDef.gravityScale = 1.0;
    }
    
    return self;
}

-(void)initb2BodyForNode:(SKNode *)node {
    
    GemSKScene *scene = [Gemini shared].director.activeScene;
    double scale = [scene.physics getScale];
    
    b2World *world = (b2World *)[scene.physics getWorld];
    bodyDef.position.Set(node.position.x / scale, node.position.y / scale);
    body = world->CreateBody(&bodyDef);
    for (int i=0;i<fixtureCount;i++){
        b2FixtureDef fixtureDef = fixtureDefs[i];
        body->CreateFixture(&fixtureDef);
    }
    body->SetUserData((__bridge void *) node);
    
}

// TODO - revist this function to try to clean up memory usage
-(void)addFixture:(void *)fixtureDef {
    b2FixtureDef *fDef = (b2FixtureDef *)fixtureDef;
    fDef->restitution = 0;
    fDef->density = 1.0;
    fDef->friction = 0.1;
    fDef->isSensor = 0;
    
    fixtureCount += 1;
    fixtureDefs = (b2FixtureDef *)realloc(fixtureDefs, fixtureCount * sizeof(b2FixtureDef));
    memcpy(&(fixtureDefs[fixtureCount - 1]), fixtureDef, sizeof(b2FixtureDef));
    
    if (body) {
        body->CreateFixture(fDef);
    }
    
}

// properties
-(BOOL)allowsRotation {
    return !bodyDef.fixedRotation;
}

-(void)setAllowsRotation:(BOOL)allowsRotation {
    bodyDef.fixedRotation = !allowsRotation;
}

-(float)angle {
    float angle = bodyDef.angle;
    if (body) {
        angle = body->GetAngle();
    }
    
    return angle;
}

-(void)setAngle:(float)angle {
    if (body) {
        body->SetTransform(body->GetPosition(), angle);
    } else {
        bodyDef.angle = angle;
    }
}

-(float)angularVelocity {
    float angularVelocity = bodyDef.angularVelocity;
    
    if (body){
        angularVelocity = body->GetAngularVelocity();
    }
    
    return angularVelocity;
}

-(void)setAngularVelocity:(float)angularVelocity {
    if (body) {
        body->SetAngularVelocity(angularVelocity);
    } else {
        bodyDef.angularVelocity = angularVelocity;
    }
}

-(uint32_t)categoryBitMask {
    uint32_t bm  = 0XFFFF;
    if (body) {
        bm = body->GetFixtureList()->GetFilterData().categoryBits;
    } else if (fixtureCount > 0) {
        bm = fixtureDefs[0].filter.categoryBits;
    }
    
    return bm;
}

// TODO - fix this so it doesn't use same filter for all fixtures
-(void)setCategoryBitMask:(uint32_t)categoryBitMask {
    b2Filter filter;
    if (body) {
        filter = body->GetFixtureList()->GetFilterData();
        filter.categoryBits = categoryBitMask;
        body->GetFixtureList()->SetFilterData(filter);
    } else if (fixtureCount > 0) {
        filter = fixtureDefs[0].filter;
        filter.categoryBits = categoryBitMask;
        for(int i=0;i<fixtureCount;i++){
            fixtureDefs[i].filter = filter;
        }
    }
}

-(float)density {
    float density = 0;
    if (body) {
        density = body->GetFixtureList()->GetDensity();
    } else if (fixtureCount > 0){
        density = fixtureDefs[0].density;
    }
    
    return density;
}

-(void)setDensity:(float)density {
    if (body) {
        body->GetFixtureList()->SetDensity(density);
        body->ResetMassData();
    } else if (fixtureCount > 0){
        for (int i=0;i<fixtureCount;i++){
            fixtureDefs[i].density = density;
        }
    }
}

-(BOOL)dynamic {
    return bodyDef.type == b2_dynamicBody;
}

-(void)setDynamic:(BOOL)dynamic {
    if (dynamic) {
        bodyDef.type = b2_dynamicBody;
    } else {
        bodyDef.type = b2_staticBody; // don't use kinematic type
    }
}


-(float)friction {
    float friction = 0;
    if (body) {
        friction = body->GetFixtureList()->GetFriction();
    } else if (fixtureCount > 0){
        friction = fixtureDefs[0].friction;
    }
    
    return friction;
}

-(void)setFriction:(float)friction {
    if (body) {
        body->GetFixtureList()->SetFriction(friction);
    } else if (fixtureCount > 0) {
        for (int i=0; i<fixtureCount; i++) {
            fixtureDefs[i].friction = friction;
        }
        
    }
}

-(float)gravityScale {
    float gravityScale = 1.0;
    
    if (body) {
        gravityScale = body->GetGravityScale();
    } else {
        gravityScale = bodyDef.gravityScale;
    }
    
    return gravityScale;
}

-(void)setGravityScale:(float)gravityScale {
    if (body) {
        body->SetGravityScale(gravityScale);
    }
    
    bodyDef.gravityScale = gravityScale;
    
}

-(float)linearDamping {
    float linearDamping = 0;
    
    if (body) {
        body->SetLinearDamping(linearDamping);
    } else {
        linearDamping = bodyDef.linearDamping;
    }
    
    return linearDamping;
}

-(void)setLinearDamping:(float)linearDamping {
    if (body) {
        body->SetLinearDamping(linearDamping);
    } else {
        bodyDef.linearDamping = linearDamping;
    }
}


-(float)restitution {
    float restitution = 0;
    if (body) {
        restitution = body->GetFixtureList()->GetRestitution();
    } else if (fixtureCount > 0) {
        restitution = fixtureDefs[0].restitution;
    }
    
    return restitution;
}

-(void)setRestitution:(float)restitution {
    if (body) {
        body->GetFixtureList()->SetRestitution(restitution);
    } else {
        if (fixtureCount > 0) {
            for(int i=0;i<fixtureCount;i++){
                fixtureDefs[i].restitution = restitution;
            }
        }
    }
}

-(BOOL)usesPreciseCollisionDetection {
    BOOL pcd = bodyDef.bullet;
    if (body) {
        pcd = body->IsBullet();
    }
    
    return pcd;
}

-(void)setUsesPreciseCollisionDetection:(BOOL)usesPreciseCollisionDetection {
    if (body) {
        body->SetBullet(usesPreciseCollisionDetection);
    }
    
    bodyDef.bullet = usesPreciseCollisionDetection;
}


-(void)dealloc {
    for (int i=0;i<fixtureCount; i++){
        b2FixtureDef def = fixtureDefs[i];
        const b2Shape *shape = def.shape;
        
        delete shape;
    }
    free(fixtureDefs);
    b2World *world = (b2World *)[[[Gemini shared].director currentScene].physics getWorld];
    world->DestroyBody(body);
    [self.userData removeAllObjects];
    self.userData = nil;
}

@end
