#!/bin/sh
rm -rf /tmp/template_build
./scripts/generate_templates.sh
./scripts/install_templates.sh