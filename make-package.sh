dpkg-deb --build lilypad-package
rm dists/focal/main/binary-amd64/Packages
rm dists/focal/main/binary-amd64/Packages.gz
dpkg-scanpackages . /dev/null > dists/focal/main/binary-amd64/Packages
gzip -k dists/focal/main/binary-amd64/Packages