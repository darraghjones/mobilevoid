require 'open-uri'
require 'nokogiri'
require 'digest/md5'

class HomeController < ApplicationController

  def index
    doc                = Nokogiri::HTML(open_url('http://www.legalsounds.com/'))
    #@world_bestsellers = parse(doc.css('div#cbwn1 div.info'))
    @world_bestsellers = world_bestsellers
    @hot_releases      = parse(doc.css('div#cbwn2 p'))
    @most_downloaded   = parse(doc.css('div#cbwn3 p'))
    @just_added        = parse(doc.css('div#cbwn4 p'))
    charts()
  end

  def world_bestsellers()
    doc    = Nokogiri::HTML(open_url('http://www.legalsounds.com/mostDownloaded?period=AllTime&entity=Album'))
    albums = Array.new
    doc.css('table.albumlist').each do |n|
      al          = Album.new
      ar          = Artist.new
      al.Artist   = ar
      al.Url      = n.css('a.albumName')[0]['href']
      al.CoverUrl = n.css('img')[0]['src']
      al.Name     = n.css('a.albumName')[1].text()
      ar.Name     = n.css('a.artistName')[0].text()
      ar.Url      = n.css('a.artistName')[0]['href']
      albums << al
    end
    albums
  end

  def charts()
    doc     = Nokogiri::HTML(open_url('http://www.legalsounds.com/ListChart'))
    @charts = Array.new
    doc.css('table.listcharts td')[0...15].each do |n|
      c       = Chart.new
      c.Title = n.css('img')[0]['alt']
      c.Date  = n.css('div.date').text()
      c.Title["Billboard "] = "" if c.Title["Billboard "]
      c.Url = n.css('a')[0]['href']
      @charts << c
    end
  end

  def parse(node_set)
    albums = Array.new
    node_set.each do |n|
      al        = Album.new
      al.Name   = n.css('a')[0].text()
      ar        = Artist.new
      ar.Name   = n.css('a')[1] ? n.css('a')[1].text() : "Various Artists"
      ar.Url    = n.css('a')[1] && n.css('a')[1]['href']
      al.Url    = n.css('a.albumName')[0]['href']
      al.Artist = ar
      albums << al
    end
    albums
  end

end
