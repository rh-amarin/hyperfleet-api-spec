#!/bin/bash

# Build HyperFleet OpenAPI Schema
# Usage: ./build-schema.sh [provider]
#   provider: core, gcp, or any provider with aliases-{provider}.tsp file

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the provider from command line argument
PROVIDER="${1:-core}"

# Script directory (where the script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Validate provider argument
if [ -z "$PROVIDER" ]; then
    echo -e "${RED}Error: Provider argument is required${NC}"
    echo "Usage: $0 [provider]"
    echo "  provider: core, gcp, or any provider with aliases-{provider}.tsp file"
    exit 1
fi

# Define the aliases file for the provider
ALIASES_FILE="aliases-${PROVIDER}.tsp"

# Check if the aliases file exists
if [ ! -f "$ALIASES_FILE" ]; then
    echo -e "${RED}Error: Provider aliases file not found: ${ALIASES_FILE}${NC}"
    echo ""
    echo "Available providers:"
    for file in aliases-*.tsp; do
        if [ -f "$file" ]; then
            provider_name=$(echo "$file" | sed 's/aliases-\(.*\)\.tsp/\1/')
            echo "  - $provider_name"
        fi
    done
    exit 1
fi

# Check if main.tsp exists
if [ ! -f "main.tsp" ]; then
    echo -e "${RED}Error: main.tsp not found in current directory${NC}"
    exit 1
fi

# Check if tsp command is available
if ! command -v tsp &> /dev/null; then
    echo -e "${RED}Error: tsp command not found. Please install TypeSpec compiler.${NC}"
    echo "Install with: npm install -g @typespec/compiler"
    exit 1
fi

echo -e "${GREEN}Building HyperFleet API schema for provider: ${PROVIDER}${NC}"
echo ""

# Step 1: Re-link aliases.tsp to the provider-specific aliases file
echo -e "${YELLOW}Step 1: Linking aliases.tsp to ${ALIASES_FILE}${NC}"
if [ -L "aliases.tsp" ] || [ -f "aliases.tsp" ]; then
    rm -f aliases.tsp
fi
ln -sf "$ALIASES_FILE" aliases.tsp
echo -e "${GREEN}✓ Linked aliases.tsp → ${ALIASES_FILE}${NC}"
echo ""

# Step 2: Compile TypeSpec to generate OpenAPI schema
echo -e "${YELLOW}Step 2: Compiling TypeSpec...${NC}"
if tsp compile main.tsp; then
    echo ""
    echo -e "${GREEN}✓ Successfully generated OpenAPI schema${NC}"
    echo -e "${GREEN}Output: tsp-output/schema/openapi.yaml${NC}"
else
    echo ""
    echo -e "${RED}✗ Failed to compile TypeSpec${NC}"
    exit 1
fi

