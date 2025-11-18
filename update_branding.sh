#!/bin/bash

# Script to rebrand AI Manus to Sheikh AI

echo "Starting rebranding process..."

# Function to replace text in files
replace_in_files() {
    local pattern=$1
    local replacement=$2
    local extension=$3
    
    find . -type f -name "*.$extension" ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/dist/*" ! -path "*/__pycache__/*" -exec sed -i "s|$pattern|$replacement|g" {} +
}

# Docker image references
echo "Updating Docker image references..."
find . -type f \( -name "*.py" -o -name "*.yml" -o -name "*.yaml" -o -name "*.md" -o -name "*.sh" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|likhonsexikh/sheikh-ai-|likhonsexikh/sheikh-ai-|g' {} +

# Network names
echo "Updating network names..."
find . -type f \( -name "*.py" -o -name "*.yml" -o -name "*.yaml" -o -name "*.md" -o -name "*.env*" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|manus-network|sheikh-ai-network|g' {} +

# Database names
echo "Updating database names..."
find . -type f \( -name "*.py" -o -name "*.yml" -o -name "*.yaml" -o -name "*.md" -o -name "*.env*" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|MONGODB_DATABASE=manus|MONGODB_DATABASE=sheikh_ai|g' {} +
find . -type f \( -name "*.py" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|database="manus"|database="sheikh_ai"|g' {} +

# Volume names
echo "Updating volume names..."
find . -type f \( -name "*.yml" -o -name "*.yaml" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|manus-mongodb-data|sheikh-ai-mongodb-data|g' {} +

# URLs and domains
echo "Updating URLs..."
find . -type f \( -name "*.md" -o -name "*.py" -o -name "*.ts" -o -name "*.vue" -o -name "*.html" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|ai-manus\.com|sheikhAI.com|g' {} +
find . -type f \( -name "*.md" -o -name "*.py" -o -name "*.ts" -o -name "*.vue" -o -name "*.html" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|app\.ai-manus\.com|sheikhAI.com|g' {} +
find . -type f \( -name "*.md" -o -name "*.py" -o -name "*.ts" -o -name "*.vue" -o -name "*.html" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|docs\.ai-manus\.com|docs.sheikhAI.com|g' {} +
find . -type f \( -name "*.md" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|manus\.im|sheikhAI.com|g' {} +

# GitHub repository references
echo "Updating GitHub repo references..."
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|simpleyyt/ai-manus|likhonsexikh/sheikh-ai|g' {} +
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|Simpleyyt/ai-manus|likhonsexikh/sheikh-ai|g' {} +

# Brand name "AI Manus" -> "Sheikh AI"
echo "Updating brand name..."
find . -type f \( -name "*.md" -o -name "*.py" -o -name "*.ts" -o -name "*.vue" -o -name "*.html" -o -name "*.json" \) ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/dist/*" -exec sed -i 's|AI Manus|Sheikh AI|g' {} +

# "Manus" standalone -> "Sheikh AI" (in titles, headings)
echo "Updating Manus references..."
find . -type f \( -name "*.md" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|# Manus|# Sheikh AI|g' {} +
find . -type f \( -name "*.html" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|<title>Manus</title>|<title>Sheikh AI</title>|g' {} +

# Update frontend references in comments
find . -type f \( -name "*.py" -o -name "*.ts" -o -name "*.vue" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|manus frontend|Sheikh AI frontend|g' {} +
find . -type f \( -name "*.py" -o -name "*.ts" -o -name "*.vue" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|Manus frontend|Sheikh AI frontend|g' {} +
find . -type f \( -name "*.py" -o -name "*.ts" -o -name "*.vue" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|Manus backend|Sheikh AI backend|g' {} +
find . -type f \( -name "*.py" -o -name "*.ts" -o -name "*.vue" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|Manus sandbox|Sheikh AI sandbox|g' {} +

# Update "access Manus" -> "access Sheikh AI"
find . -type f \( -name "*.md" \) ! -path "*/node_modules/*" ! -path "*/.git/*" -exec sed -i 's|access Manus|access Sheikh AI|g' {} +

echo "Rebranding complete!"
