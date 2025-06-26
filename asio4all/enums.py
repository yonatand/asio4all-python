from enum import Enum

class A4ADeviceProperty(Enum):
    kA4A_Device_dwFlags = 0
    kA4A_Device_lpszName = 1
    kA4A_Device_lpszVendorName = 2
    kA4A_Device_lpszServiceName = 3
    kA4A_Device_lpszLocationInfo = 4
    kA4A_Device_lpszDeviceID = 5
    kA4A_Device_dwBusNumber = 6
    kA4A_Device_dwKsBuffers = 7
    kA4A_Device_dwIoDelay = 8
    kA4A_Device_dwInputComp = 9
    kA4A_Device_dwOutputComp = 10
    kA4A_Device_dwBufferSize = 11
    kA4A_Device_dwInstanceHash = 12
class A4AInterfaceProperty(Enum):
    kA4A_Interface_dwFlags = 0
    kA4A_Interface_lpszName = 1
    kA4A_Interface_pSPDIDD = 2
    kA4A_Interface_dwProperties = 3
class A4APinProperty(Enum):
    kA4A_Pin_dwFlags = 0
    kA4A_Pin_dwDataFlow = 1
    kA4A_Pin_dwMaxChannels = 2
    kA4A_Pin_dwMaxBits = 3
    kA4A_Pin_dwMinSR = 4
    kA4A_Pin_dwMaxSR = 5
class A4AError(Enum):
    A4A_PRIVATE_NOERROR = 0x00000000
    A4A_PRIVATE_ERR_ENUM_REENTRY = 0xA4AE0001
    A4A_PRIVATE_ERR_DRIVER_NOT_IDLE = 0xA4AE0002
    A4A_PRIVATE_ERR_NO_SUCH_OBJECT = 0xA4AE1001
    A4A_PRIVATE_ERR_ILLEGAL_ARGUMENT = 0xA4AE2001
