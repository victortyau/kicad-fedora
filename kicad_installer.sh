echo "running script to install kicad on fedora"

starttime=$(date +%s)

arr_libraries=(cmake glew-devel glm-devel libcurl-devel cairo-devel tcsh openmpi openmpi-devel qt-devel qtwebkit-devel tcl-devel tk-devel tcllib tklib libXmu-devel autoconf automake bison flex gcc git libtool make swig
python2-devel boost boost-devel openssl-devel wxBase3-devel wxGTK3-devel) 

arr_install_libraries=()

echo ${#arr_libraries[@]}
echo ${#arr_install_libraries[@]}

i=0

while [ $i -lt ${#arr_libraries[@]} ]
    do
        number=$(rpm -qa ${arr_libraries[$i]} | wc -c )
        if [ $number -gt 0 ];
        then
            echo -e "[\xE2\x9C\x94] ${arr_libraries[$i]} existing"
        else
            echo -e "[\xE2\x9D\x8C] ${arr_libraries[$i]} missing"
            arr_install_libraries+=(${arr_libraries[$i]})       
       fi
        i=$((i+1))
    done

echo ${#arr_libraries[@]}
echo ${#arr_install_libraries[@]}

libs=$(IFS=$' '; echo "${arr_install_libraries[*]}")

if [ ${#arr_install_libraries[@]} -gt 0 ];
  then
    sudo dnf install $libs
fi

sudo dnf groupinstall "Development Tools"

cd ..

git clone "git://github.com/tpaviot/oce.git"

cd "oce"

mkdir "build"

cd "build"

flags=""

flags="$flags -DOCE_INSTALL_PREFIX:PATH=$HOME/oce"

flags="$flags -DFTGL_INCLUDE_DIR:PATH=/usr/include/FTGL"

flags="$flags -DOCE_DRAW:BOOL=ON"

flags="$flags -DOCE_TESTING:BOOL=ON"

cmake $flags ..

make -j6

make install 

cd ../..

git clone "https://gitlab.com/kicad/code/kicad.git"

cd kicad

git pull

cd "scripting/build_tools"

chmod +x get_libngspice_so.sh

./get_libngspice_so.sh

sudo ./get_libngspice_so.sh install

cd ../..

mkdir -p "build/release"

cd "build/release"

cmake -DCMAKE_BUILD_TYPE=Release \
      -DKICAD_SCRIPTING=OFF \
      -DKICAD_SCRIPTING_MODULES=ON \
      -DKICAD_SCRIPTING_WXPYTHON=OFF \
      ../../


make -j6

endtime=$(date +%s)

secs=$(($endtime - $starttime))

printf 'Elapsed Time %dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
