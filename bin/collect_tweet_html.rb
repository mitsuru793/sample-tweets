#!/usr/bin/env ruby

require 'yaml'
require 'twitter'
require 'dotenv'

DATA_DIR = './_data/'
SMAPLE_YAML = File.join(DATA_DIR, 'tweet_sample.yml')
OUT_FILE = File.join(DATA_DIR, 'tweet_html_set.yml')

sample = YAML.load_file(SMAPLE_YAML)
urls = sample.map {|section|
  section['tweets'].map {|tweet|
    tweet['url']
  }
}.flatten

Dotenv.load
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['consumer_key']
  config.consumer_secret     = ENV['consumer_secret']
  config.access_token        = ENV['access_token']
  config.access_token_secret = ENV['access_token_secret']
end

html_set = {}
if File.exists?(OUT_FILE)
  html_set = YAML.load_file(OUT_FILE)
end

urls.each do |url|
  unless html_set.has_key?(url)
    puts url
    embed = client.oembed(url);
    html_set[embed.url.to_s] = embed.html
  end
end

File.write(OUT_FILE, YAML.dump(html_set))
