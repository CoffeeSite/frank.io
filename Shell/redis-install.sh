BASE_PATH=.
if [ -n "$1" ]; then
  BASE_PATH=$1
fi

cd $BASE_PATH

yum -y install gcc
yum -y install tcl
wget http://download.redis.io/releases/redis-4.0.1.tar.gz
tar -xvf redis-4.0.1.tar.gz
cd ./redis-4.0.1
make MALLOC=libc
make test
