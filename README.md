# Slack Scratcher

[![Build Status][travis_image]][travis_link]
[![Coverage Status][coveralls_image]][coveralls_link]
[![Code Climate][codeclimate_link]][codeclimate_link]
[![Inline docs][inch_image]][inch_link]
[![Yard Docs][yard_image]][yard_link]
[![Dependency Status][gemnasium_image]][gemnasium_link]

[travis_image]: https://travis-ci.org/nacyot/slack_scratcher.svg?branch=master
[travis_link]: https://travis-ci.org/nacyot/slack_scratcher
[coveralls_image]: https://coveralls.io/repos/nacyot/slack_scratcher/badge.svg
[coveralls_link]: https://coveralls.io/r/nacyot/slack_scratcher
[codeclimate_image]: https://codeclimate.com/github/nacyot/slack_scratcher/badges/gpa.svg
[codeclimaet_link]: https://codeclimate.com/github/nacyot/slack_scratcher
[inch_image]: http://inch-ci.org/github/nacyot/slack_scratcher.svg?branch=master
[inch_link]: http://inch-ci.org/github/nacyot/slack_scratcher
[yard_image]: http://img.shields.io/badge/yard-docs-blue.svg
[yard_link]: http://www.rubydoc.info/github/nacyot/slack_scratcher/master
[gemnasium_image]: https://gemnasium.com/nacyot/slack_scratcher.svg
[gemnasium_link]: https://gemnasium.com/nacyot/slack_scratcher

## Installation

use gem command,

```
$ gem install slack_scratcher
```

or use bundle directive in Gemfile.

```
gem 'slack_scratcher'
```

## Usage

Export dir to Elasticsearch.

```
require 'slack_scratcher'
hosts = ['http://192.168.59.103:9200']

adapter = SlackScratcher::Adapter::Elasticsearch.new(hosts, index: 'slack', type: 'logs')
loader = SlackScratcher::Loader::File.new('./tmp/infovis-2015-03-06/')
router = SlackScratcher::Router.new(loader, adapter)

route.route
```

## Contributors

* Daekwon Kim (nacyot)

## LICENSE

The MIT License (MIT)

Copyright (c) 2015 Daekwon Kim

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
