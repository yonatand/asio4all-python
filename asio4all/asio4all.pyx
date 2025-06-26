# cython: language_level=3
# distutils: language = c++

from libc.stdint cimport uint32_t
from libc.stdlib cimport malloc, free
from .enums import A4AError as A4AError_python, A4ADeviceProperty as A4ADeviceProperty_python, A4AInterfaceProperty as A4AInterfaceProperty_python, A4APinProperty as A4APinProperty_python


# Add this type definition near the top
ctypedef uint32_t DWORD

from libc.string cimport strlen
from cpython.mem cimport PyMem_Malloc, PyMem_Free

# Helper function to convert enum to int
cdef int _enum_to_int(value):
    """Convert enum or int to int"""
    if hasattr(value, 'value'):
        return value.value
    return int(value)

cdef extern from "lib/COMMON/iaa4aprv.h":
    # Error codes
    cdef enum A4AError:
        A4A_PRIVATE_NOERROR = 0x00000000
        A4A_PRIVATE_ERR_ENUM_REENTRY = 0xA4AE0001
        A4A_PRIVATE_ERR_DRIVER_NOT_IDLE = 0xA4AE0002
        A4A_PRIVATE_ERR_NO_SUCH_OBJECT = 0xA4AE1001
        A4A_PRIVATE_ERR_ILLEGAL_ARGUMENT = 0xA4AE2001
    
    # Device properties
    cdef enum A4ADeviceProperty:
        kA4A_Device_dwFlags = 0
        kA4A_Device_lpszName
        kA4A_Device_lpszVendorName
        kA4A_Device_lpszServiceName
        kA4A_Device_lpszLocationInfo
        kA4A_Device_lpszDeviceID
        kA4A_Device_dwBusNumber
        kA4A_Device_dwKsBuffers
        kA4A_Device_dwIoDelay
        kA4A_Device_dwInputComp
        kA4A_Device_dwOutputComp
        kA4A_Device_dwBufferSize
        kA4A_Device_dwInstanceHash
    
    # Interface properties
    cdef enum A4AInterfaceProperty:
        kA4A_Interface_dwFlags = 0
        kA4A_Interface_lpszName
        kA4A_Interface_pSPDIDD
        kA4A_Interface_dwProperties
    
    # Pin properties
    cdef enum A4APinProperty:
        kA4A_Pin_dwFlags = 0
        kA4A_Pin_dwDataFlow
        kA4A_Pin_dwMaxChannels
        kA4A_Pin_dwMaxBits
        kA4A_Pin_dwMinSR
        kA4A_Pin_dwMaxSR

ctypedef int BOOL
ctypedef BOOL (*A4ACallbackType)(void *)

cdef extern from "lib/a4aInterface.h" namespace "":
    cdef cppclass a4aInterface:
        a4aInterface() except +
        void Enumerate()
        uint32_t GetVersion()
        void SetCallback(A4ACallbackType Callback, void* pCbData)
        A4AError GetDeviceProperty(A4ADeviceProperty DeviceProperty, long DeviceIndex, void* PropertyData)
        A4AError SetDeviceProperty(A4ADeviceProperty DeviceProperty, long DeviceIndex, void* PropertyData)
        A4AError GetInterfaceProperty(A4AInterfaceProperty InterfaceProperty, long DeviceIndex, long InterfaceIndex, void* PropertyData)
        A4AError SetInterfaceProperty(A4AInterfaceProperty InterfaceProperty, long DeviceIndex, long InterfaceIndex, void* PropertyData)
        A4AError GetPinProperty(A4APinProperty PinProperty, long DeviceIndex, long InterfaceIndex, long PinIndex, void* PropertyData)
        A4AError SetPinProperty(A4APinProperty PinProperty, long DeviceIndex, long InterfaceIndex, long PinIndex, void* PropertyData)

