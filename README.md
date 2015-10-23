# lita-trello

[![Build Status](https://img.shields.io/travis/RWJMurphy/lita-trello/master.svg)](https://travis-ci.org/RWJMurphy/lita-trello)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems](http://img.shields.io/gem/v/lita-trello.svg)](https://rubygems.org/gems/lita-trello)
[![Coveralls Coverage](https://img.shields.io/coveralls/RWJMurphy/lita-trello/master.svg)](https://coveralls.io/r/RWJMurphy/lita-trello)
[![Code Climate](https://img.shields.io/codeclimate/github/RWJMurphy/lita-trello.svg)](https://codeclimate.com/github/RWJMurphy/lita-trello)
[![Gemnasium](https://img.shields.io/gemnasium/RWJMurphy/lita-trello.svg)](https://gemnasium.com/RWJMurphy/lita-trello)

Manage your Trello board from Lita.

Inspired by [hubot-trello](https://github.com/hubot-scripts/hubot-trello).

## Installation

Add lita-trello to your Lita instance's Gemfile:

``` ruby
gem "lita-trello"
```

## Configuration

```ruby
Lita.configure do |config|
  # ...
  config.handlers.trello.public_key = "0123456789abcdef0123456789abcdef"
  config.handlers.trello.token = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
  config.handlers.trello.board = "01234567"
  # ...
end

```

## Usage

```
trello new LIST Do the thing - Create a new card in LIST called 'Do the thing'
trello move https://trello.com/c/CARD_ID LIST - Move a card to LIST
trello list LIST - Show all cards in LIST
trello lists - Show all lists on your board
```
