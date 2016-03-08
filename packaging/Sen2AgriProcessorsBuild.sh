#!/bin/bash
#set -x #echo on

##
## SCRIPT: BUILD SEN2AGRI PROCESSORS
##
##
## SCRIPT STEPS
##     - CREATE DIR TREE: Sen2AgriProcessors/install, Sen2AgriProcessors/build and Sen2AgriProcessors/rpm_binaries
##     - COMPILE AND INSTALL SEN2AGRI PROCESSORS
##     - RPM GENERATION FOR COMPILED SEN2AGRI PROCESSORS
##     - RPM GENERATION FOR DEMMACCS AND DOWNLOADERS
###########################CONFIG PART###########################################################
### URLs FOR RETRIEVING SOURCES PACKAGES
: ${SEN2AGRI_URL:="git@192.168.60.52:/srv/git/sen2agri.git"}

### DEPENDENCIES FOR GENERATED RPM PACKAGES
: ${PLATFORM_INSTALL_DEP:="-d "boost" -d "curl" -d "expat" -d "fftw" -d "gdal" -d "geos" -d "libgeotiff" -d "libjpeg-turbo" -d "libsvm" -d "muParser" \
-d "opencv" -d "openjpeg2" -d "openjpeg2-tools" -d "pcre" -d "libpng" -d "proj" -d "python" -d "qt" -d "sqlite" -d "swig" -d "libtiff" -d "tinyxml" \
-d "qt5-qtbase" -d "qt5-qtbase-postgresql" -d "qt-x11" -d "gsl""}
: ${PLATFORM_INSTALL_OTHER_DEP:="-d "cifs-utils" -d "otb""}

