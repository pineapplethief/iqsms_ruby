module IqSMS
  class MessageStatus
    attr_reader :status, :client_id, :smsc_id

    def initialize(status:, client_id: nil, smsc_id: nil)
      @status = status
      @client_id = client_id
      @smsc_id = smsc_id
    end

    def queued?
      @status == 'queued'
    end

    def delivered?
      @status == 'delivered'
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
  end
end
