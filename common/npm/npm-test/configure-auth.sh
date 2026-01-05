#!/bin/bash
set -e

ACTION="$1"
AUTH_URLS="$2"
API_KEYS="$3"

if [ "$ACTION" == "add" ]; then
    # Parse newline-separated URLs and tokens into arrays
    IFS=$'\n' read -rd '' -a URLS <<< "$AUTH_URLS" || true
    IFS=$'\n' read -rd '' -a KEYS <<< "$API_KEYS" || true

    # Verify arrays have matching lengths
    if [ ${#URLS[@]} -ne ${#KEYS[@]} ]; then
        echo "Error: Number of authUrls (${#URLS[@]}) does not match number of apiKeys (${#KEYS[@]})"
        exit 1
    fi

    # Configure authentication for each registry
    for i in "${!URLS[@]}"; do
        URL="${URLS[$i]}"
        KEY="${KEYS[$i]}"

        # Skip empty entries
        if [ -z "$URL" ] || [ -z "$KEY" ]; then
            continue
        fi

        # Remove protocol from URL for npm config
        REGISTRY_PATH=$(echo "$URL" | sed -E 's|https?://||')

        echo "Configuring authentication for: $URL"
        npm config set --location=project "//${REGISTRY_PATH}:_authToken" "$KEY"
    done
elif [ "$ACTION" == "remove" ]; then
    # Clean up project .npmrc
    rm -f .npmrc
    echo "Removed npm authentication configuration"
else
    echo "Error: Invalid action '$ACTION'. Use 'add' or 'remove'"
    exit 1
fi
