module IqSMS
  class MessageStatus
    def initialize(status)
      @status = status
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
