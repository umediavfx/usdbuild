if [ ! -f "$1/bin/usdedit" ] && [ ! -f "$1/plugin/AL_USDMayaPlugin.sh" ]; then
   echo "Invalid directory argument."
else

USDMAYA_DIR=$1

export PATH=$PATH:$USDMAYA_DIR/third_party/maya/src:/usr/local/src:$USDMAYA_DIR/src:$USDMAYA_DIR/bin:$USDMAYA_DIR/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin
export PYTHONPATH=$PYTHONPATH:$USDMAYA_DIR/third_party/maya/lib/python:/usr/local/lib/python:$USDMAYA_DIR/lib/python
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$USDMAYA_DIR/third_party/maya/lib:/usr/local/lib:$USDMAYA_DIR/lib
export MAYA_PLUG_IN_PATH=$MAYA_PLUG_IN_PATH:$USDMAYA_DIR/third_party/maya/plugin/:$USDMAYA_DIR/plugin/
export MAYA_SCRIPT_PATH=$MAYA_SCRIPT_PATH:$USDMAYA_DIR/third_party/maya/lib:$USDMAYA_DIR/third_party/maya/share/usd/plugins/usdMaya/resources:$USDMAYA_DIR/lib:/usr/local/lib:$USDMAYA_DIR/share/usd/plugins/usdMaya/resources:$USDMAYA_DIR/third_party/maya/plugin/pxrUsdPreviewSurface/resources:$USDMAYA_DIR/third_party/maya/lib/usd/usdMaya/resources/
export XMBLANGPATH=$XMBLANGPATH:$USDMAYA_DIR/third_party/maya/lib/usd/usdMaya/resources

fi
