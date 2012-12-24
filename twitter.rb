#!/usr/bin/ruby

# A twitter bot, in ruby. Not done one of these for a while!
# Usage: source config/default.sh && ruby holidaybot.sh

require 'rubygems'
require 'twitter'
require 'addressable/uri'
require 'faraday'
require 'json'
require 'pp'
   
class Holidaybot

  def replied_to
    replied_to = {}
    Twitter.user_timeline.each do |tweet|
      if tweet[:attrs][:in_reply_to_status_id]
        replied_to[ tweet[:attrs][:in_reply_to_status_id].to_s ] = true
      end
    end
    pp replied_to
    replied_to
  end

  def get_date_from a
    if a
      day = '%02d' % a[0].to_f
      month = '%02d' % a[1].to_f
      return '2012-' + month + '-' + day + ' 06:00'
    end
  end

  def update update, options
    options[:lat] = 51.072991
    options[:long] = 1.123606
    pp options
    begin
      Twitter.update update, options
    rescue Exception => e
      pp e
    end
  end

  def go
    mentions = Twitter.mentions_timeline
    replied_to = self.replied_to
    puts mentions.length.to_s + ' mentions'
    mentions.each do |tweet|
      if ! replied_to[ tweet[:attrs][:id_str] ]
        options = { :in_reply_to_status_id => tweet[:attrs][:id_str] }
        self.update '@' + tweet[:user][:screen_name] + ' hello', options
      end
    end
  end
end

Holidaybot.new.go
