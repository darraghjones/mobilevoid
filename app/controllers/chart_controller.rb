class ChartController < ApplicationController
  def index
  end

  def show

    doc     = Nokogiri::HTML(open_url("http://www.legalsounds.com/InspectChart?" + request.query_string))

    @albums = Array.new
    doc.css('table.coversChart').each do |n|
      ar             = Artist.new
      al             = Album.new
      al.Artist      = ar
      al.Artist.Name = n.css('td.cont a.artistName')[0] && n.css('td.cont a.artistName')[0].text() || "Various Artists"
      al.Name        = n.css('td.cont a')[0] && n.css('td.cont a')[0].text() || ""

      al.Artist.Url  = n.css('td.cont a.artistName')[0] && n.css('td.cont a.artistName')[0]['href']
      al.Url         = n.css('td.cont a')[0] && n.css('td.cont a')[0]['href']


      @albums << al
    end


  end

  def most_downloaded
    entity = params[:entity]
    period = params[:period]
    doc    = Nokogiri::HTML(open_url("http://www.legalsounds.com/mostDownloaded?" + request.query_string))
    case entity
      when "Artist"
        @artists = Array.new
        doc.css('div.artistList td').each do |n|
          ar      = Artist.new
          ar.Name = n.css('a')[0] && n.css('a')[0].text() || "Various Artists"
          ar.Url  = n.css('a')[0] && n.css('a')[0]['href']
          @artists << ar
        end
        @artists = @artists.paginate(:page => params[:page])
        render "artist/index"
      when "Album", "Compilation"
        @albums = Array.new
        doc.css('table.albumlist').each do |n|
          ar        = Artist.new
          al        = Album.new
          al.Artist = ar
          al.Name   = n.css('a.albumName')[1].text()
          al.Url    = n.css('a.albumName')[0]['href']
          ar.Name   = n.css('a.artistName')[0] && n.css('a.artistName')[0].text() || "Various Artists"
          ar.Url    = n.css('a.artistName')[0] && n.css('a.artistName')[0]['href']

          @albums << al
        end
        render "album/index"

      when "Song"
        @songs = Array.new
        doc.css('table.tbllist tr.off').each do |n|
          ar            = Artist.new
          al            = Artist.new
          s             = Song.new
          s.Artist      = ar
          s.Album       = al
          s.Name        = n.css('td')[1].text()
          s.Url         = n.css('div.preview div')[0]['href']
          s.Artist.Name = n.css('td')[2].text()
          s.Artist.Url  = n.css('td')[2].at_css('a') && n.css('td')[2].at_css('a')['href']
          s.Album.Name  = n.css('td')[3].text()
          s.Album.Url   = n.css('td')[3].at_css('a')['href']

          @songs << s
        end
        render "search/show"

      else
    end

  end


end
