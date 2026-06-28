#!/bin/bash
set -e
set -x
set -o pipefail

source_dir=/usr/src/Slicer
build_dir=/usr/src/Slicer-build
qt6_dir=/usr/lib/x86_64-linux-gnu/cmake/Qt6

dump_failure_context()
{
  echo "::group::Slicer Qt6 build failure context"
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

mkdir -p "$source_dir"
cp -a --no-preserve=ownership "$GITHUB_WORKSPACE"/. "$source_dir"/
git config --system --add safe.directory "$source_dir"
git -C "$source_dir" rev-parse --verify HEAD
git -C "$source_dir" show -s --format=%ci HEAD

cmake --version
cmake -S "$source_dir" -B "$build_dir" -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DADDITIONAL_C_FLAGS:STRING=-std=gnu11 \
  -DQt6_DIR:PATH="$qt6_dir"

cmake --build "$build_dir"
cmake --build "$build_dir/Slicer-build" --target package | tee "$build_dir/Slicer-build/PACKAGES.txt"

package_filepath=$(gawk 'match($0, /CPack: - package: (.*) generated/, a) {print a[1]}' "$build_dir/Slicer-build/PACKAGES.txt" | head -n1)
echo "package_filepath [${package_filepath}]"

mv "$package_filepath" "$GITHUB_WORKSPACE/"

package=$(basename "$package_filepath")
echo "package [${package}]"

echo "package=$package" >> "$GITHUB_OUTPUT"
