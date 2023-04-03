name=anjn-neovim

container_exist=0
for n in $(docker ps -a --filter "name=$name" --format "{{.Names}}") ; do
    if [[ $n == $name ]] ; then
        container_exist=1
    fi
done

if [[ $container_exist -eq 0 ]] || [[ "$( docker container inspect -f '{{.State.Running}}' $name )" == "false" ]]; then
    for ver in 2023.1 2022.2 2022.1 ; do
        if [ -e /tools/Xilinx/Vitis/$ver/settings64.sh ] ; then
            source /tools/Xilinx/Vitis/$ver/settings64.sh
            break
        fi
    done
    
    if [ -e /opt/xilinx/xrt/setup.sh ] ; then
        source /opt/xilinx/xrt/setup.sh
    fi
    
    pushd $(dirname $(readlink -f $0))
    docker-compose down
    docker-compose up -d --wait
    popd
fi

docker exec \
    -it \
    $name \
    /bin/bash /launch-nvim.sh "$PWD" "$@"

