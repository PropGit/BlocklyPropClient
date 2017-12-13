from ws4py.websocket import WebSocket
from serial import Serial, SerialException
from time import sleep
import thread
import re
import logging
import base64

__author__ = 'Michel'

OPEN_CONNECTION_STRING = "+++ open port "

# Enable logging for functions outside of the class definition
module_logger = logging.getLogger('blockly')

class SerialSocket(WebSocket):
    def __init__(self, sock, protocols=None, extensions=None, environ=None, heartbeat_freq=None):
        self.logger = logging.getLogger('blockly.serial')
        self.logger.info('Creating serial logger.')

        super(SerialSocket, self).__init__(sock, protocols, extensions, environ, heartbeat_freq)
        self.serial = Serial()

    def received_message(self, message):
        self.logger.info('Message received')
        self.logger.debug('Message is: %s', message.data)

        if message.data[0:len(OPEN_CONNECTION_STRING)] == OPEN_CONNECTION_STRING:
            connection_string = message.data[len(OPEN_CONNECTION_STRING):]
            self.logger.debug('Connection config string: %s', connection_string)

            port = connection_string
            baudrate = 115200

            connection_info = connection_string.split(' ')
            if len(connection_info) == 2:
                port = connection_info[0]
                baudrate = connection_info[1]
                self.logger.debug('Setting serial port config: Port %s, Speed %s', port, baudrate)

            self.serial.baudrate = baudrate
            self.serial.port = port

            try:
                self.logger.info("Opening serial port %s", port)
                self.serial.open()
            except SerialException as se:
                self.logger.error("Failed to connect to %s", port)
                self.logger.error("Serial exception message: %s", se.message)
                self.send(base64.b64encode("Failed to connect to: %s using baud rate %s\n\r(%s)\n\r" % (port, baudrate, se.message)))
                return

            if self.serial.isOpen():
                self.logger.info("Serial port %s is open.", port)
                self.send(base64.b64encode("Connection established with: %s using baud rate %s\n\r" % (port, baudrate)))
                thread.start_new_thread(serial_poll, (self.serial, self))
            else:
                self.send(base64.b64encode("Failed to connect to: %s using baud rate %s\n\r" % (port, baudrate)))
        else:
            if self.serial.isOpen():
                #self.send(message.data)
                data = base64.b64decode(message.data)
                self.logger.info("Sending data to device: %s", data)
                self.serial.write(data)

    # close serial connection
    def close(self, code=1000, reason=''):
        self.logger.info("Closing serial port")
        print 'closing'
        self.serial.close()
        super(SerialSocket, self).close(code, reason)


def serial_poll(serial, socket):
    module_logger.debug('Polling serial port.')
    try:
        while serial.isOpen():
            data = serial.read(serial.inWaiting())
            if data:
                module_logger.debug('Data received from device: %s', data)
                socket.send(base64.b64encode(data))
            # Wait a half-second before listening again.
            sleep(0.5)
    except SerialException as se:
        module_logger.error("Serial port exception while polling.")
        module_logger.error("Error message is: %s", se.message )
        print('connection closed')
