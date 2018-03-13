# do not use generic like context since it might clash with upper setups
BACKEND_CONTEXT=$PWD

rm -rf build
mkdir -p build
git clone https://trong2nguyen@bitbucket.org/trong2nguyen/kbs_backend.git ./build/kbs_backend

cd $BACKEND_CONTEXT