# -*- coding: utf-8 -*-

import argparse
import urllib2
import urllib
import subprocess
import json
from HTMLParser import HTMLParser
from datetime import date
from datetime import datetime
from datetime import timedelta
#import vlc
import os
import glob
#import pygame
#import pyglet


MAX_TRY = 100

# reference
# tts
# http://fanyi.baidu.com/#auto/zh/
# weather api
# http://goodbai.com/web/UseForecastAndPMDataAPI.html it lists some usable api


class HourlyEntry:
    #def __init__(self, c, t, w, h):
    def __init__(self, h, d, c):
        self.condition = c
        #self.temp = t
        #self.wind = w
        self.day = d
        self.hour = h


class HourlyData:
    def __init__(self):
        self.date = ''
        self.entries = []
        
        
class AQIData:
    def __init__(self):
        self.date = ''
        self.index = ''
        
        
class WeatherData:
    def __init__(self):
        self.data = {'aqi': AQIData(), 'hourly': HourlyData()}
        
    def getAqiData(self):
        return self.data['aqi']
        
    def getHourlyData(self):
        return self.data['hourly']
        

class WeatherService:
    def __init__(self):
        pass
        
    def getData(self):
        data = WeatherData()
        self.fetchHourlyData(data.getHourlyData())
        self.fetchAqiData(data.getAqiData())
        return data
        
    def fetchHourlyData(self, data):
        self.fetchHourlyData_1(data)
    
    def fetchAqiData(self, data):
        self.fetchAqiData_1(data)
        
    def fetchHourlyData_1(self, data):
        i_try = 0
        while True:
            i_try += 1
            if i_try > MAX_TRY:
                break
            try:
                f = urllib2.urlopen('http://www.weather.com.cn/weather1d/101020100.shtml')
                page = f.read()
                p = HourlyParser()
                p.feed(page)
                rawHourData = p.getData()
                # example data
                # {"1d":["17日20时,n01,多云,2℃,西北风,微风","17日23时,n00,晴,1℃,西北风,微风","18日02时,n00,晴,2℃,西北风,微风","18日05时,n00,晴,2℃,西北风,微风","18日08时,d00,晴,2℃,西北风,微风","18日11时,d01,多云,8℃,无持续风向,微风","18日14时,d01,多云,8℃,无持续风向,微风","18日17时,d01,多云,8℃,无持续风向,微风","18日20时,n01,多云,7℃,无持续风向,微风"],"23d":[["19日08时,d01,多云,6℃,无持续风向,微风","19日11时,d01,多云,9℃,东北风,微风","19日14时,d01,多云,11℃,东北风,微风","19日17时,d01,多云,11℃,东北风,微风","19日20时,n01,多云,10℃,东北风,微风","19日23时,n02,阴,9℃,东风,微风","20日02时,n02,阴,9℃,东风,微风","20日05时,n02,阴,9℃,东风,微风"],["20日08时,d02,阴,8℃,东风,微风","20日11时,d07,小雨,10℃,东南风,微风","20日14时,d07,小雨,12℃,东南风,微风","20日17时,d07,小雨,11℃,东南风,微风","20日20时,n07,小雨,10℃,东南风,微风","21日02时,n08,中雨,8℃,东南风,微风"]],"7d":[["17日20时,n01,多云,2℃,西北风,微风","17日23时,n00,晴,1℃,西北风,微风","18日02时,n00,晴,2℃,西北风,微风","18日05时,n00,晴,2℃,西北风,微风"],["18日08时,d00,晴,2℃,西北风,微风","18日11时,d01,多云,8℃,无持续风向,微风","18日14时,d01,多云,8℃,无持续风向,微风","18日17时,d01,多云,8℃,无持续风向,微风","18日20时,n01,多云,7℃,无持续风向,微风","18日23时,n01,多云,6℃,无持续风向,微风","19日02时,n01,多云,5℃,无持续风向,微风","19日05时,n01,多云,6℃,无持续风向,微风"],["19日08时,d01,多云,6℃,无持续风向,微风","19日11时,d01,多云,9℃,东北风,微风","19日14时,d01,多云,11℃,东北风,微风","19日17时,d01,多云,11℃,东北风,微风","19日20时,n01,多云,10℃,东北风,微风","19日23时,n02,阴,9℃,东风,微风","20日02时,n02,阴,9℃,东风,微风","20日05时,n02,阴,9℃,东风,微风"],["20日08时,d02,阴,8℃,东风,微风","20日11时,d07,小雨,10℃,东南风,微风","20日14时,d07,小雨,12℃,东南风,微风","20日17时,d07,小雨,11℃,东南风,微风","20日20时,n07,小雨,10℃,东南风,微风","21日02时,n08,中雨,8℃,东南风,微风"],["21日08时,d08,中雨,10℃,东南风,微风","21日14时,d01,多云,12℃,北风,微风","21日20时,n07,小雨,10℃,北风,微风","22日02时,n07,小雨,10℃,北风,微风"],["22日08时,d07,小雨,10℃,北风,微风","22日14时,d07,小雨,11℃,东风,微风","22日20时,n07,小雨,10℃,东风,微风","23日02时,n07,小雨,9℃,东风,微风"],["23日08时,d07,小雨,10℃,东风,微风","23日14时,d07,小雨,10℃,北风,微风","23日20时,n08,中雨,8℃,北风,微风","24日02时,n07,小雨,7℃,北风,微风"],["24日08时,d07,小雨,8℃,北风,微风","24日14时,d02,阴,8℃,北风,微风","24日20时,n02,阴,8℃,北风,微风"]]}
                jsonHourData = json.loads(rawHourData)
                today = str(date.today().day).zfill(2)
                todayData = [x for x in jsonHourData['1d'] if x.find(today) == 0]
                for e in todayData:
                    pattern = str(today) + u'日'
                    h = e[e.find(pattern) + len(pattern):e.find(u'时')]
                    c = ','.join(e.split(',')[2:])
                    data.entries.append(HourlyEntry(h, today, c))
                print str(datetime.now()) + ' fetchHourlyData_1() succeeded.'
                break
            except:
                print str(i_try) + ' ' + str(datetime.now()) + " try fetchHourlyData_1() failed."

    def fetchAqiData_1(self, data):
        i_try = 0
        while True:
            i_try += 1
            if i_try > MAX_TRY:
                break
            try:
                # http://www.weather.com.cn/weather1d/101020100.shtml will send out several requests
                # you can do F12, and find below request
                response = subprocess.check_output(['curl', 'http://d1.weather.com.cn/sk_2d/101020100.html', 
                '-H', 'Pragma: no-cache', 
                '-H', 'Cookie: vjuids=cc982ae83.151adc397b0.0.94b8f9f; f_city=%E5%8D%8E%E7%9B%9B%E9%A1%BF%E7%89%B9%E5%8C%BA%7C401010100%7C; vjlast=1450319255.1450319255.30; __asc=c5b3f9e5151ae41f4de34c9e91e; __auc=e1e1ae94151adcfeca5b9bc66cf; Hm_lvt_080dabacb001ad3dc8b9b9049b36d43b=1450327272,1450327299,1450327835,1450327845; Hm_lpvt_080dabacb001ad3dc8b9b9049b36d43b=1450328523', 
                '-H', 'Accept-Encoding: gzip, deflate, sdch', 
                '-H', 'Accept-Language: zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4', 
                '-H', 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36', 
                '-H', 'Accept: */*', 
                '-H' 'Cache-Control: no-cache', 
                '-H', 'Referer: http://www.weather.com.cn/weather1d/101020100.shtml', 
                '-H', 'Proxy-Connection: keep-alive', '--compressed'])
        
                # response example
                # var dataSK = {"nameen":"shanghai","cityname":"上海","city":"101020100","temp":"3","tempf":"37","WD":"北风","wde":"N ","WS":"0级","wse":"","SD":"35%","time":"17:24","weather":"多云","weathere":"Cloudy","weathercode":"d01","qy":"1035","njd":"暂无实况","sd":"35%","aqi":"45","date":"12月17日(星期四)"}
                response = response[response.find('{'):]
                ### print response.encode('utf-8')
                parsed = json.loads(response)
                data.index = parsed['aqi']
                data.date = parsed['date'] + ' ' + parsed['time']
                print str(datetime.now()) + ' fetchAqiData_1() succeeded.'
                break
            except:
                print str(i_try) + ' ' + str(datetime.now()) + ' try fetchAqiData_1() failed.'
    
class HourlyParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.foundTag = False
        self.data = ''
        
    def handle_starttag(self, tag, attrs):
        if tag == 'script':
            self.foundTag = True
        else:
            self.foundTag = False
            
    def handle_endtag(self, tag):
        self.foundTag = False

    def handle_data(self, data):
        if self.foundTag and data.find('hour3data') != -1:
            data = data.strip()
            self.data = data[data.find('{'):]
        
    def getData(self):
        return self.data
        
    
class Reporter:
    def __init__(self):
        self.filename = str(date.today()) + ".mp3"
        
    def clearHistory(self, days):
        for x in range(0, int(days)):
            name = str(date.today() + timedelta(x))
            if os.path.isfile(name + '.mp3'):
                os.rename(name + '.mp3', name + '.bak')
        for x in glob.glob('*.mp3'):
            os.remove(x)
            print str(datetime.now()) + ' file: ' + x + ' is removed.'
        for x in glob.glob('*.bak'):
            name = x[:x.find('.')]
            os.rename(name + '.bak', name + '.mp3')
        
    def getText(self, hours):
        ws = WeatherService()
        wdata = ws.getData()
        astr = wdata.getAqiData().date + u', 空气质量指数：' + wdata.getAqiData().index
        hwanted = []
        for x in wdata.getHourlyData().entries:
            for y in hours:
                if abs(int(x.hour) - int(y)) <= 2 and x not in hwanted:
                    hwanted.append(x)
        hstr = ''
        for x in hwanted:
            # hstr += str(x.day) + u'号' + str(x.hour) + u'时，' + x.condition + u'；'
            hstr += str(x.hour) + u'时，' + x.condition + u'；'
            
        text = astr + u'。' + hstr + u'。'
        print str(datetime.now()) + ' ' + text.encode('utf8')
        return text
        
    def getVoice(self, text):
        print str(datetime.now()) + ' try to get voice.'
        # example
        # http://tts.baidu.com/text2audio?lan=zh&amp;pid=101&amp;ie=UTF-8&amp;text=%E4%B8%8A%E5%8D%888%E7%82%B9%20%E5%B0%8F%E9%9B%A8%20%E7%99%BE%E5%88%86%E4%B9%8B9&amp;spd=2
        base = 'http://tts.baidu.com/text2audio?lan=zh&pid=101&ie=UTF-8&text='
        url = base + urllib.quote(text.encode('utf8')) + '&spd=2'
        
        urllib.urlretrieve(url, self.filename)
        print str(datetime.now()) + ' ' + self.filename + "has downloaded."
        
    def play(self, hours):
        text = self.getText(hours)
        self.getVoice(text)
        #p = vlc.MediaPlayer(self.filename)
        #p.play()
        
        # http://guzalexander.com/2012/08/17/playing-a-sound-with-python.html
        # https://wiki.python.org/moin/Audio/
        # http://stackoverflow.com/questions/260738/play-audio-with-python
        
        #os.startfile(self.filename)
        
        #self.play_pygame()
        
        #self.play_pyglet()
        
        self.play_mpg321()
        
    def play_pygame(self):
        pygame.init()
        song = pygame.mixer.Sound(self.filename)
        clock = pygame.time.Clock()
        song.play()
        while True:
            clock.tick(60)
        pygame.quit()
        
    def play_pyglet(self):
        song = pyglet.media.load(self.filename)
        song.play()
        pyglet.app.run()
        
    def play_mpg321(self):
        os.system('mpg321 ' + self.filename)

if __name__    == "__main__":
    print str(datetime.now()) + ' current working dir is ' + os.getcwd()

    parser = argparse.ArgumentParser(description='weather reporter')
    parser.add_argument('--history', default="5", help='history data to keep')
    parser.add_argument('--hours', required=True, help='which hours of data need to report')
    
    args = parser.parse_args()
    r = Reporter()
    r.play(args.hours.split(','))
    r.clearHistory(args.history)
    




