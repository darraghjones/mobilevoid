module Utility

 def open_url(url)
    return open(url) { |u| u.read } # heroku has a read-only filesystem :(
    #logger.log(url)
    digest = Digest::MD5.hexdigest(url)
    filename = 'db/html/' + digest
    if File.exists?(filename)
       s = File.open(filename, 'r') { |f| f.read }
    else
      s = open(url) { |u| u.read } 
      File.open(filename, 'w'){ |f| f.write(s) }
    end
    s
  end

end
