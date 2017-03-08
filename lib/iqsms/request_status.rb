module IqSMS
  class RequestStatus
    def initialize(status, description)
      @status = status
      @description = description
    end

    def accepted?
      @status == 'ok'.freeze
    end

    def rejected?
      @status == 'error'.freeze
    end

    def auth_failed?
      rejected? && @description == 'error authorization'.freeze
    end
  end
end
