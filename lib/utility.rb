module Utility

 def open_url(url)
    Rails.logger.info(url)
    digest = Digest::MD5.hexdigest(url)
    filename = "#{Rails.root}/tmp/" + digest
    if File.exists?(filename)
       s = File.open(filename, 'r') { |f| f.read }
    else
      s = open(url) { |u| u.read } 
      File.open(filename, 'w'){ |f| f.write(s) }
    end
    s
  end

end
