#!/bin/bash
INPUT="$1"
INPUT_TYPE="$2"
OUTPUT_TYPE="$3"
TRANSFER_TYPE="$4"
TMP_DIR="$5"
MKTEMP_ARGS="$6"

# match up the output type to the input type.
if [[ $OUTPUT_TYPE == 'auto' ]]; then
    if [[ $INPUT_TYPE == 'raw' ]]; then
        OUTPUT_TYPE="file"
    elif [[ $INPUT_TYPE == 'expression' ]]; then
        OUTPUT_TYPE="dir"
    else
        OUTPUT_TYPE="$INPUT_TYPE"
    fi
fi

if [[ $INPUT_TYPE == 'raw' && $OUTPUT_TYPE == 'dir' && -n "$INPUT" ]]; then
    echo "Can't output raw input to a temporary directory."
    exit 1
fi

if [[ $OUTPUT_TYPE == "dir" ]]; then
    MKTEMP_ARGS="-d $MKTEMP_ARGS"
fi

mkdir -p "$TMP_DIR"

TMP=$(mktemp -p "$TMP_DIR" $MKTEMP_ARGS)
echo "tmp=$TMP" >> "$GITHUB_OUTPUT"

if [[ -z "$INPUT" ]]; then
    exit 0
fi

TRANSFER_COMMAND="cp -r"
if [[ $TRANSFER_TYPE == 'move' ]]; then
    TRANSFER_COMMAND="mv"
fi

if [[ $INPUT_TYPE == 'raw' ]]; then
    echo "$INPUT" > "$TMP"
elif [[ $OUTPUT_TYPE == 'file' ]]; then
    $TRANSFER_COMMAND "$INPUT" "$TMP"
elif [[ $OUTPUT_TYPE == 'dir' ]]; then
    if [[ $INPUT_TYPE == "expression" ]]; then
        $TRANSFER_COMMAND $INPUT "$TMP"
    else
        $TRANSFER_COMMAND "$INPUT" "$TMP"
    fi
    
fi
