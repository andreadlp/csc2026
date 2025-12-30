#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "CSC Latin America 2026 - Environment Setup"
echo "=========================================="

# Source ROOT environment (path used by many ROOT images)
if [ -f /opt/root/bin/thisroot.sh ]; then
  # shellcheck disable=SC1091
  source /opt/root/bin/thisroot.sh
elif [ -f /usr/local/bin/thisroot.sh ]; then
  # shellcheck disable=SC1091
  source /usr/local/bin/thisroot.sh
fi

echo ""
echo "Verifying tool installations..."
echo "-------------------------------"

root-config --version || true
cmake --version
ninja --version
g++ --version | head -n 1
clang --version | head -n 1
clang-tidy --version | head -n 1
python3 --version
pytest --version
mkdocs --version

echo ""
echo "Configuring + building the project..."
echo "-----------------------------------"

if [ ! -d build ]; then
  cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo
fi
cmake --build build -j"$(nproc)"

echo ""
echo "Quick test run..."
echo "---------------"
ctest --test-dir build --output-on-failure || true

echo ""
echo "Ready."
echo "Build:   cmake -S . -B build -G Ninja && cmake --build build"
echo "Tests:   ctest --test-dir build --output-on-failure"
echo "Python:  pytest -v"
echo "Docs:    mkdocs serve -a 0.0.0.0:8000"
echo "=========================================="
