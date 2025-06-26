# ASIO4ALL Python Bindings

Python bindings for the ASIO4ALL audio driver interface, providing low-latency audio access on Windows systems.

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Python Version](https://img.shields.io/badge/python-3.8%2B-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)

## Description

This library provides Python bindings for ASIO4ALL, allowing Python applications to interact with ASIO4ALL audio drivers for professional audio applications requiring low-latency audio processing.

## Features

- Interface with ASIO4ALL audio drivers
- Low-latency audio processing capabilities
- Device enumeration and configuration
- Audio streaming support
- Windows-specific implementation
- Type hints for better IDE support

## Requirements

- Windows operating system
- Python 3.8 or higher
- ASIO4ALL drivers installed on the system
- Microsoft Visual C++ compiler (for building from source)

## Installation

### From PyPI (when published)

```bash
pip install asio4all-python
```

### From Source

1. Clone the repository:
```bash
git clone https://github.com/yonatand/asio4all-python.git
cd asio4all-python
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Build and install:
```bash
pip install .
```

Or for development:
```bash
pip install -e .
```

## Usage

### Basic Example

```python
import asio4all

# Create an interface instance
interface = asio4all.PyA4AInterface()

# Get the ASIO4ALL version
version = interface.get_version()
print(f"ASIO4ALL Version: {hex(version)}")

# Enumerate devices (requires ASIO driver to be idle)
interface.enumerate()

# Get device properties
try:
    # Get device name (example for device 0)
    device_name = interface.get_device_property_string(
        asio4all.A4ADeviceProperty.kA4A_Device_lpszName, 0
    )
    print(f"Device 0 name: {device_name}")
    
    # Get device flags
    device_flags = interface.get_device_property_dword(
        asio4all.A4ADeviceProperty.kA4A_Device_dwFlags, 0
    )
    print(f"Device 0 flags: {hex(device_flags)}")
    
except asio4all.A4AException as e:
    print(f"Error: {e}")
```

### Error Handling

```python
import asio4all

try:
    interface = asio4all.PyA4AInterface()
    # ... operations ...
except asio4all.A4AException as e:
    if e.is_error(asio4all.A4AError.A4A_PRIVATE_ERR_NO_SUCH_OBJECT):
        print("Device not found")
    else:
        print(f"ASIO4ALL Error: {e}")
except asio4all.A4AWrapperException as e:
    print(f"Wrapper Error: {e}")
```

## API Reference

### Classes

#### `PyA4AInterface`

Main interface class for interacting with ASIO4ALL.

**Methods:**
- `get_version() -> int`: Get ASIO4ALL version
- `enumerate() -> None`: Re-enumerate audio devices
- `get_device_property_string(property, device_index) -> str`: Get string device property
- `get_device_property_dword(property, device_index) -> int`: Get DWORD device property
- `set_device_property_dword(property, device_index, value) -> None`: Set DWORD device property
- `get_interface_property_string(property, device_index, interface_index) -> str`: Get string interface property
- `get_interface_property_dword(property, device_index, interface_index) -> int`: Get DWORD interface property
- `set_interface_property_dword(property, device_index, interface_index, value) -> None`: Set DWORD interface property
- `get_pin_property_dword(property, device_index, interface_index, pin_index) -> int`: Get DWORD pin property
- `set_pin_property_dword(property, device_index, interface_index, pin_index, value) -> None`: Set DWORD pin property

#### `A4AException`

Exception raised for ASIO4ALL-specific errors.

**Properties:**
- `code`: Error code
- `enum`: Error enum name
- `message`: Error message

**Methods:**
- `is_error(enum) -> bool`: Check if error matches specific enum

#### `A4AWrapperException`

Exception raised for wrapper-specific errors.

### Enums

#### `A4AError`
- `A4A_PRIVATE_NOERROR`: No error
- `A4A_PRIVATE_ERR_ENUM_REENTRY`: Enumeration reentry error
- `A4A_PRIVATE_ERR_DRIVER_NOT_IDLE`: Driver not idle error
- `A4A_PRIVATE_ERR_NO_SUCH_OBJECT`: Object not found error
- `A4A_PRIVATE_ERR_ILLEGAL_ARGUMENT`: Illegal argument error

#### `A4ADeviceProperty`
Device property identifiers (e.g., `kA4A_Device_dwFlags`, `kA4A_Device_lpszName`)

#### `A4AInterfaceProperty`
Interface property identifiers (e.g., `kA4A_Interface_dwFlags`, `kA4A_Interface_lpszName`)

#### `A4APinProperty`
Pin property identifiers (e.g., `kA4A_Pin_dwFlags`, `kA4A_Pin_dwDataFlow`)

## Building from Source

### Prerequisites

- Python 3.8+
- Microsoft Visual Studio 2019 or later
- Cython 3.0+

### Build Steps

1. Install build dependencies:
```bash
pip install cython setuptools wheel
```

2. Build the extension:
```bash
python setup.py build_ext --inplace
```

3. Create distribution packages:
```bash
python build_package.py
```

## Testing

Run the test script to verify installation:

```bash
python test_asio4all.py
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Support

- Create an issue on GitHub for bug reports
- Check the ASIO4ALL documentation for driver-specific questions

## Changelog

### v0.0.1
- Initial release
- Basic ASIO4ALL interface bindings
- Device, interface, and pin property access
- Error handling and exceptions
- Type hints and documentation

### Classes

- `PyA4AInterface`: Main interface class for ASIO4ALL operations
- `A4AException`: Base exception class for ASIO4ALL errors
- `A4AWrapperException`: Wrapper-specific exception class

### Enums

- `A4AError`: Error codes
- `A4ADeviceProperty`: Device property identifiers
- `A4AInterfaceProperty`: Interface property identifiers
- `A4APinProperty`: Pin property identifiers

## Building from Source

This package uses Cython to build C++ extensions. Make sure you have:

1. Microsoft Visual C++ Build Tools installed
2. Cython installed (`pip install cython`)

Then run:

```bash
python setup.py build_ext --inplace
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions, please use the GitHub issue tracker.
