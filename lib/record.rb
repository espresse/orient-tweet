module Oriental
  class Record
    include Oriental::Document
    # attribute :rid, Oriental::Rid
    include Oriental::Attributes::Properties

    def initialize(record = {})
      self.extend(Virtus.model)
      record.each do |k, v|
        k = k.to_s[1..-1].to_sym if k.to_s[0] == "@"
        self.attribute k, v.class unless [:class, :rid, :type].include? k
      end
      super(record)
    end

    def self.returns_anything?
      true
    end
  end

end

