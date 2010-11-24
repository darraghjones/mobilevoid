require 'open-uri'
require 'nokogiri'
require 'digest/md5'

class AlbumController < ApplicationController
  def index
  end

  def show
    doc     = Nokogiri::HTML(open_url('http://www.legalsounds.com' + request.path))
    ar      = Artist.new
    al      = Artist.new
    ar.Name = doc.css('div.albumInfo div.artist')[0].text()
    al.Name = doc.css('div.albumInfo div.name')[0].text()
    @songs  = Array.new
    doc.css('table.content tr')[1..-1].each do |n|
      s        = Song.new
      s.Artist = ar
      s.Album  = al
      s.Name   = get_text(n.css('td.name')[0])
      s.Url    = get_href(n.css('td.preview div.play')[0])
      @songs << s
    end
  end

end
