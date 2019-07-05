from _onewire import crc8
from ubinascii import crc32
from sys import byteorder

class MPY_CRC:
    """
    Class Methods
    ------------
    `encode(data, model='CRC8')` : Calculate CRC of current input data,  then append CRC to the data

    `check(clz, data, model='CRC8')` : check CRC of data is correct

    Constructor
    -----------
    `__init__(self, data = b'', model='CRC8')`

    Methods
    ------
    `update(self, data, model='CRC8')` : Equivalent to extends new data then update CRC

    `digest() -> bytes` : Return the digest of CRC.
    """
    @staticmethod
    def _valid_inputs(data):
        if isinstance(data, str):
            raise TypeError("Unicode-objects must be encoded before hashing")
        elif not isinstance(data, (bytes, bytearray)):
            raise TypeError("object supporting the buffer API required")
        return bytearray(data)
    
    @classmethod
    def encode(clz, data, model='CRC8'):
        """ Calculate CRC of current input data,  then append CRC to the data

        Parameters
        ----------
        `data : bytes, bytearray`

        `model : str` : CRC Model
            - CRC8 (default) : 1-Wire CRC. See "Maxim Application Note 27".
            - CRC32
        """
        _CRC = getattr(clz, '_' + model, clz._CRC8)
        return _CRC.encode(data)
    
    @classmethod
    def check(clz, data, model='CRC8'):
        """ check CRC of data is correct

        Parameters
        ----------
        `data : bytes, bytearray`

        `model : str` : CRC Model
            - CRC8 (default) : 1-Wire CRC. See "Maxim Application Note 27".
            - CRC32
        """
        _CRC = getattr(clz, '_' + model, clz._CRC8)
        return _CRC.check(data)
        
    class _CRC32:
        @staticmethod
        def update(data):
            __data = MPY_CRC._valid_inputs(data)
            return 0x01
    
    class _CRC8:
        """
        Maxim 1-Wire CRC8 (Dow-CRC)

        polynomial: X^8 + X^5 + X^4 + 1
        """
        @staticmethod
        def update(data, pre_crc):
            __data = MPY_CRC._valid_inputs(data)
            _crc = pre_crc
            for byte in data:
                _crc = crc8(bytearray([_crc^byte]))
            return _crc
        
        @staticmethod
        def check(data):
            __data = MPY_CRC._valid_inputs(data)
            __crc = crc8(__data)
            return __crc is 0
            
        @classmethod
        def encode(clz, data):
            __crc = clz.update(data, 0x00)
            __data = bytearray(data)
            __data.extend(__crc.to_bytes(1, byteorder))
            return bytes(__data)
        
    
    def __init__(self, data = b'', model='CRC8'):
        """ Create MPY_CRC instance

        Parameters
        ----------
        `data : bytes, bytearray` : Initial data (optional)

        `model : str` : CRC Model
            - CRC8 (default) : 1-Wire CRC. See "Maxim Application Note 27".
            - CRC32
        """
        self._crc = 0x00
        self.update(data, model)
    
    def update(self, data, model='CRC8'):
        """ Equivalent to extends new data then update CRC

        Parameters
        ----------
        `data : bytes, bytearray`: New data

        `model : str` : CRC Model
            - CRC8 (default) : 1-Wire CRC. See "Maxim Application Note 27".
            - CRC32
        """
        _CRC = getattr(self, '_' + model, self._CRC8)
        self._crc = _CRC.update(data, self._crc)
    
    def digest(self):
        """ Return the digest of CRC.

        return : `bytes`
        """
        return bytes([self._crc])

__all__ = ['MPY_CRC']