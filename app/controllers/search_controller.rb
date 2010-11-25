class SearchController < ApplicationController

  def index
    @searches = Rails.cache.read(:searches) || []
    render :partial => true
  end
 
  def new
    if params[:pattern]
      s = Rails.cache.read(:searches) && Rails.cache.read(:searches).dup || []
      s << params[:pattern]
      Rails.cache.write(:searches, s)
      doc = Nokogiri::HTML(open_url("http://www.legalsounds.com/search?pattern=#{CGI.escape(params[:pattern])}"))
    elsif params[:s] || params[:ar] || params[:a]
      doc = Nokogiri::HTML(open_url("http://www.legalsounds.com/powerSearch?s=#{CGI.escape(params[:s])}&ar=#{CGI.escape(params[:ar])}&a=#{CGI.escape(params[:a])}"))
    end

    if doc
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
      respond_to do |format|
        format.html { render :show }
        format.js { render :show }
      end
    end
  end


end
