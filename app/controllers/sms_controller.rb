require 'moonshado-sms'

class SmsController < ApplicationController
 
  def env
    render :content_type => "text/plain", :text => ENV['MOONSHADOSMS_URL']
  end
 
  def create
    render :content_type => "text/plain", :text => params.to_yaml	
  end

  def send_sms

    sms = Moonshado::Sms.new("15556345789", "test")
    status = sms.deliver_sms
    report = Moonshado::Sms.find(status[:id])
    render :content_type => "text/plain", :text => sms.to_yaml + status.to_yaml + report.to_yaml
   
  end

end
