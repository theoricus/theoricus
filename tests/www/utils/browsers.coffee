firefox_last = '22'
firefox_next_to_last = '21'

chrome_last = '28'

module.exports =

  # last chrome
  # ----------------------------------------------------------------------------
  chrome_winxp:
    local: false
    browserName: 'chrome'
    version: '27'
    platform: 'Windows XP'
    tags: ['theoricus', 'test', 'chrome', 'winxp']
    'record-video': true

  chrome_win7:
    local: false
    browserName: 'chrome'
    platform: 'Windows 7'
    tags: ['theoricus', 'test', 'chrome', 'win7']
    'record-video': true

  chrome_win8:
    local: false
    browserName: 'chrome'
    platform: 'Windows 8'
    tags: ['theoricus', 'test', 'chrome', 'win8']
    'record-video': true

  chrome_linux:
    local: false
    browserName: 'chrome'
    platform: 'Linux'
    tags: ['theoricus', 'test', 'chrome', 'linux']
    'record-video': true

  chrome_snow:
    local: false
    browserName: 'chrome'
    platform: 'OS X 10.6'
    tags: ['theoricus', 'test', 'chrome', 'snow']
    'record-video': true

  chrome_mountain:
    local: true
    browserName: 'chrome'
    platform: 'OS X 10.8'
    tags: ['theoricus', 'test', 'chrome', 'mountain']
    'record-video': true


  # safari
  # ----------------------------------------------------------------------------
 
  # # safari5 on snow reports false `phishing's alert` when
  # # opening page through sauce connect
  # safari_snow:
  #   local: false
  #   version: '5'
  #   browserName: 'safari'
  #   platform: 'OS X 10.6'
  #   tags: ['theoricus', 'test', 'safari5', 'snow']
  #   'record-video': true

  safari_mountain:
    local: true
    version: '6'
    browserName: 'safari'
    platform: 'OS X 10.8'
    tags: ['theoricus', 'test', 'safari6', 'mountain']
    'record-video': true

  safari_winxp:
    local: false
    version: '5'
    browserName: 'safari'
    platform: 'Windows 7'
    tags: ['theoricus', 'test', 'safari5', 'winxp']
    'record-video': true


  # last firefox
  # ----------------------------------------------------------------------------
  firefox_winxp:
    local: false
    browserName: 'firefox'
    version: '21'
    platform: 'Windows XP'
    tags: ['theoricus', 'test', 'firefox', 'winxp']
    'record-video': true

  firefox_win7:
    local: false
    browserName: 'firefox'
    platform: 'Windows 7'
    tags: ['theoricus', 'test', 'firefox', 'win7']
    'record-video': true

  firefox_win8:
    local: false
    browserName: 'firefox'
    platform: 'Windows 8'
    tags: ['theoricus', 'test', 'firefox', 'win8']
    'record-video': true

  firefox_linux:
    local: false
    browserName: 'firefox'
    platform: 'Linux'
    tags: ['theoricus', 'test', 'firefox', 'linux']
    'record-video': true

  firefox_snow:
    local: false
    browserName: 'firefox'
    platform: 'OS X 10.6'
    tags: ['theoricus', 'test', 'firefox', 'snow']
    'record-video': true

  firefox_mountain:
    local: true
    local_only: true
    browserName: 'firefox'
    platform: 'OS X 10.8'
    tags: ['theoricus', 'test', 'firefox', 'snow']
    'record-video': true


  # all IEs
  # ----------------------------------------------------------------------------

  # WIN XP
  # ie6_winxp:
  #   local: false
  #   browserName: 'internet explorer '
  #   version: '6'
  #   platform: 'Windows XP'
  #   tags: ['theoricus', 'test', 'ie6', 'winxp']
  #   'record-video': true

  # ie7_winxp:
  #   local: false
  #   browserName: 'internet explorer'
  #   version: '7'
  #   platform: 'Windows XP'
  #   tags: ['theoricus', 'test', 'ie7', 'winxp']
  #   'record-video': true

  # ie8_winxp:
  #   local: false
  #   browserName: 'internet explorer'
  #   version: '8'
  #   platform: 'Windows XP'
  #   tags: ['theoricus', 'test', 'ie8', 'winxp']
  #   'record-video': true

  # # WIN 7
  # ie8_win7:
  #   local: false
  #   browserName: 'internet explorer'
  #   version: '8'
  #   platform: 'Windows 7'
  #   tags: ['theoricus', 'test', 'ie8', 'win7']
  #   'record-video': true

  # ie9_win7:
  #   local: false
  #   browserName: 'internet explorer'
  #   version: '9'
  #   platform: 'Windows 7'
  #   tags: ['theoricus', 'test', 'ie9', 'win7']
  #   'record-video': true

  # WIN 8
  ie10_win8:
    local: false
    browserName: 'internet explorer'
    version: '10'
    platform: 'Windows 8'
    tags: ['theoricus', 'test', 'ie10', 'win8']
    'record-video': true


  # IOS
  # ----------------------------------------------------------------------------
  ios_iphone:
    local: false
    browserName: 'iphone'
    platform: 'OS X 10.8'
    tags: ['theoricus', 'test', 'ios', 'iphone']
    'record-video': true

   ios_ipad:
    local: false
    browserName: 'ipad'
    platform: 'OS X 10.8'
    tags: ['theoricus', 'test', 'ios', 'ipad']
    'record-video': true

  # ANDROID (awaiting support for android on sauce-connect)
  # ----------------------------------------------------------------------------
  # android_phone:
  #  local: false
  #   browserName: 'android'
  #   platform: 'Linux'
  #   tags: ['theoricus', 'test', 'android', 'phone']
  #   'record-video': true

  # android_tablet:
  #  local: false
  #   browserName: 'android'
  #   'device-type': 'tablet'
  #   platform: 'Linux'
  #   tags: ['theoricus', 'test', 'android', 'tablet']
  #   'record-video': true