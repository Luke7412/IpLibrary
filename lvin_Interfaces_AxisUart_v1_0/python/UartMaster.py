
from typing import List
import struct


class UartMaster:
    def __init__(self):
        self.start_byte = 0x00
        self.stop_byte = 0x01
        self.escape_byte = 0xFF

        self. prot = 0
        self. size = 0
        self. burst = 0
        self. cache = 0
        self. len = 0
        self. lock = 0
        self. id = 0

        self.strb = 0

    ###########################################################################
    @staticmethod
    def int2bytes(x: int) -> List[int]:
        return [x >> i & 0xFF for i in (0, 8, 16, 24)]

    @staticmethod
    def bytes2int(x: List[int]) -> int:
        return struct.unpack("<I", bytearray(x))[0]

    ###########################################################################
    def pack_address(self, address) -> List[int]:
        byte_list = self.int2bytes(address)

        val = (self.id & 0xF << 21) | (self.lock & 0x1 << 20) | \
              (self.len & 0x8 << 12) | (self.cache & 0xF << 8) | \
              (self.burst & 0x3 << 6) | (self.size & 0x7 << 3) | \
              (self.prot & 0x7 << 0)

        # val += qos & 0xF << 25
        # val += user & 0xF << 29

        return byte_list + self.int2bytes(val)

    def pack_write_data(self, data: int, last=0) -> List[int]:
        byte_list = self.int2bytes(data)
        val = (last & 0x7 << 3) | (self.strb & 0xF << 0)

        return byte_list + self.int2bytes(val)

    def unpack_write_response(self, data: List[int]):
        val = self.bytes2int(data)
        resp = (val >> 0) & 0x3
        id = (val >> 2) & 0xF
        user = (val >> 6) & 0xF
        return resp, id, user

    def unpack_read_data(self, data: List[int]):
        read_value = self.bytes2int(data[0:3])
        val = self.bytes2int(data[4:7])
        resp = (val >> 0) & 0x3
        last = (val >> 2) & 0x1
        id = (val >> 3) & 0xF
        user = (val >> 6) & 0xF

        return read_value, resp, last, id, user

    ###########################################################################
    def add_escape(self, data_bytes: List[int]) -> List[int]:
        new_byte_list = list()
        for data_byte in data_bytes:
            if data_byte in (self.start_byte, self.stop_byte, self.escape_byte):
                new_byte_list.append(self.escape_byte)
            new_byte_list.append(data_byte)

        return new_byte_list

    def remove_escape(self, data_bytes: List[int]) -> List[int]:
        new_byte_list = list()
        prev_was_escape = False
        for data_byte in data_bytes:
            if data_byte == self.escape_byte and not prev_was_escape:
                prev_was_escape = True
            else:
                new_byte_list.append(data_byte)
                prev_was_escape = False

        return new_byte_list

    def add_framing(self, data_bytes: List[int]) -> List[int]:
        return [self.start_byte] + data_bytes + [self.stop_byte]

    def remove_framing(self, byte_list: List[int]) -> List[int]:
        return byte_list[1:-1]

    def pack_message(self, data_bytes: List[int]):
        escaped_data = self.add_escape(data_bytes)
        framed_data = self.add_framing(escaped_data)
        return framed_data

    def unpack_message(self, data_bytes: List[int]):
        de_framed_data = self.remove_framing(data_bytes)
        unescaped_data = self.remove_escape(de_framed_data)
        return unescaped_data


def main():
    uart_master = UartMaster()
    print(uart_master.pack_address(0xdeadbeef))
    print(uart_master.pack_write_data(0xdeadbeef))

    val = [0x05, 0x04, 0x00, 0x04, 0x01, 0x05, 0x05, 0xff, 0x07, 0x01, 0x01]
    print(val)
    val = uart_master.pack_message(val)
    print(val)
    val = uart_master.unpack_message(val)
    print(val)


if __name__ == '__main__':
    main()
