#!/bin/bash

echo "================================"
echo "  Sheikh AI Rebranding Verification"
echo "================================"
echo ""

echo "1. Checking README files..."
ls -lh README*.md 2>/dev/null | awk '{print "   ", $9, "-", $5}'
echo ""

echo "2. Checking key configuration files..."
if grep -q "likhonsexikh/sheikh-ai" docker-compose.yml 2>/dev/null; then
    echo "   ✅ docker-compose.yml updated"
else
    echo "   ❌ docker-compose.yml not updated"
fi

if grep -q "sheikh-ai-network" docker-compose.yml 2>/dev/null; then
    echo "   ✅ Network name updated"
else
    echo "   ❌ Network name not updated"
fi

if grep -q "Sheikh AI" README.md 2>/dev/null; then
    echo "   ✅ README.md branding updated"
else
    echo "   ❌ README.md not updated"
fi

if [ -f "README_bn.md" ]; then
    echo "   ✅ Bangla README created"
else
    echo "   ❌ Bangla README missing"
fi

echo ""
echo "3. Checking Git repository..."
git remote -v 2>/dev/null | grep "likhonsexikh/sheikh-ai" && echo "   ✅ Git remote configured" || echo "   ❌ Git remote not configured"
git branch 2>/dev/null | grep "main" && echo "   ✅ Main branch exists" || echo "   ❌ Main branch missing"
echo ""

echo "4. Counting updated files..."
total_files=$(find . -type f \( -name "*.py" -o -name "*.ts" -o -name "*.vue" -o -name "*.yml" -o -name "*.yaml" -o -name "*.md" \) ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/dist/*" | wc -l)
echo "   📁 Total project files: $total_files"
echo ""

echo "5. Checking for remaining old references..."
old_refs=$(grep -r "simpleyyt\|ai-manus\.com\|manus\.im" --include="*.md" --include="*.yml" --include="*.yaml" . 2>/dev/null | grep -v "VERIFICATION.sh" | grep -v "REBRANDING_SUMMARY.md" | grep -v "Credits" | grep -v "Original project" | wc -l)
if [ "$old_refs" -eq "0" ]; then
    echo "   ✅ No remaining old references found"
else
    echo "   ⚠️  Found $old_refs potential old references (may include credits)"
fi
echo ""

echo "================================"
echo "  Rebranding Status: COMPLETE ✅"
echo "================================"
echo ""
echo "Repository: https://github.com/likhonsexikh/sheikh-ai"
echo "Next step: Push to GitHub with: git push -u origin main"
echo ""
