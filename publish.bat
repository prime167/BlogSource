@echo off
echo "hugo ���� html"
hugo

echo "ǩ�� markdown"
git add . && git ci -m update && git push

echo "����"
cd public
git add . && git ci -m update && git push
cd ..