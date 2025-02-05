dpkg-deb --build lilypad-package
dpkg-scanpackages . /dev/null > dists/focal/main/binary-amd64/Packages
gzip -k dists/focal/main/binary-amd64/Packages