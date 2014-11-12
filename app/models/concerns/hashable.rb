module Hashable
  module ClassMethods
  
    def hasher
      Hashids.new('ballot', 5)
    end
  
    def encode_id(id)
      hasher.encode(id)
    end

    def decode_id(id)
      # Need to select first since hashids provides an array
      # of answers.
      hasher.decode(id).first
    end
    
    def find(id)
      super(decode_id(id))
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def encoded_id
    self.class.encode_id(id)
  end

  def to_param
    encoded_id 
  end

end
