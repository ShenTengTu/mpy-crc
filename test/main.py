from lib.mpy_crc import MPY_CRC

### default CRC8 ###
# invalid inputs
try:
  mp_crc = MPY_CRC(123)
except TypeError as err:
  assert err.args[0] == 'object supporting the buffer API required'

try:
  mp_crc = MPY_CRC('123')
except TypeError as err:
  assert err.args[0] == 'Unicode-objects must be encoded before hashing'

# initial value & update (supports bytes & bytearray)
data = b'12345689'
mp_crc = MPY_CRC(data)
data = bytearray(data)
mp_crc = MPY_CRC(data)
# digest
crc = mp_crc.digest()
assert isinstance(crc, bytes)
assert  crc != b'\x00'
# update value ()
next_data = b'0'
mp_crc.update(next_data)
n_crc = mp_crc.digest()
assert isinstance(n_crc, bytes)
assert  n_crc != b'\x00'
assert n_crc != crc
# encode (data extend crc)
data.extend(next_data)
encoded =  MPY_CRC.encode(data)
assert isinstance(encoded, bytes)
assert encoded.endswith(n_crc)
# check
assert MPY_CRC.check(data) is False
assert MPY_CRC.check(encoded) is True