module Oriental
  module Attributes
    module Timestamp
      include Virtus.module

      attribute :created_at, DateTime
      attribute :updated_at, DateTime
    end
  end
end
