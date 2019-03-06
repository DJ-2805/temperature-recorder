from numpy import log,zeros
from time import sleep
from pyfirmata import Arduino, util
from scipy.io import savemat
import datetime as dt

## NOTE
# fix zero out in clean data
# add time to class, so that all data is in one .mat file

class DAQ:
    def __init__(self,port,resistor,duration,perSecondCount):
        self.board = Arduino(port)
        self.data = {}
        self.channels = []
        self.index = 0
        
        self.data['res'] = resistor
        
        it = util.Iterator(self.board)
        it.start()
        resLen = len(resistor)
        
        for i in range(0,resLen):
            name = str(i)
            chan = Channel(self.board,name,resistor[i],duration,perSecondCount)
            print('Channel '+name+':', chan.readVoltage(),'V')
            self.data[name] = chan.data
            self.channels.append(chan)
                
        self.len = len(self.channels)
            
        print('readings nominal')
        
    def __iter__(self):
        return iter(self.channels)
    
    def switchChannel(self,index):
        self.channels[index].flip()
        
    def saveData(self):
        now = dt.datetime.now().strftime("%Y%m%d-%H%M")
        savemat(now+'data.mat',self.data)
    
    def cleanData(self):
        for i in self.channels:
            i.data = i.data[i.data != 0]
            
class Channel:
    voltTotal = 5
    
    def __init__(self,board,name,resistor,duration,perSecondCount):
        self.name = name
        name = 'a:'+name+':i'
        self.chan = board.get_pin(name)
        sleep(1)
        self.chan.enable_reporting()
        
        self.r = resistor
        self.on = True
        self.data = zeros(duration*perSecondCount)
        
    def readVoltage(self):
        return self.chan.read()*5
    
    def calcResistance(self,voltRead):
        return voltRead/(self.voltTotal-voltRead)*(self.r*1000)
    
    def calcTemperature(self,res,a,b,c,d):
        temp = (a+b*log(res)+c*log(res)**2+d*log(res)**3)**(-1)
        return temp - 273.15
    
    def recoValue(self,index,value):
        self.data[index] = value
    
    def flip(self):
        if(self.on == True): self.on = False
        else: self.on = True