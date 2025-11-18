#!/bin/bash

export DEB_BUILD_OPTIONS="parallel=$(nproc)"

if [[ $(git --no-optional-locks status -uno --porcelain) ]]; then
    echo "ERROR: git repository is not clean"
    exit 1
fi

# Create upstream tag (required by gbp)
version=$(dpkg-parsechangelog -SVersion | sed 's/-[^-]*$//')
git tag -f upstream/${version} HEAD

# Produce source package (including an orig tarball)
git clean -xdf
mkdir -p deb
gbp export-orig --submodules --tarball-dir=deb

cd deb
tar xf *.orig.tar.gz
cd "virt-manager-${version}"
dpkg-buildpackage -rfakeroot -uc -us

ls -l ../deb/*.deb
echo "Done"
