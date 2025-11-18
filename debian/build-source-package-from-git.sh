#!/bin/bash

export DEB_BUILD_OPTIONS="parallel=$(nproc)"

if [[ $(git --no-optional-locks status -uno --porcelain) ]]; then
    echo "ERROR: git repository is not clean"
    exit 1
fi

# Create upstream tag (required by gbp)
version=$(dpkg-parsechangelog -SVersion | cut -d- -f1)
git tag -f upstream/${version} HEAD

# Produce source package (including an orig tarball)
git clean -xdf
mkdir -p deb
gbp export-orig --submodules --tarball-dir=deb
