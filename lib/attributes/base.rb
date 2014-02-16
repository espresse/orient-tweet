module Oriental
  module Attributes
    module Base
      include Virtus.module

      attribute :rid, Oriental::RecordId
      attribute :klass, String
      attribute :type, String
    end
  end
end