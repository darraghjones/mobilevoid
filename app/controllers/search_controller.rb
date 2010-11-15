

class SearchController < ApplicationController
  def index
  end

  def new
    if params[:s] || params[:ar] || params[:a] 
      doc = Nokogiri::HTML(open_url("http://www.legalsounds.com/powerSearch?s=#{params[:s]}&ar=#{CGI.escape(params[:ar])}&a=#{params[:a]}"))
	
      @songs = Array.new
      doc.css('table.tbllist tr.off').each do |n| 
	      ar = Artist.new
	      al = Artist.new
	      s = Song.new
	      s.Artist = ar
	      s.Album = al
	      s.Name = n.css('td')[1].text()
	      s.Artist.Name = n.css('td')[2].text()  
	      s.Album.Name = n.css('td')[3].text() 

	      @songs << s
      end
      respond_to do |format|
         format.html { render :show }
         format.js { render :show }
      end
    end
  end

  

end
