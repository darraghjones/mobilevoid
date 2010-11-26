class ChartController < ApplicationController

  caches_action :index, :show, :layout => false

  def index
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

  def show
    @albums = parse("http://www.legalsounds.com/InspectChart?" + request.query_string)
  end

  def most_downloaded
    entity = params[:entity]
    period = params[:period]
    case entity
      when "Album", "Compilation"
        @albums = parse('http://www.legalsounds.com/mostDownloaded?' + request.query_string)
        render "album/index"
      when "Artist"
        doc    = Nokogiri::HTML(open_url("http://www.legalsounds.com/mostDownloaded?" + request.query_string))
        @artists = Array.new
        doc.css('div.contentWrapper div.item').each do |n|
          ar      = Artist.new
          ar.Name = get_text(n.css('div.name')[0])
          ar.Url  = get_href(n.css('a')[0] && n.css('a')[0])
          @artists << ar
        end
        @most_popular = []
        @artists = @artists.paginate(:page => params[:page])
        render "artist/index"
      when "Song"
        doc    = Nokogiri::HTML(open_url("http://www.legalsounds.com/mostDownloaded?" + request.query_string))
        @songs = Array.new
        doc.css('form table.content tr').each do |n|
          ar            = Artist.new
          al            = Artist.new
          s             = Song.new
          s.Artist      = ar
          s.Album       = al
          s.Name        = get_text(n.css('td.name')[0])
          s.Url         = get_href(n.css('div.preview div')[0])
          s.Artist.Name = get_text(n.css('td.artist a')[0])
          s.Artist.Url  = get_href(n.css('td.artist a')[0])
          s.Album.Name  = get_text(n.css('td.album a')[0])
          s.Album.Url   = get_href(n.css('td.album a')[0])

          @songs << s
        end
        render "search/show"

      else
    end

  end


end
