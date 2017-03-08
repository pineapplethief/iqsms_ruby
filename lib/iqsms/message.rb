module IqSMS
  class Message
    def self.message_to_hash(message)
      hash = {
        clientId: message.client_id,
        phone: message.phone,
        text: message.text
      }
      hash[:wap_url] = message.wap_url if message.respond_to?(:wap_url) && message.wap_url.present?
      hash[:sender] = message.sender if message.sender.present?
      hash[:flash] = '1' if message.respond_to?(:flash) && message.flash.present?
      hash
    end

    def self.message_to_hash_for_status(message)
      {
        clientId: message.client_id,
        smscId: message.smsc_id
      }
    end

    attr_reader :client_id,
                :smsc_id,
                :phone,
                :text,
                :wap_url,
                :sender,
                :flash,
                :status

    def initialize(client_id:,
                   phone:,
                   text:,
                   wap_url: nil,
                   sender: nil,
                   smsc_id: nil,
                   status: nil,
                   flash: false)
      @client_id = client_id
      @phone = phone
      @text = text
      @wap_url = wap_url
      @sender = sender
      @smsc_id = smsc_id
      @status = MessageStatus.new(status)
      @flash = flash
    end

    def update!(message_hash)
      @smsc_id = message_hash[:smscId]
      @status = MessageStatus.new(message_hash[:status])
    end

    def flash?
      @flash
    end

    def to_hash
      self.class.message_to_hash(self)
    end
  end
end
