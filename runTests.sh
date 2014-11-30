#!/bin/bash
cp -r tests/* web-export
cd tests/spec
jitter . ../../web-export/spec
