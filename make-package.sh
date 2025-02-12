LATEST_VERSION=$(curl -s https://api.github.com/repos/Lilypad-Tech/lilypad/releases/latest | grep -Po '"tag_name": "v\K.*?(?=")')
curl -L "https://github.com/Lilypad-Tech/lilypad/releases/download/v$LATEST_VERSION/lilypad-linux-amd64-cpu" -o lilypad-package/usr/local/bin/lilypad
sed -i "s/^Version: .*/Version: $LATEST_VERSION/" lilypad-package/DEBIAN/control
chmod +x lilypad-package/usr/local/bin/lilypad

# Build package and generate package files
dpkg-deb --build --root-owner-group -Zxz lilypad-package
rm -f dists/focal/main/binary-amd64/Packages*
dpkg-scanpackages . /dev/null > dists/focal/main/binary-amd64/Packages
gzip -k dists/focal/main/binary-amd64/Packages

# Calculate hashes
PACKAGES_MD5=$(md5sum dists/focal/main/binary-amd64/Packages | cut -d' ' -f1)
PACKAGES_GZ_MD5=$(md5sum dists/focal/main/binary-amd64/Packages.gz | cut -d' ' -f1)
SHA1_PACKAGES=$(sha1sum dists/focal/main/binary-amd64/Packages | cut -d' ' -f1)
SHA1_PACKAGES_GZ=$(sha1sum dists/focal/main/binary-amd64/Packages.gz | cut -d' ' -f1)
SHA256_PACKAGES=$(sha256sum dists/focal/main/binary-amd64/Packages | cut -d' ' -f1)
SHA256_PACKAGES_GZ=$(sha256sum dists/focal/main/binary-amd64/Packages.gz | cut -d' ' -f1)

# Create Release file
cat > dists/focal/Release << EOF
Origin: Lilypad
Label: Lilypad
Suite: stable
Version: $LATEST_VERSION
Codename: focal
Architectures: amd64
Components: main
Description: Lilypad CLI
Date: $(date -R)
MD5Sum:
 $PACKAGES_MD5 main/binary-amd64/Packages
 $PACKAGES_GZ_MD5 main/binary-amd64/Packages.gz
SHA1:
 $SHA1_PACKAGES main/binary-amd64/Packages
 $SHA1_PACKAGES_GZ main/binary-amd64/Packages.gz
SHA256:
 $SHA256_PACKAGES main/binary-amd64/Packages
 $SHA256_PACKAGES_GZ main/binary-amd64/Packages.gz
EOF

# Commit and push changes
git add .
git commit -m "Update Lilypad to version $LATEST_VERSION"
git push origin main