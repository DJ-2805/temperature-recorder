from numpy import log,zeros
from time import sleep
from pyfirmata import Arduino, util
from scipy.io import savemat
import datetime as dt

'''
Author: D. James 20190316, V1.1
** Data Acquisition design **
Following a object orientated design
- class DAQ
    - connected to the Arduino
    - interacts with Channels
- class Channel
    - looks at data that Channels are collecting
    - does not interact with other Channels
'''

class DAQ:
    '''
    initialization function
    @param: port - str, value of port name
    @param: resistor - list, values of drop-down resistor for each Channel
    @param: duration - flt, time of acquisiton length
    @param: perSecondCount - rate at which data is collected
    @return: none
    '''
    def __init__(self,port,resistor,duration,perSecondCount):
        # initiate the Arduino
        self.board = Arduino(port)
        self.data = {}
        self.channels = []
        self.index = 0
        
        self.data['res'] = resistor
        
        # iterator to read from serial
        it = util.Iterator(self.board)
        it.start()
        resLen = len(resistor)
        
        # creates Channels depending on how many drop-down resistors given
        for i in range(0,resLen):
            name = str(i)
            chan = Channel(self.board,name,resistor[i],duration,perSecondCount)
            print('Channel '+name+':', chan.readVoltage(),'V')
            self.data[name] = chan.data
            self.channels.append(chan)
                
        self.len = len(self.channels)
        # output if everything read correctly
        print('readings nominal')
        
    '''
    iterator
    @return: Channel
    '''
    def __iter__(self):
        return iter(self.channels)
    
    '''
    switchChannel: allow DAQ to turn off/on a Channel
    @param: index - int, number value of which Channel to turn off
    @return: none
    '''
    def switchChannel(self,index):
        self.channels[index].flip()
    
    '''
    saveData: saves data into .mat file
    @param: time, list,array, - time values of run at point of save
    @return: none
    '''
    def saveData(self,time):
        now = dt.datetime.now().strftime("%Y%m%d-%H%M")
        self.data['time'] = time
        savemat(now+'data.mat',self.data)
    
    '''
    cleanData: cleans out 0s in data containers
    NOTE: last test didn't expect temperatures to go below 0 [C]
            - cleaning out 0s is safe at the moment
            - if running data that goes below 0 [C] then this must be changed
    '''
    def cleanData(self):
        for i in range(0,len(self.channels)):
            nonZeroIndex = (0 != self.channels[i])
            self.channels[i] = channels[i][nonZeroIndex]
            
class Channel:
    # volt pin that Channels are linked to in the Arduino
    voltTotal = 5
    
    '''
    initialization function
    @param: board - DAQ, board that the Channel is being linked with
    @param: name - str, name of the Channel
    @param: resistor - flt, drop-down resistor placed with Channel in circuit
    @param: duration - flt, time of acquisiton length
    @param: perSecondCount - rate at which data is collected
    @return: none
    '''
    def __init__(self,board,name,resistor,duration,perSecondCount):
        self.name = name
        name = 'a:'+name+':i'
        self.chan = board.get_pin(name)
        sleep(1)
        self.chan.enable_reporting()
        
        self.r = resistor
        self.on = True
        self.data = zeros(duration*perSecondCount)
        self.l = len(self.data)
        
    '''
    readVoltage: reads voltage from Channel
    @return: flt, voltage values [V]
    '''
    def readVoltage(self):
        return self.chan.read()*5
    
    '''
    calcResistance: calculates resistance from given voltage
    @param: voltRead - flt, voltage read from circuit
    @return: flt, calculated resistance
    NOTE: calculated resistance is based off of strict circuit design at the moment
    '''
    def calcResistance(self,voltRead):
        return voltRead/(self.voltTotal-voltRead)*(self.r*1000)
    
    '''
    calcTemperature: calculates temperature from given resistance and parameters
    @param: res - flt, resistance at thermistor
    @param: a,b,c,d - flt, parameters connected with Steinhart Equation
    @return: flt, temperature values [C]
    NOTE: designed for adafruit thermistor
    '''
    def calcTemperature(self,res,a,b,c,d):
        temp = (a+b*log(res)+c*log(res)**2+d*log(res)**3)**(-1)
        return temp - 273.15
    
    '''
    recoValue: records value to data array
    @param: index - int, index of data array
    @param: value - flt, value to be recorded into the array
    @return: none
    '''
    def recoValue(self,index,value):
        if(index == self.l):
            newData = zeros(self.l+10)
            for i in range(0,self.l):
                newData[i] = self.data[i]
            newData[index] = value
            self.data = newData
            self.l = len(newData)
        else:
            self.data[index] = value
    
    '''
    flip: turns Channel on or off
    '''
    def flip(self):
        if(self.on == True): self.on = False
        else: self.on = True