## What is Gemini SK?

Gemini SK provides [Lua](http://www.lua.org) bindings to the [Sprite Kit](https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html) framework for iOS.  This allows developers to write entire Sprite Kit games in Lua.

Gemini SK is an offshoot of the work done on the [Gemini SDK](https://github.com/indiejames/GeminiSDK).  Rather than using custom OpenGL rendering of sprites and other graphics, it relies on Sprite Kit and follows the Sprite Kit APIs.  This allows developers to work with a familar API in a high level scripting language.

While Gemini SK will eventually expose the entirety of the Sprite Kit APIs, for now bindings are availabile only for a subset.  The following features are implemented to varying degrees at this time:

1. **Gemini provides high level graphics objects** including sprites, sprite sheets, and geometric shapes based on bezier paths.
2. **Gemini SK provides scene management**.  Script each level of your game as  a separate Lua module and control the order in which they get loaded directly in your Lua code via the _Director_ API.  Use any of the available Sprite Kit scene transitions.
3. **Gemini SK provides actions**.  Set up actions such as sprite animations, movement, rotations, etc.  Use bezier paths to script complex motions.  Actons can be combined to run in sequence or in parallel.
4. **Gemini SK provides physics**.  Bindings to the [Box2D](http://box2d.org) physics library allow you to add physics properties to any graphics object, including support for collision detection.  Gemini SK does not use Sprite Kit physics directly due to [limitations](http://www.element84.com/comparing-sprite-kit-physics-to-direct-box2d.html) of that implementation.  __This feature is not yet imlemented.__
5. **Gemini does sound**.  Simple sound effects are supported through bindings to `SKAction playSoundFileNamed:`.  More sophisticated control will be made available through bindings to the [Open AL framework](http://openal.org/documentation/openal-1.1-specification.pdf).
6. **Gemini SK provides an event API**.  Register objects for touch events, collision events, or other events.  Set up timer events (one-shot or recurring) to call your Lua code periodically.  Regiser Lua code as callbacks for events like the beginning of the render loop.
7. **It's easy to get started.** Just drop the Xcode project templates in your template folder and you're ready to go.

## Installation

The zip file containing the templates can be found [here](https://github.com/indiejames/GeminiSK/releases). Unzip it and copy the contents of the gemini_sk_templates directory into ~/Library/Developer/Xcode/Templates/Gemini/ then restart Xcode.  You should now be able to choose a Gemini project when you choose File->New->Project in Xcode.

## Documentation

Check out the [project page](https://github.com/indiejames/GeminiSK) or go directly to the [Lua API docs](http://indiejames.github.io/GeminiSK/documentation/files/usage-txt.html).  Also check out the [Wiki](https://github.com/indiejames/GeminiSK/wiki/Documentation) for guides and examples.


## Contributing

Contributions to Gemini SK are welcome, whether it's a bug report, feature suggestion, or a pull request.  Gemini SK is very much a work in progress and I am focusing on core features first to get it production ready as soon as possible.

## License
(The MIT License)

Copyright (c) 2013-2014 James Norton

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#### If you want to be awesome.
- Credit Gemini SK in any apps you build with it.
- Add your app to the [app list](https://github.com/indiejames/GeminiSK/wiki/Gemini-SK-Applications-List) in the Wiki so we can watch the community grow.