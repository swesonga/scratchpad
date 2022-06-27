#!/bin/bash

############################################
# Author: Saint Wesonga
#         swesonga.dev at gmail dot com
#
# A script for creating a local Elmer build
# from the Elmer source code on GitHub.
# To run this script, install MSYS2 from
# https://www.msys2.org/ then launch the
# "MSYS2 MinGW x64" shortcut.
#
############################################

function usage
{
    echo -e "\nUsage: $0 ElmerFEMRepoParent (setup | FortranCompilerPath QwtIncludePath)\n"
    echo -e "ElmerFEMRepoParent:  path to the directory containing the ElmerFEM git repo"
    echo -e "setup:               install required packages and clone the ElmerFEM repo"
    echo -e "FortranCompilerPath: full path to the fortran compiler executable"
    echo -e "QwtIncludePath:      path to the directory containing the QWT include files\n"
    echo "Example: $0 /c/dev/repos/fem setup; $0 /c/dev/repos/fem /mingw64/bin/gfortran.exe c:/dev/msys64/mingw64/include/qwt-qt5/"
}

function install_packages
{
# Options from pacman -Sh
#
#  --needed         do not reinstall up to date packages
#  --noconfirm      do not ask for any confirmation
#
    pacman -Syu --noconfirm
    pacman -Syu --noconfirm
    pacman -S --noconfirm --needed base-devel mingw-w64-x86_64-toolchain
    pacman -S --noconfirm --needed mingw64/mingw-w64-x86_64-cmake
    pacman -S --noconfirm --needed mingw64/mingw-w64-x86_64-openblas
    pacman -S --noconfirm --needed mingw64/mingw-w64-x86_64-qt5
    pacman -S --noconfirm --needed mingw64/mingw-w64-x86_64-qwt-qt5
    pacman -S --noconfirm --needed mingw64/mingw-w64-x86_64-nsis
    pacman -S --noconfirm --needed git
}

if [ $# -lt 2 ]
then
    usage
    exit 1
fi

fem_dir=$1
install_dir="$fem_dir/install/"

echo "Creating root directory $fem_dir"
mkdir -p $fem_dir

cd $fem_dir

shopt -s nocasematch
case $2 in
    setup)
        echo "Installing required MSYS packages"
        install_packages

        echo "Cloning ElmerFEM repo"
        git clone https://github.com/ElmerCSC/elmerfem

        echo "Setup complete. To build elmer, run:"
        echo "$0 $fem_dir /mingw64/bin/gfortran.exe `cygpath -m /`mingw64/include/qwt-qt5/"
        exit 0
        ;;
    *)
        FortranCompilerPath=$2
        QwtIncludePath=$3
        ;;
esac

declare -a dependencies=(
"libgfortran-5.dll"
"libgcc_s_seh-1.dll"
"libopenblas.dll"
"libquadmath-0.dll"
"libwinpthread-1.dll"
"libstdc++-6.dll"
"qwt-qt5.dll"
"libdouble-conversion.dll"
"libicuin69.dll"
"libicuuc69.dll"
"libpcre2-16-0.dll"
"libharfbuzz-0.dll"
"libmd4c.dll"
"libpng16-16.dll"
"zlib1.dll"
"libzstd.dll"
"libicudt69.dll"
"libfreetype-6.dll"
"libglib-2.0-0.dll"
"libgraphite2.dll"
"libintl-8.dll"
"libbz2-1.dll"
"libbrotlidec.dll"
"libpcre-1.dll"
"libiconv-2.dll"
"libbrotlicommon.dll"
)

dependencies_dir="${install_dir}bin/"
echo "Creating $dependencies_dir"
mkdir -p $dependencies_dir

echo "Copying dependencies to $dependencies_dir"

# https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
for dependency in "${dependencies[@]}"
do
   echo "$dependency"
   cp "/mingw64/bin/$dependency" $dependencies_dir
done

platform_dependencies_dir="${dependencies_dir}platforms/"
echo "Creating platform dependencies directory $platform_dependencies_dir"
mkdir -p $platform_dependencies_dir

echo "Copying platform dependencies to $platform_dependencies_dir"
cp /mingw64/share/qt5/plugins/platforms/qwindows.dll $platform_dependencies_dir

echo "Creating directories required for building a local install"
mkdir -p bundle_msys2/bin
mkdir -p bundle_qt5/bin
mkdir -p platforms

echo "Creating build directory"
mkdir build
cd build

echo "Invoking cmake from build directory"
cmake -G "MSYS Makefiles" \
 -DWITH_ELMERGUI:BOOL=TRUE \
 -DWITH_MPI:BOOL=FALSE \
 -DCMAKE_INSTALL_PREFIX=../install \
 -DCMAKE_Fortran_COMPILER=$FortranCompilerPath \
 -DQWT_INCLUDE_DIR=$QwtIncludePath \
 -DWIN32:BOOL=TRUE \
 -DCPACK_BUNDLE_EXTRA_WINDOWS_DLLS:BOOL=TRUE \
 ../elmerfem

make install

echo -e "Build complete.\n"
echo -e "To open Elmer bin folder, run:\n"
echo "start $dependencies_dir"
