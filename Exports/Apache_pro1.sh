#!/bin/sh
echo -ne '\033c\033]0;Atmosphere\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Apache_pro1.x86_64" "$@"
