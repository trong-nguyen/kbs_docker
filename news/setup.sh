# upload your images to the exact directory structure
# matching from "content"
# aws s3 sync /path/to/your/local/content s3://your-bucket/path/to/your/s3/content


CONTEXT=$PWD

# initialize directory structure
mkdir -p $CONTEXT/ghost/content
cd $CONTEXT/ghost/content
mkdir -p adapters data logs
cd $CONTEXT


# clone and install the s3 adapter
echo "Installing adapter to serve files from AWS S3"
cd $CONTEXT
mkdir -p build
cd build && git clone https://github.com/trong-nguyen/ghost-storage-adapter-s3.git s3 &&
cd s3 && git checkout Support-existed-images &&
npm install &&
npm run install-adapter &&
rm -rf dist/package.json dist/etc
rsync -r dist/ $CONTEXT/ghost/content/adapters/
rm -rf $CONTEXT/build
cd $CONTEXT


## clone and install the latest database
# echo "Pulling the latest sqlite3 database and copying it to ghost content"
# mkdir -p build
# git clone https://trong2nguyen@bitbucket.org/trong2nguyen/kbs_news_db.git $CONTEXT/build/db &&
# cp $CONTEXT/build/db/ghost.db $CONTEXT/ghost/content/data
# rm -rf $CONTEXT/build
# cd $CONTEXT

# clone and link the working database to the repo
echo "Pulling the latest sqlite3 database and link ghost/content/data to it"
cd $CONTEXT
mkdir -p persistent
git clone https://trong2nguyen@bitbucket.org/trong2nguyen/kbs_news_db.git $CONTEXT/persistent/db &&
cd $CONTEXT