#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'twitter'
require 'dotenv'
require 'awesome_print'

DATA_DIR = './_data/'
SMAPLE_YAML = File.join(DATA_DIR, 'tweet_sample.yml')
Dotenv.load

class Scraper
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['consumer_key']
      config.consumer_secret     = ENV['consumer_secret']
      config.access_token        = ENV['access_token']
      config.access_token_secret = ENV['access_token_secret']
    end
  end

  def save_embed_htmls(out_path)
    html_set = {}
    if File.exists?(out_path)
      html_set = YAML.load_file(out_path)
    end

    urls.each do |url|
      if html_set.has_key?(url)
        next
      end
      puts url
      embed = client.oembed(url);
      html_set[embed.url.to_s] = embed.html
    end
    # File.write(out_path, YAML.dump(html_set))
  end

  def save_tweet_objects(out_path)
    json_set = {}
    if File.exists?(out_path)
      json_set = YAML.load_file(out_path)
    end

    urls.each do |url|
      if json_set.has_key?(url)
        next
      end
      puts url
      json_set[url] = JSON.pretty_generate(@client.status(url).attrs)
    end
    File.write(out_path, YAML.dump(json_set))
  end

  private
  def urls
    if !@urls.nil?
      return @urls
    end

    sample = YAML.load_file(SMAPLE_YAML)
    @urls = sample.map {|section|
      section['tweets'].map {|tweet|
        tweet['url']
      }
    }.flatten
  end
  @urls
end

s = Scraper.new
s.save_tweet_objects(File.join(DATA_DIR, 'tweet_objects.yml'))
# s.save_embed_htmls(File.join(DATA_DIR, 'tweet_embeds.yml'))
