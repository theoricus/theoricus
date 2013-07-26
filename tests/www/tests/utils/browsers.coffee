module.exports = ->
  return [
    # chrome
    chrome_win8
    chrome_linux
    chrome_mountain

    # firefox
    firefox_win8
    firefox_linux
    firefox_mountain

    # safari
    safari5_snow
    safari5_winxp
    safari6_mountain

    # ie
    ie6_winxp
    ie7_winxp
    ie8_winxp

    ie8_win7
    ie9_win7

    ie10_win8
    
    # ios
    ios_iphone
    ios_ipad

    # android
    # none - awiting sauce labs to support it
  ]


# browsers versions
# ----------------------------------------------------------------------------

firefox_last = '22'
firefox_next_to_last = '21'

chrome_last = '28'
chrome_next_to_last = '27'


# chrome
# ----------------------------------------------------------------------------
chrome_winxp = 
  local: false
  browserName: 'chrome'
  version: chrome_next_to_last
  platform: 'Windows XP'
  tags: ['theoricus', 'chrome', 'winxp']
  'record-video': true

chrome_win7 = 
  local: false
  browserName: 'chrome'
  version: chrome_next_to_last
  platform: 'Windows 7'
  tags: ['theoricus', 'chrome', 'win7']
  'record-video': true

chrome_win8 = 
  local: false
  browserName: 'chrome'
  version: chrome_next_to_last
  platform: 'Windows 8'
  tags: ['theoricus', 'chrome', 'win8']
  'record-video': true

chrome_linux = 
  local: false
  browserName: 'chrome'
  version: chrome_last
  platform: 'Linux'
  tags: ['theoricus', 'chrome', 'linux']
  'record-video': true

chrome_snow = 
  local: false
  browserName: 'chrome'
  version: chrome_next_to_last
  platform: 'OS X 10.6'
  tags: ['theoricus', 'chrome', 'snow']
  'record-video': true

chrome_mountain = 
  local: true
  browserName: 'chrome'
  version: chrome_next_to_last
  platform: 'OS X 10.8'
  tags: ['theoricus', 'chrome', 'mountain']
  'record-video': true


# safari
# ----------------------------------------------------------------------------

safari5_winxp = 
  local: false
  version: '5'
  browserName: 'safari'
  platform: 'Windows 7'
  tags: ['theoricus', 'safari5', 'winxp']
  'record-video': true

safari5_snow = 
  local: false
  version: '5'
  browserName: 'safari'
  platform: 'OS X 10.6'
  tags: ['theoricus', 'safari5', 'snow']
  'record-video': true

safari6_mountain = 
  local: true
  version: '6'
  browserName: 'safari'
  platform: 'OS X 10.8'
  tags: ['theoricus', 'safari6', 'mountain']
  'record-video': true



# firefox
# ----------------------------------------------------------------------------
firefox_winxp = 
  local: false
  browserName: 'firefox'
  version: firefox_last
  platform: 'Windows XP'
  tags: ['theoricus', 'firefox', 'winxp']
  'record-video': true

firefox_win7 = 
  local: false
  browserName: 'firefox'
  version: firefox_last
  platform: 'Windows 7'
  tags: ['theoricus', 'firefox', 'win7']
  'record-video': true

firefox_win8 = 
  local: false
  browserName: 'firefox'
  version: firefox_last
  platform: 'Windows 8'
  tags: ['theoricus', 'firefox', 'win8']
  'record-video': true

firefox_linux = 
  local: false
  browserName: 'firefox'
  version: firefox_last
  platform: 'Linux'
  tags: ['theoricus', 'firefox', 'linux']
  'record-video': true

firefox_snow = 
  local: false
  browserName: 'firefox'
  # version: firefox_next_to_last # must to be null in sauce labs
  platform: 'OS X 10.6'
  tags: ['theoricus', 'firefox', 'snow']
  'record-video': true

firefox_mountain = 
  local: true
  local_only: true
  browserName: 'firefox'
  version: firefox_last
  platform: 'OS X 10.8'
  tags: ['theoricus', 'firefox', 'snow']
  'record-video': true


# ie
# ----------------------------------------------------------------------------

# win xp

ie6_winxp = 
  local: false
  browserName: 'internet explorer '
  version: '6'
  platform: 'Windows XP'
  tags: ['theoricus', 'ie6', 'winxp']
  'record-video': true

ie7_winxp = 
  local: false
  browserName: 'internet explorer'
  version: '7'
  platform: 'Windows XP'
  tags: ['theoricus', 'ie7', 'winxp']
  'record-video': true

ie8_winxp = 
  local: false
  browserName: 'internet explorer'
  version: '8'
  platform: 'Windows XP'
  tags: ['theoricus', 'ie8', 'winxp']
  'record-video': true


# win 7

ie8_win7 = 
  local: false
  browserName: 'internet explorer'
  version: '8'
  platform: 'Windows 7'
  tags: ['theoricus', 'ie8', 'win7']
  'record-video': true

ie9_win7 = 
  local: false
  browserName: 'internet explorer'
  version: '9'
  platform: 'Windows 7'
  tags: ['theoricus', 'ie9', 'win7']
  'record-video': true


# win 8

ie10_win8 = 
  local: false
  browserName: 'internet explorer'
  version: '10'
  platform: 'Windows 8'
  tags: ['theoricus', 'ie10', 'win8']
  'record-video': true


# ios
# ----------------------------------------------------------------------------

ios_iphone = 
  local: false
  browserName: 'iphone'
  platform: 'OS X 10.8'
  tags: ['theoricus', 'ios', 'iphone']
  'record-video': true

ios_ipad = 
  local: false
  browserName: 'ipad'
  platform: 'OS X 10.8'
  tags: ['theoricus', 'ios', 'ipad']
  'record-video': true


# android
# ----------------------------------------------------------------------------

android_phone = 
  local: false
  browserName: 'android'
  platform: 'Linux'
  tags: ['theoricus', 'android', 'phone']
  'record-video': true

android_tablet = 
  local: false
  browserName: 'android'
  'device-type': 'tablet'
  platform: 'Linux'
  tags: ['theoricus', 'android', 'tablet']
  'record-video': true