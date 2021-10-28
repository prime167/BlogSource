@echo off
echo "签入 markdown"
git add . && git ci -m update && git push
echo "hugo 生成 html"
hugo
cd public
echo "发布"
git add . && git ci -m update && git push
cd ..