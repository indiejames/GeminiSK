#!/bin/sh

./scripts/generate_base_templates.rb -o /tmp/template_build -s ./GeminiSK -t ./templates
./scripts/generate_gemini_template.rb -o /tmp/template_build -s ./GeminiSK ./templates/TemplateInfo.plist.geminisk
./scripts/generate_lib_template.rb -o /tmp/template_build -s ./GeminiSK ./templates/lib/TemplateInfo.plist.lib_lua
./scripts/generate_lib_template.rb -o /tmp/template_build -s ./GeminiSK ./templates/lib/TemplateInfo.plist.lib_GeminiSK -v
./scripts/generate_lib_template.rb -o /tmp/template_build -s ./GeminiSK ./templates/lib/TemplateInfo.plist.lib_Box2D -v
./scripts/generate_lib_template.rb -o /tmp/template_build -s ./GeminiSK ./templates/lib/TemplateInfo.plist.lib_LuaSQLite3 -v