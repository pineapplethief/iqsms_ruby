module IqSMS
  class Message
    def self.message_to_hash(message)
      hash = {
        clientId: message.client_id,
        phone: message.phone,
        text: message.text
      }
      hash[:wap_url] = message.wap_url if message.wap_url.present?
      hash[:sender] = message.sender if message.sender.present?
      hash[:flash] = '1' if message.flash.present?
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
      @status = status
      @flash = flash
    end

    def update!(message_hash)
      @smsc_id = message_hash[:smscId]
      @status = message_hash[:status]
    end

    def flash?
      @flash
    end

    def to_hash
      self.class.message_to_hash(self)
    end

    def status_text
      case @status
      when 'accepted'.freeze
        'Сообщение принято на обработку'.freeze
      when 'queued'.freeze
        'Сообщение находится в очереди'.freeze
      when 'delivered'.freeze
        'Сообщение доставлено'.freeze
      when 'delivery error'.freeze
        'Ошибка доставки SMS (абонент в течение времени доставки находился вне зоны действия сети или номер абонента заблокирован)'.freeze
      when 'smsc submit'.freeze
        'Сообщение доставлено в SMSC'.freeze
      when 'smsc reject'.freeze
        'Сообщение отвергнуто SMSC (номер заблокирован или не существует)'.freeze
      when 'incorrect id'.freeze
        'Неверный идентификатор сообщения'.freeze
      end
    end

    def queued?
      @status == 'queued'
    end

    def delivered?
      @status == 'delivered'
    end
  end
end
