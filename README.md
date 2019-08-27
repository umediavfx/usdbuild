# usdbuild
This repo contains build scripts for Pixar's Universal Scene Descriptor (USD) and AnimalLogic's AL_USDMaya (Lumapictures fork)
These scripts download the necessary dependencies, setup a build environment and compile these projects.
The scripts were tested on CentOS 7 and require Git, Python2 and Maya (+SDK) to be installed.
You may have to adjust the path to Maya installation directory in the top of the scripts for your local setup.

After running build_usd.sh, the compiled artifacts can be found in USD_install.
Likewise, build_al_usd.sh will put the plugin files in AL_USD_install.

To use the plugins, first adjust your environment variables using the setup_env.sh script like so:

```
source setup_env.sh /full/path/to/install/directory/
```

Then start Maya with `maya &`
