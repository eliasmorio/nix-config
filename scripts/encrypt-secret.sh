#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <name> <value> [age-public-key]"
    echo "Example: $0 my-secret 'secret-value' age1..."
    echo "         (uses default key if public key not provided)"
    exit 1
fi

NAME=$1
VALUE=$2
AGE_KEY=${3:-"age1yukiage1yukiage1yukiage1yukiage1yukiage1yukiage1yuki"}

echo "Encrypting secret: $NAME"

# Create temporary file with the secret value
echo -n "$VALUE" > /tmp/$NAME.secret

# Encrypt with agenix
nix run github:ryantm/agenix -- -e secrets/$NAME.age -i secrets/$NAME.age <<< "$VALUE" 2>/dev/null || {
    echo "Encrypting manually..."
    echo "$VALUE" | age -r "$AGE_KEY" -o secrets/$NAME.age
}

# Cleanup
rm -f /tmp/$NAME.secret

echo "Secret encrypted: secrets/$NAME.age"
echo "Add this to secrets.nix:"
echo ""
echo "  $NAME = {"
echo "    file = ../secrets/$NAME.age;"
echo "    owner = \"root\";"
echo "    group = \"root\";"
echo "    mode = \"600\";"
echo "  };"
