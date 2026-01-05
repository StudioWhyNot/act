#!/bin/bash
COMMAND="$@"

# yq -p json -o yaml file.json # json -> yaml
# yq -p json -o xml file.json  # json -> xml
# yq -p yaml -o json file.yaml # yaml -> json
# yq -p yaml -o xml file.yaml  # yaml -> xml
# yq -p xml -o json file.xml   # xml -> json
# yq -p xml -o yaml file.xml   # xml -> yaml
#https://github.com/mikefarah/yq
PROGRAM=${PROGRAM:-"yq"}
OUTPUT=$(bash -c "$PROGRAM $COMMAND")
RESULT=$?

#Output multiline strings.
#https://trstringer.com/github-actions-multiline-strings/
if [[ -n "$OUTPUT" ]]; then
    echo "console<<EOF" >> "$GITHUB_OUTPUT"
    echo "$OUTPUT" >> "$GITHUB_OUTPUT"
    echo "EOF" >> "$GITHUB_OUTPUT"
fi

echo "exitCode=$RESULT" >> "$GITHUB_OUTPUT"

if [[ "$CATCH_ERRORS" != "true" ]]; then
    exit $RESULT
fi
