#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Running TypeScript Any Type Check...${NC}\n"

# Find all TypeScript files in src directory
total_files=$(find src -name "*.ts" | wc -l)
echo -e "${GREEN}Total TypeScript Files:${NC} $total_files"

# Find files with explicit :any type annotations
files_with_any=$(grep -l ": any" --include="*.ts" -r src | wc -l)
any_occurrences=$(grep -o ": any" --include="*.ts" -r src | wc -l)

# Find files with any[] type annotations
files_with_any_array=$(grep -l "any\[\]" --include="*.ts" -r src | wc -l)
any_array_occurrences=$(grep -o "any\[\]" --include="*.ts" -r src | wc -l)

# Find files with implicit any parameters (no type annotation)
# This is a simplified check and might have false positives/negatives
implicit_any=$(grep -r --include="*.ts" -E "function\s*\([^:)]*\)" src | wc -l)

echo -e "${RED}Files with :any type:${NC} $files_with_any ($(echo "scale=1; $files_with_any*100/$total_files" | bc)%)"
echo -e "${RED}Total :any occurrences:${NC} $any_occurrences"
echo -e "${YELLOW}Files with any[] type:${NC} $files_with_any_array ($(echo "scale=1; $files_with_any_array*100/$total_files" | bc)%)"
echo -e "${YELLOW}Total any[] occurrences:${NC} $any_array_occurrences"
echo -e "${YELLOW}Potential implicit any parameters:${NC} $implicit_any"

echo -e "\n${BLUE}Files with most :any types:${NC}"
grep -o ": any" --include="*.ts" -r src | sort | uniq -c | sort -nr | head -n 10 | while read -r count file; do
    file_path=${file/": any"/}
    echo -e "${RED}$count${NC} occurrences in ${BLUE}$file_path${NC}"
done

echo -e "\n${BLUE}Files with any[] types:${NC}"
grep -l "any\[\]" --include="*.ts" -r src | while read -r file; do
    count=$(grep -o "any\[\]" "$file" | wc -l)
    echo -e "${YELLOW}$count${NC} occurrences in ${BLUE}$file${NC}"
done

echo -e "\n${GREEN}Progress Summary:${NC}"
echo -e "Files without any types: $(($total_files - $files_with_any)) out of $total_files ($(echo "scale=1; ($total_files-$files_with_any)*100/$total_files" | bc)%)"
echo -e "Type safety score: $(echo "scale=1; ($total_files-$files_with_any)*100/$total_files" | bc)%"

exit 0 