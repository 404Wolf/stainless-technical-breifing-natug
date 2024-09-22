#!/bin/sh

for file in *.mermaid; do
    mmdc -i "$file" -o out/"${file%.mermaid}".png -t neutral
done
