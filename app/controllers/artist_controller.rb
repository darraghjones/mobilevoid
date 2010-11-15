require 'open-uri'
require 'nokogiri'
require 'digest/md5'

class ArtistController < ApplicationController
  def index
    doc = Nokogiri::HTML(open_url('http://www.legalsounds.com' + request.path))
    @artists = Array.new
    doc.css('div.artistList a').each do |n| 
       ar = Artist.new
       ar.Name = n.text()
       ar.Url = n['href']
       @artists << ar
    end
    @artists = @artists.paginate(:page => params[:page], :per_page => 50).sort { |a1, a2| a1.Name <=> a2.Name }
  end

  def show
    doc = Nokogiri::HTML(open_url('http://www.legalsounds.com' + request.path))
    ar = Artist.new
    ar.Name = doc.css('div.tit')[0].text()
    ar.Url = request.path
    @albums = Array.new
    doc.css('table.albumlist').each do |n| 
       al = Album.new
       al.Artist = ar
       al.Name = n.css('a.albumName')[1].text()
       al.Url = n.css('a.albumName')[0]['href']
       @albums << al
    end
  end

end
