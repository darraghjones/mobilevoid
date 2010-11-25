require 'open-uri'
require 'nokogiri'
require 'digest/md5'

class HomeController < ApplicationController

  def index
    doc                = Nokogiri::HTML(open_url('http://www.legalsounds.com/'))
    @most_downloaded   = parse('http://www.legalsounds.com/mostDownloaded') #world_bestsellers
    @hot_releases      = parse('http://www.legalsounds.com/hotReleases')
    @just_added        = parse('http://www.legalsounds.com/justAdded')
    @sound_tracks      = parse('http://www.legalsounds.com/soundtracks')
    charts()
  end

  def charts()
    doc     = Nokogiri::HTML(open_url('http://www.legalsounds.com/ListChart'))
    @charts = Array.new
    doc.css('div.contentWrapper div.item')[0...15].each do |n|
      c       = Chart.new
      c.Title = n.css('a')[1].text()
      c.Date  = n.css('span.date').text()
      c.Title["Billboard "] = "" if c.Title["Billboard "]
      c.Url = n.css('a')[0]['href']
      @charts << c
    end
  end

  def parse(url)
    doc = Nokogiri::HTML(open_url(url))
    albums = Array.new
    doc.css('div.contentWrapper div.item').each do |n| 
      al = Album.new
      al.Artist = Artist.new
      al.Name = get_text(n.css('div.name a')[0])
      al.Url = get_href(n.css('div.name a')[0])
      al.Artist.Name  = get_text(n.css('div.artist a')[0])
      al.Artist.Url = get_href(n.css('div.artist a')[0])
      albums << al
    end
    albums
  end
end
