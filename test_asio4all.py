#!/usr/bin/env python3
"""
Basic test script for asio4all package
"""

import asio4all

def test_basic_import():
    """Test that we can import the package"""
    print("✓ Successfully imported asio4all")
    print(f"✓ Version: {asio4all.__version__}")

def test_create_interface():
    """Test that we can create an interface instance"""
    try:
        interface = asio4all.PyA4AInterface()
        print("✓ Successfully created PyA4AInterface instance")
        
        # Test get_version - this should work even if no ASIO4ALL is installed
        try:
            version = interface.get_version()
            print(f"✓ Got version: {hex(version)}")
        except Exception as e:
            print(f"⚠ Could not get version (ASIO4ALL might not be installed): {e}")
            
    except Exception as e:
        print(f"✗ Failed to create interface: {e}")

def test_enums():
    """Test that enums are accessible"""
    try:
        error = asio4all.A4AError.A4A_PRIVATE_NOERROR
        device_prop = asio4all.A4ADeviceProperty.kA4A_Device_dwFlags
        interface_prop = asio4all.A4AInterfaceProperty.kA4A_Interface_dwFlags
        pin_prop = asio4all.A4APinProperty.kA4A_Pin_dwFlags
        print("✓ All enums accessible")
    except Exception as e:
        print(f"✗ Failed to access enums: {e}")

if __name__ == "__main__":
    print("Testing asio4all package...")
    print("-" * 40)
    
    test_basic_import()
    test_create_interface()
    test_enums()
    
    print("-" * 40)
    print("Test completed!")
