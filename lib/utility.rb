module Utility

  def open_url(url)
    Rails.logger.info(url)
    digest   = Digest::MD5.hexdigest(url)
    filename = "#{Rails.root}/tmp/" + digest
    if Rails.cache.read(digest)
      Rails.logger.info("Rails cache hit.")
      s = Rails.cache.read(digest)
    elsif File.exists?(filename)
      Rails.logger.info("Disk cache hit.")
      s = File.open(filename, 'r') { |f| f.read }
    else
      Rails.logger.info("Cache miss.")
      s = open(url) { |u| u.read }
      File.open(filename, 'w') { |f| f.write(s) }
      Rails.cache.write(digest, s)
    end
    s
  end

end
