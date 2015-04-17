
  199  g++ -shared -Wl, -soname libadd.so.1 -o libadd.so.1.0.1 add.o 
  200  g++ -shared -Wl,-soname libadd.so.1 -o libadd.so.1.0.1 add.o 
  201  g++ -shared -Wl,-soname,libadd.so.1 -o libadd.so.1.0.1 add.o 
  202  ls
  203  vim test-proc-maps.cpp 
  204  g++ test-proc-maps.cpp -ladd
  205  g++ test-proc-maps.cpp -ladd -L~/workspace/playground
  206  g++ test-proc-maps.cpp -ladd -L~/workspace/playground/
  207  pwd
  208  g++ test-proc-maps.cpp -ladd -L/home/hong/workspace/playground
  209  g++ test-proc-maps.cpp -ladd -L/home/hong/workspace/playground/
  210  g++ test-proc-maps.cpp -ladd -L/home/hong/workspace/playground/ -v
  211  g++ test-proc-maps.cpp -ladd -L/home/hong/workspace/playground/
  212  g++ -L/home/hong/workspace/playground/ test-proc-maps.cpp -ladd 
  213  g++ -L/home/hong/workspace/playground test-proc-maps.cpp -ladd 
  214  g++ -L/home/hong/workspace/playground -ladd test-proc-maps.cpp
  215  g++ -L/home/hong/workspace/playground -ladd test-proc-maps.cpp -o xxx
  216  g++ -L/home/hong/workspace/playground -ladd test-proc-maps.cpp
  217  ls
  218  g++ -shared  libadd.so add.o 
  219  g++ -shared  -o libadd.so add.o 
  220  g++ -L/home/hong/workspace/playground -ladd test-proc-maps.cpp
  221  g++ -L/home/hong/workspace/playground -ladd test-proc-maps.cpp -Wl,-rpath=/home/hong/workspace/playground
  222  g++ -L/home/hong/workspace/playground -ladd test-proc-maps.cpp 
  223  g++ -c test-proc-maps.cpp 
  224  g++ -L/home/hong/workspace/playground -ladd test-proc-maps.cpp 
  225  g++ -L/home/hong/workspace/playground  test-proc-maps.cpp  -ladd
  226  ./a.out 
  227  g++ -L/home/hong/workspace/playground  test-proc-maps.cpp  -ladd -Wl,-rpath=/home/hong/workspace/playground
  228  ./a.out 
  229  history
  

  http://stackoverflow.com/questions/12272864/linker-error-on-linux-undefined-reference-to
  编译的时候出现这种错误
  /media/sf_BitEagle_Projects/cbitcoin/test/testCBAddress.c:40:
  undefined reference to CBNewByteArrayFromString
  解决方法
Put the libraries after the object files
If you don't do that, the linker may decide that it needs nothing from a particular library at the stage of the link where it scans the library, and then it won't rescan the library later after it finds some undefined symbols in the object files. If you put the object files first, you don't run into this problem.


http://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html
不错的网页
要用LD_LIBRARY_PATH或者rpath，指定。。。

http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html
不错
里面比较详细

