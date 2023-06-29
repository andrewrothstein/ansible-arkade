#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/alexellis/arkade/releases/download

# https://github.com/alexellis/arkade/releases/download/0.8.28/arkade

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local platform="${os}-${arch}"
    local suffix=""
    if [ "${os}" = "linux" ];
    then
        if [ "${arch}" != "amd64" ];
        then
            suffix="-${arch}"
        fi
    elif [ "${os}" = "darwin" ];
    then
        suffix="-${os}"
        if [ "${arch}" != "amd64" ];
        then
            suffix="${suffix}-${arch}"
        fi
    else
        suffix=".exe"
    fi
    local exe=arkade${suffix}
    local url=$MIRROR/${ver}/${exe}.sha256
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(curl -sSL $url | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    printf "  '%s':\n" $ver
    dl $ver darwin amd64
    dl $ver darwin arm64
    dl $ver linux amd64
    dl $ver linux arm64
    dl $ver linux armhf
    dl $ver windows amd64
}

dl_ver ${1:-0.9.23}
