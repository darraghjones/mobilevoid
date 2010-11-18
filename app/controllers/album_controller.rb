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
    ar.Name = doc.css('div.author')[0].text()
    al.Name = doc.css('div.tit')[0].text()
    @songs  = Array.new
    doc.css('table.tbllist tr.off').each do |n|
      s        = Song.new
      s.Artist = ar
      s.Album  = al
      s.Name   = n.css('td')[2].text()
      s.Url    = n.css('div.preview div')[0]['href']
      @songs << s
    end
  end

end
