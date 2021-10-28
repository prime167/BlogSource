@echo off
echo "hugo 生成 html"
hugo

echo "签入 markdown"
git add . && git ci -m update && git push

echo "发布"
cd public
git add . && git ci -m update && git push
cd ..