### CONFIG PATHS FOR SCRIPT
: ${DEFAULT_DIR:=$(pwd)}
: ${PLATFORM_NAME_DIR:="Sen2AgriProcessors"}
: ${INSTALL_DIR:="install"}
: ${RPM_DIR:="rpm_binaries"}
: ${BUILD_DIR:="build"}
: ${PROC_VERSION:="0.8"}
: ${DOWNL_DEM_VERSION:="1.0"}
: ${WORKING_DIR_INSTALL:=${PLATFORM_NAME_DIR}/${INSTALL_DIR}}
: ${WORKING_DIR_RPM:=${PLATFORM_NAME_DIR}/${RPM_DIR}}
: ${WORKING_DIR_BUILD:=${PLATFORM_NAME_DIR}/${BUILD_DIR}}
: ${SOURCES_DIR_PATH:=""}
: ${PROC_INSTALL_PATH:="${DEFAULT_DIR}/${WORKING_DIR_INSTALL}/processors-install"}
: ${DOWNL_DEM_INSTALL_PATH:="${DEFAULT_DIR}/${WORKING_DIR_INSTALL}/downloaders-dem-install"}
################################################################################################
#-----------------------------------------------------------#
function get_SEN2AGRI_sources()
{
   ## build script will reside to sen2agri/packaging
   #get script path
   script_path=$(dirname $0)

   ##go in the folder sen2agri/packaging and exit up one folder into the source root dir sen2agri  
   cd $script_path
   cd ..

   #save the sources path
   SOURCES_DIR_PATH=$(pwd)
}
#-----------------------------------------------------------#
function compile_SEN2AGRI_processors()
{
   mkdir ${DEFAULT_DIR}/${WORKING_DIR_BUILD}/sen2agri-processors-build
   cd ${DEFAULT_DIR}/${WORKING_DIR_BUILD}/sen2agri-processors-build

   ##configure
   cmake ${SOURCES_DIR_PATH}/sen2agri-processors -DCMAKE_INSTALL_PREFIX=${PROC_INSTALL_PATH} -DCMAKE_BUILD_TYPE=RelWithDebInfo
   
   ##compile
   make

   ##install
   make install
}
#-----------------------------------------------------------#
function build_SEN2AGRI_processors_RPM_Package()
{
   ## add script for mosaication into the processors package
   cp -f ${SOURCES_DIR_PATH}/sen2agri-processors/aggregate_tiles/*.py ${PROC_INSTALL_PATH}/usr/bin
   
   ##create a temporary dir
   mkdir -p ${DEFAULT_DIR}/${WORKING_DIR_RPM}/tmp_processors

   ##build RPM package
   fpm -s dir -t rpm -n sen2agri-processors -v ${PROC_VERSION} -C ${PROC_INSTALL_PATH}/ ${PLATFORM_INSTALL_DEP} ${PLATFORM_INSTALL_OTHER_DEP} \
   --workdir ${DEFAULT_DIR}/${WORKING_DIR_RPM}/tmp_processors -p ${DEFAULT_DIR}/${WORKING_DIR_RPM}/sen2agri-processors-VERSION.centos7.ARCH.rpm usr
  
   #remove temporary dir
   rm -rf ${DEFAULT_DIR}/${WORKING_DIR_RPM}/tmp_processors
}
#-----------------------------------------------------------#
function build_SEN2AGRI_downloaders_demmacs_RPM_Package()
{
   ###########################################
   #DOWNLOADERS
   ###########################################
   
   ##create folder tree into install folder : usr/
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr
      
   ##downloaders/demmaccs scripts will be installed in folder : usr/share/sen2agri/sen2agri-downloaders or sr/share/sen2agri/sen2agri-demmaccs
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/share
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-downloaders
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-demmaccs
   
   ##downloaders/demmaccs services will be installed in folder : usr/lib/systemd/system
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/lib
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/lib/systemd
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/lib/systemd/system
   
   ##downloaders/demmaccs common *.py scripts will reside to  /usr/lib/python2.7/site-packages/
   
   ##create folder tree into install folder : usr/
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/lib/python2.7
   mkdir -p ${DOWNL_DEM_INSTALL_PATH}/usr/lib/python2.7/site-packages
   
   ###########################################
   #DOWNLOADERS
   ###########################################       
   ###put downloaders lib dir into the install folder :usr/share/sen2agri/sen2agri-downloaders
   cp -rf ${SOURCES_DIR_PATH}/sen2agri-downloaders/lib ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-downloaders

   ###put downloaders *.py files into the install folder :usr/share/sen2agri/sen2agri-downloaders
   cp -f ${SOURCES_DIR_PATH}/sen2agri-downloaders/*.py ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-downloaders
   
   ###put downloaders *.jar files into the install folder :usr/share/sen2agri/sen2agri-downloaders
   cp -f ${SOURCES_DIR_PATH}/sen2agri-downloaders/*.jar ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-downloaders
   
   ###put downloaders *.cfg files into the install folder :usr/share/sen2agri/sen2agri-downloaders
   cp -f ${SOURCES_DIR_PATH}/sen2agri-downloaders/*.cfg ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-downloaders
   
   ###put downloaders *.txt files into the install folder :usr/share/sen2agri/sen2agri-downloaders
   cp -f ${SOURCES_DIR_PATH}/sen2agri-downloaders/*.txt ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-downloaders
   
   ###put downloaders services files into the install folder :/usr/lib/systemd/system
   cp -f ${SOURCES_DIR_PATH}/sen2agri-downloaders/dist/* ${DOWNL_DEM_INSTALL_PATH}/usr/lib/systemd/system
   
   ###########################################
   #DEMMACCS
   ###########################################
   ###put demmaccs script files into the install folder  usr/share/sen2agri/sen2agri-demmaccs  
   cp -f ${SOURCES_DIR_PATH}/sen2agri-processors/DEM-WB/test/*.py  ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-demmaccs
   cp -f ${SOURCES_DIR_PATH}/sen2agri-processors/DEM-WB/test/*.cfg  ${DOWNL_DEM_INSTALL_PATH}/usr/share/sen2agri/sen2agri-demmaccs
   
   ###put demmaccs services files into the install folder :/usr/lib/systemd/system
   cp -f ${SOURCES_DIR_PATH}/sen2agri-processors/DEM-WB/test/dist/* ${DOWNL_DEM_INSTALL_PATH}/usr/lib/systemd/system
   
   ###########################################
   #DOWNLOADERS DEMMACCS COMMON
   ###########################################
   cp -f ${SOURCES_DIR_PATH}/python-libs/*.py  ${DOWNL_DEM_INSTALL_PATH}/usr/lib/python2.7/site-packages

   ###########################################
   #PACKAGE BUILD
   ###########################################
   
   ##create a temporary dir
   mkdir -p ${DEFAULT_DIR}/${WORKING_DIR_RPM}/tmp_download_demmacs

   ##build RPM package
   fpm -s dir -t rpm -n sen2agri-downloaders-demmaccs -v ${DOWNL_DEM_VERSION} -C ${DOWNL_DEM_INSTALL_PATH}/ \
   --workdir ${DEFAULT_DIR}/${WORKING_DIR_RPM}/tmp_download_demmacs -p ${DEFAULT_DIR}/${WORKING_DIR_RPM}/sen2agri-downloaders-demmaccs-VERSION.centos7.ARCH.rpm usr
  
   #remove temporary dir
   rm -rf ${DEFAULT_DIR}/${WORKING_DIR_RPM}/tmp_download_demmacs
}
#-----------------------------------------------------------#
function build_dir_tree()
{
   ##go to default dir
   cd ${DEFAULT_DIR}

   ##create platform dir
   if [ ! -d ${PLATFORM_NAME_DIR} ]; then
      mkdir -p ${PLATFORM_NAME_DIR}
   fi

   ##go into platform dir
   cd ${PLATFORM_NAME_DIR}
 
   ##create install dir
   if [ ! -d ${INSTALL_DIR} ]; then
      mkdir -p ${INSTALL_DIR}
   fi

   ##create rpm dir
   if [ ! -d ${RPM_DIR} ]; then
      mkdir -p ${RPM_DIR}
   fi
   
   ##create build dir
   if [ ! -d ${BUILD_DIR} ]; then
      mkdir -p ${BUILD_DIR}
   fi
   
   ##exit from platform dir
   cd ..
}

###########################################################
##### PREPARE ENVIRONEMENT FOR BUILDING PROCESSORS     ###
###########################################################
##create folder tree: build, install and rpm
build_dir_tree

##get sources path
get_SEN2AGRI_sources
###########################################################
#####  PROCESSORS build, install and RPM generation  ###### 
###########################################################
## SEN2AGRI processors sources compile and install
compile_SEN2AGRI_processors

##create RPM package
build_SEN2AGRI_processors_RPM_Package
###########################################################
#####  Downloaders-Demmaccs RPM generation           ###### 
###########################################################
build_SEN2AGRI_downloaders_demmacs_RPM_Package