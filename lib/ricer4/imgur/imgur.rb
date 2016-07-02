# require 'json'
# require 'open-uri'
module Ricer4::Plugins::Imgur
  class Imgur < Ricer4::Plugin
    
    include Ricer4::Include::UsesInternet
    
    GROUP_PARAM = '<enum|named:"group",enums:["hot","viral","top"]>'

    trigger_is :imgur
    
    denial_of_service_protected
    
    has_setting name: :client_id, type: :secret, scope: :bot, permission: :responsible, default: 'a90bec0cef5bd5c'
    
    has_usage
    def execute
      imgur("https://api.imgur.com/3/gallery/random/random/")
    end
    
    has_usage  "#{GROUP_PARAM}", function: :execute_msg
    has_usage  "#{GROUP_PARAM} <page>", function: :execute_msg
    def execute_msg(group, page=nil)
      page = rand(5) if !page
      imgur("https://api.imgur.com/3/gallery/#{group}/top/#{page}.json")
    end
    
    def client_id
      get_setting(:client_id)
    end
    
    protected
    
    def imgur(url)
      threaded {
        headers = {
          "Authorization" => "Client-ID #{client_id}",
          "Accept" => 'application/json',
        }
        get_request(url, headers) do |response|
          result = ActiveSupport::JSON.decode(response.body)
          id = rand(7)
          imgur = result['data'][id]
          rply(:msg_image, {
            image: "#{imgur['title']} - #{imgur['link']} \u000303#{imgur['ups']}\u000f\u2934 \u000304#{imgur['downs']}\u000f\u2935",
          })
        end
      }
    end

  end
end
