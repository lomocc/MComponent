#!/bin/bash
ftp -n << !
open lomo.cc
user lomo u2u8vzrsx8re
binary
hash
cd public_html/simple/widget
lcd bin-debug
prompt
mkdir fla
mkdir fla/images
mput *
mput fla/*
mput fla/images/*
bye
!