require 'open-uri'
require 'nokogiri'
require 'digest/md5'

class ArtistController < ApplicationController
  def index
    doc      = Nokogiri::HTML(open_url('http://www.legalsounds.com' + request.path))
    @artists = Array.new
    doc.css('div.contentWrapper div.item').each do |n|
      ar      = Artist.new
      ar.Name = n.css('div.name a')[0].text()
      ar.Url  = n.css('div.name a')[0]['href']
      @artists << ar
    end
    @artists = @artists.paginate(:page => params[:page], :per_page => 50).sort { |a1, a2| a1.Name <=> a2.Name }
    @most_popular = Array.new
    doc.css('ul li').each do |n|
      ar = Artist.new
      ar.Name = n.css('a')[0].text()
      ar.Url = n.css('a')[0]['href']
      @most_popular << ar
    end
  end

  def show
    doc     = Nokogiri::HTML(open_url('http://www.legalsounds.com' + request.path))
    ar      = Artist.new
    ar.Name = get_text(doc.css('div.artistInfo div.name h1')[0])
    ar.Url  = request.path
    @albums = Array.new
    doc.css('div.contentWrapper div.item').each do |n|
      al        = Album.new
      al.Artist = ar
      al.Name   = n.css('div.name a')[0].text()
      al.Url    = n.css('div.name a')[0]['href']
      @albums << al
    end
  end

end
