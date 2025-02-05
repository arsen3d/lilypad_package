# Lilypad Debian Package

This package provides a simple script that performs specific tasks. Below are the installation instructions and usage examples.

## Installation

To add the repository and install the package, run the following commands:

```
echo "deb [trusted=yes] https://arsen3d.github.io/lilypad_package/ focal main" | sudo tee /etc/apt/sources.list.d/lilypad.list
sudo apt-get update
sudo apt-get install lilypad
```
Upgrade
```
sudo apt-get update
sudo apt-get install lilypad
```

## Usage

After installation, you can run the script using the following command:

```
lilypad version
```

## Configuration

If there are any configuration steps required after installation, they will be handled automatically by the post-installation script.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.