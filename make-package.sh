LATEST_VERSION=$(curl -s https://api.github.com/repos/Lilypad-Tech/lilypad/releases/latest | grep -Po '"tag_name": "v\K.*?(?=")')
curl -L "https://github.com/Lilypad-Tech/lilypad/releases/download/v$LATEST_VERSION/lilypad-linux-amd64-cpu" -o lilypad-package/usr/local/bin/lilypad
sed -i "s/^Version: .*/Version: $LATEST_VERSION/" lilypad-package/DEBIAN/control

# Update version in Release file
sed -i "s/^Version: .*/Version: $LATEST_VERSION/" dists/focal/Release

chmod +x lilypad-package/usr/local/bin/lilypad
dpkg-deb --build  --compression=gzip lilypad-package
rm dists/focal/main/binary-amd64/Packages
rm dists/focal/main/binary-amd64/Packages.gz
dpkg-scanpackages . /dev/null > dists/focal/main/binary-amd64/Packages
gzip -k dists/focal/main/binary-amd64/Packages

git add .
git commit -m "Update Lilypad to version $LATEST_VERSION"
git push origin main