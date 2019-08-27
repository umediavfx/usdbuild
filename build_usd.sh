export MAYA_LOCATION=/opt/software/thirdparty/autodesk/maya/2018.5/
GIT_ORIGIN_URL=https://github.com/PixarAnimationStudios/USD.git
GIT_TAG=v19.07

if [ ! -d USD ]; then
   echo Cloning USD
   git clone $GIT_ORIGIN_URL
   cd USD
   git checkout $GIT_TAG
   cd ..
   patch -p0 < sourcepatches/USD_FindMaya.patch
fi

#if [ -d USD_install ]; then
#   echo Cleaning install dir
#   rm -rf USD_install
#fi

if [ ! -d USD_build ]; then
   echo Preparing build environment
   mkdir USD_build
   cd USD_build
   pip install --user virtualenv
   virtualenv venv
   source ./venv/bin/activate
   pip install pyopengl pyside jinja2
   cd ..
else
   source USD_build/venv/bin/activate
fi

mkdir USD_install
cd USD_build
echo Compiling USD
python ../USD/build_scripts/build_usd.py --maya --maya-location $MAYA_LOCATION --build .  ../USD_install

