exports['local'] = ->
  return [
    phantomjs
    # chrome_mountain
    # firefox_mountain
    # safari6_mountain
  ]

exports['sauce labs'] = ->
  return [
    
    phantomjs

    # # chrome
    # chrome_linux
    # chrome_win8
    # chrome_mountain

    # # firefox
    # firefox_win8
    # firefox_linux
    # firefox_snow

    # # safari
    # safari5_win7
    # safari5_snow
    # safari6_mountain

    # # ie
    # ie6_winxp
    # ie7_winxp
    # ie8_winxp

    # ie8_win7
    # ie9_win7

    # ie10_win8
    
    # # ios
    # ios_iphone
    # ios_ipad

    # # android
    # # none - awiting sauce labs to support it
  ]


# phantom
# ----------------------------------------------------------------------------
phantomjs =
  browserName: 'phantomjs'
  tags: ['theoricus', 'phantomjs']


# chrome
# ----------------------------------------------------------------------------
chrome_winxp = 
  browserName: 'chrome'
  platform: 'Windows XP'
  tags: ['theoricus', 'chrome', 'winxp']
  'record-video': true

chrome_win7 = 
  browserName: 'chrome'
  platform: 'Windows 7'
  tags: ['theoricus', 'chrome', 'win7']
  'record-video': true

chrome_win8 = 
  browserName: 'chrome'
  platform: 'Windows 8'
  tags: ['theoricus', 'chrome', 'win8']
  'record-video': true

chrome_linux = 
  browserName: 'chrome'
  platform: 'Linux'
  tags: ['theoricus', 'chrome', 'linux']
  'record-video': true

chrome_snow = 
  browserName: 'chrome'
  platform: 'OS X 10.6'
  tags: ['theoricus', 'chrome', 'snow']
  'record-video': true

chrome_mountain = 
  browserName: 'chrome'
  platform: 'OS X 10.8'
  tags: ['theoricus', 'chrome', 'mountain']
  'record-video': true


# safari
# ----------------------------------------------------------------------------

safari5_win7 = 
  version: '5'
  browserName: 'safari'
  platform: 'Windows 7'
  tags: ['theoricus', 'safari5', 'win7']
  'record-video': true

safari5_snow = 
  version: '5'
  browserName: 'safari'
  platform: 'OS X 10.6'
  tags: ['theoricus', 'safari5', 'snow']
  'record-video': true

safari6_mountain = 
  version: '6'
  browserName: 'safari'
  platform: 'OS X 10.8'
  tags: ['theoricus', 'safari6', 'mountain']
  'record-video': true



# firefox
# ----------------------------------------------------------------------------
firefox_winxp = 
  browserName: 'firefox'
  version: '22'
  platform: 'Windows XP'
  tags: ['theoricus', 'firefox', 'winxp']
  'record-video': true

firefox_win7 = 
  browserName: 'firefox'
  version: '22'
  platform: 'Windows 7'
  tags: ['theoricus', 'firefox', 'win7']
  'record-video': true

firefox_win8 = 
  browserName: 'firefox'
  version: '22'
  platform: 'Windows 8'
  tags: ['theoricus', 'firefox', 'win8']
  'record-video': true

firefox_linux = 
  browserName: 'firefox'
  platform: 'Linux'
  tags: ['theoricus', 'firefox', 'linux']
  'record-video': true

firefox_snow = 
  browserName: 'firefox'
  version: '21'
  platform: 'OS X 10.6'
  tags: ['theoricus', 'firefox', 'snow']
  'record-video': true

firefox_mountain = 
  browserName: 'firefox'
  version: '22'
  platform: 'OS X 10.8'
  tags: ['theoricus', 'firefox', 'snow']
  'record-video': true


# ie
# ----------------------------------------------------------------------------

# win xp

ie6_winxp = 
  browserName: 'internet explorer '
  version: '6'
  platform: 'Windows XP'
  tags: ['theoricus', 'ie6', 'winxp']
  'record-video': true

ie7_winxp = 
  browserName: 'internet explorer'
  version: '7'
  platform: 'Windows XP'
  tags: ['theoricus', 'ie7', 'winxp']
  'record-video': true

ie8_winxp = 
  browserName: 'internet explorer'
  version: '8'
  platform: 'Windows XP'
  tags: ['theoricus', 'ie8', 'winxp']
  'record-video': true


# win 7

ie8_win7 = 
  browserName: 'internet explorer'
  version: '8'
  platform: 'Windows 7'
  tags: ['theoricus', 'ie8', 'win7']
  'record-video': true

ie9_win7 = 
  browserName: 'internet explorer'
  version: '9'
  platform: 'Windows 7'
  tags: ['theoricus', 'ie9', 'win7']
  'record-video': true


# win 8

ie10_win8 = 
  browserName: 'internet explorer'
  version: '10'
  platform: 'Windows 8'
  tags: ['theoricus', 'ie10', 'win8']
  'record-video': true


# ios
# ----------------------------------------------------------------------------

ios_iphone = 
  browserName: 'iphone'
  platform: 'OS X 10.8'
  tags: ['theoricus', 'ios', 'iphone']
  'record-video': true

ios_ipad = 
  browserName: 'ipad'
  platform: 'OS X 10.8'
  tags: ['theoricus', 'ios', 'ipad']
  'record-video': true


# android
# ----------------------------------------------------------------------------

android_phone = 
  browserName: 'android'
  platform: 'Linux'
  tags: ['theoricus', 'android', 'phone']
  'record-video': true

android_tablet = 
  browserName: 'android'
  'device-type': 'tablet'
  platform: 'Linux'
  tags: ['theoricus', 'android', 'tablet']
  'record-video': true