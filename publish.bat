@echo off
echo "ǩ�� markdown"
git add . && git ci -m a && git push
echo "hugo ���� html"
hugo
cd public
echo "����"
git add . && git ci -m a && git push
cd ..