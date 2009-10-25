path c:\program files\html help workshop;%path%;

cd help.en
hhc ezmp3c.hhp
move ezmp3c.chm ..\..\bin\
cd ..

cd help.zhcn
hhc ezmp3c.hhp
move ezmp3c.chm ..\..\bin\ezmp3c.zhcn.chm
cd ..

cd help.es
hhc ezmp3c.hhp
move ezmp3c.chm ..\..\bin\ezmp3c.es.chm
cd ..