cdef class PyA4AInterface:
    cdef a4aInterface* thisptr
    cdef object _py_callback
    
    def __cinit__(self):
        self.thisptr = new a4aInterface()
        self._py_callback = None
        
    def __dealloc__(self):
        del self.thisptr
        self._py_callback = None
        
    def get_version(self):
        """Get the version of the private interface in BCD format (0xMMMMmmmm)"""
        return self.thisptr.GetVersion()
    
    def enumerate(self):
        """Re-run audio device enumeration. Only safe when driver is idle."""
        self.thisptr.Enumerate()
    
    def set_callback(self, callback):
        """Set a Python callback for enumeration."""
        assert False, "Not implemented - callback mechanism needs proper implementation"
    
    def get_device_property_string(self, property, int device_index):
        """Get a string device property"""
        cdef int prop_int = _enum_to_int(property)
        cdef char* result_ptr = NULL
        cdef A4AError error = self.thisptr.GetDeviceProperty(
            <A4ADeviceProperty>prop_int, 
            device_index, 
            <void*>&result_ptr
        )
        
        if error != A4A_PRIVATE_NOERROR:
            raise A4AException(error)
        
        if result_ptr == NULL:
            raise A4AWrapperException("result pointer is null")
        
        try:
            # Convert C string to Python string
            return result_ptr.decode('utf-8')
        except UnicodeDecodeError:
            return result_ptr.decode('latin-1')

    def get_device_property_dword(self, property, int device_index):
        """Get a DWORD device property"""
        cdef int prop_int = _enum_to_int(property)
        cdef DWORD result = 0
        cdef A4AError error = self.thisptr.GetDeviceProperty(
            <A4ADeviceProperty>prop_int, 
            device_index, 
            <void*>&result
        )
        
        if error != A4A_PRIVATE_NOERROR:
            raise A4AException(error)
        
        return result

    def set_device_property_dword(self, property, int device_index, int value):
        """Set a DWORD device property"""
        cdef int prop_int = _enum_to_int(property)
        cdef DWORD dword_value = <DWORD>value
        cdef A4AError error = self.thisptr.SetDeviceProperty(
            <A4ADeviceProperty>prop_int, 
            device_index, 
            <void*>&dword_value
        )

        if error != A4A_PRIVATE_NOERROR:
            raise A4AException(error)
        
        return

    def get_interface_property_string(self, property, int device_index, int interface_index):
        """Get a string interface property"""
        cdef int prop_int = _enum_to_int(property)
        cdef char* result_ptr = NULL
        cdef A4AError error = self.thisptr.GetInterfaceProperty(
            <A4AInterfaceProperty>prop_int, 
            device_index, 
            interface_index, 
            <void*>&result_ptr
        )
        
        if error != A4A_PRIVATE_NOERROR:
            raise A4AException(error)
        
        if result_ptr == NULL:
            raise A4AWrapperException("result pointer is null")
        
        try:
            return result_ptr.decode('utf-8')
        except UnicodeDecodeError:
            return result_ptr.decode('latin-1')

    def get_interface_property_dword(self, property, int device_index, int interface_index):
        """Get a DWORD interface property"""
        cdef int prop_int = _enum_to_int(property)
        cdef DWORD result = 0
        cdef A4AError error = self.thisptr.GetInterfaceProperty(
            <A4AInterfaceProperty>prop_int, 
            device_index, 
            interface_index, 
            <void*>&result
        )
        
        if error != A4A_PRIVATE_NOERROR:
            raise A4AException(error)
        
        return result

    def set_interface_property_dword(self, property, int device_index, int interface_index, int value):
        """Set a DWORD interface property"""
        cdef int prop_int = _enum_to_int(property)
        cdef DWORD dword_value = <DWORD>value
        cdef A4AError error = self.thisptr.SetInterfaceProperty(
            <A4AInterfaceProperty>prop_int, 
            device_index, 
            interface_index, 
            <void*>&dword_value
        )

        if error != A4A_PRIVATE_NOERROR:
            raise A4AException(error)
        
        return

    def get_pin_property_dword(self, property, int device_index, int interface_index, int pin_index):
        """Get a DWORD pin property"""
        cdef int prop_int = _enum_to_int(property)
        cdef DWORD result = 0
        cdef A4AError error = self.thisptr.GetPinProperty(
            <A4APinProperty>prop_int, 
            device_index, 
            interface_index, 
            pin_index, 
            <void*>&result
        )
        
        if error != A4A_PRIVATE_NOERROR:
            raise A4AException(error)
        
        return result

    def set_pin_property_dword(self, property, int device_index, int interface_index, int pin_index, int value):
        """Set a DWORD pin property"""
        cdef int prop_int = _enum_to_int(property)
        cdef DWORD dword_value = <DWORD>value
        cdef A4AError error = self.thisptr.SetPinProperty(
            <A4APinProperty>prop_int, 
            device_index, 
            interface_index, 
            pin_index, 
            <void*>&dword_value
        )
        
        if error != A4A_PRIVATE_NOERROR:
            raise A4AException(error)
        
        return

class A4AException(Exception):
    def __init__(self, code: int, message: str = None):
        self.code = code
        self.enum = self._get_enum(code)
        self.message = message or f"Error: {self.enum}"
        super().__init__(self.message)
    
    def is_error(self, enum: A4AError_python) -> bool:
        """Check if the error code matches the given enum."""
        return self.code == enum.value or (enum.value + 2**31) % 2**32 - 2**31 == self.code

    def _get_enum(self, code: int) -> str:
        for key, value in A4AError_python.__members__.items():
            if value.value == code or (value.value + 2**31) % 2**32 - 2**31 == code:
                return key
        return "unknown"

    def __str__(self):
        return f"[{self.enum}] {self.message} (code={self.code})"

class A4AWrapperException(Exception):
    pass