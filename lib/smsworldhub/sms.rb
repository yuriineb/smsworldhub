module Smsworldhub
  class Sms
    require 'httparty'
    def initialize token
      @api_url = 'https://api.smsworldhub.com/v1/'
      @token = token
    end


    def send phone, message, params={}
      @params = { token: @token, phone: phone, mes: message }
      @params.merge! params if params.any?
      @response = send_get 'send', @params
      @body = to_json(@response.body)
      if ok?
        @body['data']
      else
        ArgumentError.new @body['message']
      end
    end

    def balance params={}
      @params = { token: @token }
      @params.merge! params if params.any?
      @response = send_get 'balance', @params
      @body = to_json(@response.body)
      if ok?
        @body['data']
      else
        ArgumentError.new @body['message']
      end
    end

    def inbox params={}
      @params = { token: @token }
      @params.merge! params if params.any?
      @response = send_get 'sms/inbox', @params
      @body = to_json(@response.body)
      if ok?
        @body['data']
      else
        ArgumentError.new @body['message']
      end
    end

    def status id
      @params = { token: @token, id: id }
      @response = send_get 'status', @params
      @body = to_json(@response.body)
      if ok?
        @body['data']
      else
        ArgumentError.new @body['message']
      end
    end

    private

    def ok?
      @body['status'] == 'OK'
    end

    def to_json text
      JSON.parse text
    end

    def send_get url, params
      HTTParty.get @api_url+ url, query: params
    end

    def dend_post url, params
      HTTParty.get url, params
    end
  end
end
