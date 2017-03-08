module IqSMS
  class Response
    class Senders < Response
      def senders
        Array(@hash[:senders])
      end
    end
  end
end
