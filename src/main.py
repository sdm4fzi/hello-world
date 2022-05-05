import os
import signal
import sys
import time

from pymodbus.client.sync import ModbusSerialClient as ModbusClient


def connect(modbus_port="/dev/ttyAMA2", modbus_baudrate=19200):
    client = ModbusClient(method="rtu", port=modbus_port, stopbits=1, bytesize=8, parity='E', baudrate=modbus_baudrate)
    client.connect()
    return client


def close(client):
    client.close()


def stop(client):
    client.write_coil(0x00, 0, unit=0x01)
    client.write_coil(0x01, 0, unit=0x01)


def shutdown(client):
    stop(client)
    close(client)
    sys.exit(0)


def sigterm_handler(_signo, _stack_frame):
    shutdown(client)


signal.signal(signal.SIGTERM, sigterm_handler)

modbus_port = os.environ.get("MODBUS_PORT", "/dev/ttyAMA2")
modbus_baudrate = int(os.environ.get("MODBUS_BAUDRATE", 19200))

client = connect(modbus_port, modbus_baudrate)

stop(client)

# reset (move left)
result1 = client.read_discrete_inputs(0x00, count=1, unit=0x02)
result2 = client.read_discrete_inputs(0x01, count=1, unit=0x02)
if result1.bits[0] or result2.bits[0]:
    client.write_coil(0x01, 1, unit=0x01)

try:
    while True:
        result = client.read_discrete_inputs(0x00, count=1, unit=0x01)
        if result.bits[0]:
            result = client.read_discrete_inputs(0x00, count=1, unit=0x02)  # left
            if not result.bits[0]:
                client.write_coil(0x00, 0, unit=0x01)
                client.write_coil(0x01, 0, unit=0x01)

                time.sleep(5)
                client.write_coil(0x00, 0, unit=0x01)  # right
                client.write_coil(0x01, 1, unit=0x01)  # left
                time.sleep(1)

            result = client.read_discrete_inputs(0x01, count=1, unit=0x02)  # right
            if not result.bits[0]:

                client.write_coil(0x00, 0, unit=0x01)
                client.write_coil(0x01, 0, unit=0x01)

                time.sleep(5)
                client.write_coil(0x00, 1, unit=0x01)  # right
                client.write_coil(0x01, 0, unit=0x01)  # left
                time.sleep(1)
        else:
            stop(client)

except KeyboardInterrupt:
    shutdown(client)

finally:
    shutdown(client)
