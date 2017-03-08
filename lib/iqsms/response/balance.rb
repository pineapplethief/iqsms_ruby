module IqSMS
  class Response
    class Balance < Response
      def balance_hash
        @hash[:balance].first
      end

      def balance
        @balance ||= balance_hash[:balance].to_s.to_d
        @balance
      end

      def currency
        balance_hash[:type]
      end

      def credit
        @credit ||= balance_hash[:credit].to_s.to_d
        @credit
      end
    end
  end
end
