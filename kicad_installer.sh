echo "running script to install kicad on fedora"

arr_libraries=(cmake glew-devel glm-devel libcurl-devel cairo-devel tcsh openmpi openmpi-devel qt-devel qt-webkit-devel tcl-devel tk-devel tcllib tklib libXmu-devel autoconf automake bison flex gcc git libtool make swig
python-devel boost boost-devel wxPython wxPython-devel openssl-dev)

i=0

while [ $i -lt ${#arr_libraries[@]} ]
    do
        number=$(rpm -qa ${arr_libraries[$i]} | wc -c )
        echo $number
        if [ $number -gt 0 ];
        then
            echo -e "[\xE2\x9C\x94] ${arr_libraries[$i]} existing"
            
        else
            echo -e "[\xE2\x9D\x8C] ${arr_libraries[$i]} missing"       
       fi
        i=$((i+1))
    done

exit 0

sudo dnf install "cmake glew-devel glm-devel libcurl-devel cairo-devel tcsh openmpi openmpi-devel qt-devel qt-webkit-devel tcl-devel tk-devel tcllib tklib libXmu-devel autoconf automake bison flex gcc git libtool make swig
python-devel boost boost-devel wxPython wxPython-devel openssl-dev"

sudo dnf groupinstall "Development Tools"

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

make 

make install 

git clone "https://git.launchpad.net/kicad"

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
      ../../

make

sudo make install
