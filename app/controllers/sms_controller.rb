require 'moonshado-sms'

class SmsController < ApplicationController

  def env
    render :content_type => "text/plain", :text => ENV['MOONSHADOSMS_URL']
  end
 
  def create
    u = User.confirm!(params[:mobile], params[:message])
    render :content_type => "text/plain", :text => u.to_yaml	
  end

  def send_sms

    sms = Moonshado::Sms.new("447576537223", "test")
    status = sms.deliver_sms
    #report = Moonshado::Sms.find(status[:id])
    render :content_type => "text/plain", :text => sms.to_yaml + status.to_yaml #+ report.to_yaml
   
  end

end
