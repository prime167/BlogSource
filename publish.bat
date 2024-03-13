@echo off
echo "hugo generate html"
hugo

echo "Checkin markdown"
git add . && git ci -m update && git push

echo "Publish to github pages"
cd public
git add . && git ci -m update && git push
cd ..

pause