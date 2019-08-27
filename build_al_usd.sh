#!/bin/bash

### Settings
export MAYA_LOCATION=/opt/software/thirdparty/autodesk/maya/2018.5/
export MAYA_DEVKIT_LOCATION=/uvfx/Homes/wdekeersmaecker/MayaSDK/
GIT_ORIGIN_URL=https://github.com/LumaPictures/AL_USDMaya.git
GIT_BRANCH=luma
GIT_TAG=deb432bbc52da58c8cea2bbe3625720059c61247

DEP_BOOST_VERSION=1.55.0
DEP_BOOST_VERSION_UNDERSCORES="$(echo "$DEP_BOOST_VERSION" | sed 's/\./_/g')"
DEP_BOOST_URL="https://sourceforge.net/projects/boost/files/boost/${DEP_BOOST_VERSION}/boost_${DEP_BOOST_VERSION_UNDERSCORES}.tar.gz/download"

ROOT_DIR=$(cd .; pwd)
LIBRARIES_DIR=$ROOT_DIR/AL_USD_libraries
###

echo Root dir is $ROOT_DIR

### Load USD into environment variables
if [ ! -d USD_install ]; then
   echo USD must be built first!
   exit -1
fi
export PYTHONPATH=$ROOT_DIR/USD_install/lib/python:$PYTHONPATH

### Download ALUSD source
if [ ! -d AL_USDMaya ]; then
   echo Cloning AL_USDMaya
   git clone $GIT_ORIGIN_URL || exit 1
   cd AL_USDMaya
   git checkout $GIT_BRANCH
   git checkout $GIT_TAG
   cd ..
   echo Applying patches
   patch -p0 < sourcepatches/ALUSD_FindMaya.patch || exit 1
fi

### Download dependencies
mkdir AL_USD_libraries
cd AL_USD_libraries
#### Boost
if [ ! -d boost ]; then
   echo "Installing Boost ${DEP_BOOST_VERSION}"
   if [ ! -f boost.tar.gz ]; then
       wget -O boost.tar.gz $DEP_BOOST_URL || exit 1
   fi
   tar xzf boost.tar.gz || exit 1
   cd "boost_${DEP_BOOST_VERSION_UNDERSCORES}"
   ./bootstrap.sh --with-libraries=atomic,program_options,python,regex,thread,filesystem --prefix=$ROOT_DIR/AL_USD_libraries/boost
   ./b2 install --prefix=$ROOT_DIR/AL_USD_libraries/boost -j $(nproc)
   cd ..
   rm boost.tar.gz
fi
cd ..

### Generate ALUSD makefile
source ./USD_build/venv/bin/activate

mkdir AL_USD_build
cd AL_USD_build
echo Running CMake
cmake \
	-DCMAKE_INSTALL_PREFIX=$ROOT_DIR/AL_USD_install \
	-DCMAKE_MODULE_PATH=/usr/local \
	-DMAYA_LOCATION=$MAYA_LOCATION \
	-DUSD_ROOT=$ROOT_DIR/USD_install/ \
	-DUSD_MAYA_ROOT=$ROOT_DIR/USD_install/third_party/maya/ \
	-DUSD_CONFIG_FILE=$ROOT_DIR/USD_install/pxrConfig.cmake \
	-DSKIP_USDMAYA_TESTS=1 \
	-DGTEST_ROOT=$LIBRARIES_DIR/googletest/build \
	-DBOOST_ROOT=$LIBRARIES_DIR/boost \
	-DCMAKE_PREFIX_PATH=$MAYA_LOCATION/lib/cmake \
	$ROOT_DIR/AL_USDMaya

### Build and install
echo Compiling
make -j $(nproc) install

