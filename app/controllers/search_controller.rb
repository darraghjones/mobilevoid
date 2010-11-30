class SearchController < ApplicationController

  def index
    @searches = Search.order("id desc").limit(10)
    render :partial => true
  end
 
  def create
    s = Search.create(params)
    if params[:pattern]
      search_param = CGI.escape(params[:pattern])
      path = case params[:what]
        when "artist" then "/powerSearch?ar=#{search_param}"
        when "album" then "/powerSearch?a=#{search_param}"
        when "song" then "/powerSearch?s=#{search_param}"
        else "/search?pattern=#{search_param}"
      end
      search_url = "http://www.legalsounds.com" + path
    elsif params[:s] || params[:ar] || params[:a]
      search_url = "http://www.legalsounds.com/powerSearch?s=#{CGI.escape(params[:s])}&ar=#{CGI.escape(params[:ar])}&a=#{CGI.escape(params[:a])}"
    end
      doc = Nokogiri::HTML(open_url(search_url))
    if doc
      @songs = Array.new
      doc.css('form table.content tr').each do |n|
        ar            = Artist.new
        al            = Artist.new
        s             = Song.new
        s.Artist      = ar
        s.Album       = al
        s.Name        = get_text(n.css('td.name')[0])
        s.Url         = get_href(n.css('td.preview div')[0])
        s.Artist.Name = get_text(n.css('td.artist a')[0])
        s.Artist.Url  = get_href(n.css('td.artist a')[0])
        s.Album.Name  = get_text(n.css('td.album a')[0])
        s.Album.Url   = get_href(n.css('td.album a')[0])
        @songs << s
      end
      respond_to do |format|
        format.html { render :show }
        format.js { render :show }
      end
    end
  end


end
