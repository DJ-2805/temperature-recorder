from numpy import log
from time import sleep
from pyfirmata import Arduino, util

# activate Arduino
port = '/dev/ttyUSB0'
hal9001 = Arduino(port)

# list of channels
channels = []

'''
initHal():
    initializes all channels to report values.
    It is most likely probably not evil
    returns:
        object of Arduino
        list of analog channels(0-5)
'''
def initHal():
    # iterator to read values from Arduino
    it = util.Iterator(hal9001)
    it.start()
    
    # channel 0
    # each channel initilization
    chan0 = hal9001.get_pin('a:0:i')
    # sleep called for synchronization between Arduino and Serial
    sleep(5)
    # appened to list of channels
    channels.append(chan0)
    
    # channel 1
    chan1 = hal9001.get_pin('a:1:i')
    sleep(5)
    channels.append(chan1)
    
    # channel 2
    chan2 = hal9001.get_pin('a:2:i')
    sleep(5)
    channels.append(chan2)
    
    # channel 3
    chan3 = hal9001.get_pin('a:3:i')
    sleep(5)
    channels.append(chan3)
    
    # channel 4
    chan4 = hal9001.get_pin('a:4:i')
    sleep(5)
    channels.append(chan4)
    
    # channel 5
    chan5 = hal9001.get_pin('a:5:i')
    sleep(5)
    channels.append(chan5)
    
    # enable all channels to report values
    for i in channels:
        i.enable_reporting()
        print(i.read()*5,sep='/n')

    # output if everything worked
    print('Readings nominal')

'''
readHal():
    Takes list of channels and outputs voltage readings from them
    pyfirmata library turns 0-5V reading to a scale of 0-1,
    so each channel is multiplied by a factor of 5
    returns:
        list of voltage reading from list of channels
'''
def readHal():
    return [i.read()*5 for i in channels]

'''
resiHal():
    Takes in a voltage value and resistance value to output the resistance
    of the thermistor within the circuit
    parameters:
        voltRead - voltage read from analog pin
        resFix - the value of the resistor placed in the circuit
    returns:
        resistance of thermistor
'''
def resiHal(voltRead,resFix):
    voltTotal = 5
    return voltRead/(voltTotal-voltRead)*resFix

'''
tempHal():
    Takes in equation parameters and resistance value to output the
    temperature of the thermistor within the circuit. This uses the
    Steinhart-Hart equation to evaluate to a temperature.
    parameters:
        a,b,c,d - parameters in the equation (found using nonlinear regression)
        res - the resistance of the thermistor
    returns temperature of thermistor
'''
def tempHal(a,b,c,d,res):
    return (a+b*log(res)+c*log(res)**2+d*log(res)**3)**(-1)