LATEST_VERSION=$(curl -s https://api.github.com/repos/Lilypad-Tech/lilypad/releases/latest | grep -Po '"tag_name": "v\K.*?(?=")')
curl -L "https://github.com/Lilypad-Tech/lilypad/releases/download/v$LATEST_VERSION/lilypad-linux-amd64-cpu" -o lilypad-package/usr/local/bin/lilypad
sed -i "s/^Version: .*/Version: $LATEST_VERSION/" lilypad-package/DEBIAN/control

# Update version in Release file
sed -i "s/^Version: .*/Version: $LATEST_VERSION/" dists/focal/Release


# Calculate hashes and sizes
PACKAGES_MD5=$(md5sum dists/focal/main/binary-amd64/Packages | cut -d' ' -f1)
PACKAGES_GZ_MD5=$(md5sum dists/focal/main/binary-amd64/Packages.gz | cut -d' ' -f1)
PACKAGES_SIZE=$(wc -c < dists/focal/main/binary-amd64/Packages)
PACKAGES_GZ_SIZE=$(wc -c < dists/focal/main/binary-amd64/Packages.gz)

# Update Release file with hashes
sed -i "/^Date:/a\\
MD5Sum:\\
 $PACKAGES_MD5 $PACKAGES_SIZE main/binary-amd64/Packages\\
 $PACKAGES_GZ_MD5 $PACKAGES_GZ_SIZE main/binary-amd64/Packages.gz" dists/focal/Release

# Add SHA1 and SHA256 similarly
SHA1_PACKAGES=$(sha1sum dists/focal/main/binary-amd64/Packages | cut -d' ' -f1)
SHA1_PACKAGES_GZ=$(sha1sum dists/focal/main/binary-amd64/Packages.gz | cut -d' ' -f1)
SHA256_PACKAGES=$(sha256sum dists/focal/main/binary-amd64/Packages | cut -d' ' -f1)
SHA256_PACKAGES_GZ=$(sha256sum dists/focal/main/binary-amd64/Packages.gz | cut -d' ' -f1)

sed -i "/MD5Sum/a\\
SHA1:\\
 $SHA1_PACKAGES $PACKAGES_SIZE main/binary-amd64/Packages\\
 $SHA1_PACKAGES_GZ $PACKAGES_GZ_SIZE main/binary-amd64/Packages.gz\\
SHA256:\\
 $SHA256_PACKAGES $PACKAGES_SIZE main/binary-amd64/Packages\\
 $SHA256_PACKAGES_GZ $PACKAGES_GZ_SIZE main/binary-amd64/Packages.gz" dists/focal/Release


chmod +x lilypad-package/usr/local/bin/lilypad
dpkg-deb --build --root-owner-group -Zxz lilypad-package
rm dists/focal/main/binary-amd64/Packages
rm dists/focal/main/binary-amd64/Packages.gz
dpkg-scanpackages . /dev/null > dists/focal/main/binary-amd64/Packages
gzip -k dists/focal/main/binary-amd64/Packages

git add .
git commit -m "Update Lilypad to version $LATEST_VERSION"
git push origin main