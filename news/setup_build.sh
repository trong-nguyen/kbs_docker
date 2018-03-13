# This script installs:
# 1. The aws s3 storage adapter for ghost blog - built into the images
# 2. The sqlite database hosted on github

# upload your images to the exact directory structure
# matching from "content"
# aws s3 sync /path/to/your/local/content s3://your-bucket/path/to/your/s3/content


NEWS_CONTEXT=$PWD

# initialize directory structure
rm -rf $NEWS_CONTEXT/ghost
mkdir -p $NEWS_CONTEXT/ghost/content
cd $NEWS_CONTEXT/ghost/content
mkdir -p adapters data logs
cd $NEWS_CONTEXT


# clone and install the s3 adapter
echo "Installing adapter to serve files from AWS S3"
cd $NEWS_CONTEXT
mkdir -p build
cd build && git clone https://github.com/trong-nguyen/ghost-storage-adapter-s3.git s3 &&
cd s3 && git checkout support-migrated-images &&
npm install &&
npm run build
rm -rf node_modules
npm install --only=production # install non-dev dependencies only
ADAPTER_DIR=$NEWS_CONTEXT/ghost/content/adapters
mkdir -p $ADAPTER_DIR
cp -r node_modules $ADAPTER_DIR
mkdir -p $ADAPTER_DIR/storage/s3
cp -f index.js package.json $ADAPTER_DIR/storage/s3

cd $NEWS_CONTEXT
rm -rf $NEWS_CONTEXT/build


## clone and install the latest database
# echo "Pulling the latest sqlite3 database and copying it to ghost content"
# mkdir -p build
# git clone https://trong2nguyen@bitbucket.org/trong2nguyen/kbs_news_db.git $NEWS_CONTEXT/build/db &&
# cp $NEWS_CONTEXT/build/db/ghost.db $NEWS_CONTEXT/ghost/content/data
# rm -rf $NEWS_CONTEXT/build
# cd $NEWS_CONTEXT

# # clone and link the working database to the repo
# echo "Pulling the latest sqlite3 database and link ghost/content/data to it"
# cd $NEWS_CONTEXT
# mkdir -p persistent
# git clone https://trong2nguyen@bitbucket.org/trong2nguyen/kbs_news_db.git $NEWS_CONTEXT/persistent/db &&
# cd $NEWS_CONTEXT