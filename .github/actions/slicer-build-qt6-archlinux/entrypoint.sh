#!/bin/bash
set -e
set -x
set -o pipefail

source_dir=/usr/src/Slicer
build_dir=/usr/src/Slicer-build
qt6_dir=/usr/lib/cmake/Qt6
ccache_wrappers_dir=/usr/local/lib/ccache

dump_failure_context()
{
  echo "::group::Slicer Qt6 Arch Linux build failure context"
  find "$build_dir" -path '*-stamp/*-err.log' -o -path '*-stamp/*-out.log' | while read -r log; do
    echo "===== ${log} ====="
    tail -n 200 "$log" || true
  done

  for executable in \
    "$build_dir/python-install/bin/PythonSlicer" \
    "$build_dir/python-install/bin/python" \
    "$build_dir/python-install/bin/python-real"; do
    if [[ -e "$executable" ]]; then
      echo "===== file ${executable} ====="
      file "$executable" || true
      echo "===== ldd ${executable} ====="
      ldd "$executable" || true
    fi
  done
  echo "::endgroup::"
}

trap dump_failure_context ERR

mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

mkdir -p "$ccache_wrappers_dir" "${CCACHE_DIR:-$GITHUB_WORKSPACE/.ccache}"
ln -sf /usr/bin/ccache "$ccache_wrappers_dir/cc"
ln -sf /usr/bin/ccache "$ccache_wrappers_dir/c++"
ln -sf /usr/bin/ccache "$ccache_wrappers_dir/gcc"
ln -sf /usr/bin/ccache "$ccache_wrappers_dir/g++"
export PATH="$ccache_wrappers_dir:$PATH"
export CCACHE_DIR="${CCACHE_DIR:-$GITHUB_WORKSPACE/.ccache}"
export CCACHE_MAXSIZE="${CCACHE_MAXSIZE:-5G}"
export CCACHE_COMPRESS="${CCACHE_COMPRESS:-1}"
ccache --show-config
ccache --zero-stats || true

mkdir -p "$source_dir"
rsync -a --delete --exclude='/.ccache/' "$GITHUB_WORKSPACE"/ "$source_dir"/
git config --system --add safe.directory "$source_dir"
git -C "$source_dir" rev-parse --verify HEAD
git -C "$source_dir" show -s --format=%ci HEAD

cmake --version
pacman -Q qt6-base qt6-webengine

cmake -S "$source_dir" -B "$build_dir" -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DADDITIONAL_C_FLAGS:STRING=-std=gnu11 \
  -DBUILD_TESTING:BOOL=OFF \
  -DSlicer_BUILD_DOCUMENTATION:BOOL=OFF \
  -DQt6_DIR:PATH="$qt6_dir"

cmake --build "$build_dir"
ccache --show-stats || true
