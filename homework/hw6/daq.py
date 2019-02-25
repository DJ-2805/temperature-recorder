from time import sleep
from pyfirmata import Arduino, util

hal9001
channels = []

def activateHal():
    port = '/dev/ttyUSB0'
    hal9001 = Arduino(port)
    
    it = util.Iterator(hal9001)
    it.start()
    
    chan0 = hal9001.get_pin('a:0:i')
    sleep(5)
    channels.append(chan0)
    
    chan1 = hal9001.get_pin('a:1:i')
    sleep(5)
    channels.append(chan1)
    
    chan2 = hal9001.get_pin('a:2:i')
    sleep(5)
    channels.append(chan2)
    
    chan3 = hal9001.get_pin('a:3:i')
    sleep(5)
    channels.append(chan3)
    
    chan4 = hal9001.get_pin('a:4:i')
    sleep(5)
    channels.append(chan4)
    
    chan5 = hal9001.get_pin('a:5:i')
    sleep(5)
    channels.append(chan5)
    
    for i in channels:
        i.enable_reporting()
        print(i.read()*5,sep='/n')

    print('Readings nominal')
    
    return hal9001,channels

def readHal():
    return [i.read()*5 for i in channels]

