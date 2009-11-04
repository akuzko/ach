module ACH::Records
  class EntryDetail < Record
    @fields = []
    
    attr_accessor :sorter
    
    const_field :record_type, '6'
    field :transaction_code, String,
        lambda {|f| f}, nil, /\A\d{2}\Z/
    spaceless_routing_field :routing_number # Receiving DFI Identification 
                                            # and Check Digit
    field :account_number, String, lambda { |f| left_justify(f, 17)}
    field :amount, Integer, lambda { |f| sprintf('%010d', f)}
    field :individual_id_number, String, lambda { |f| left_justify(f, 15)}
    field :individual_name, String, lambda { |f| left_justify(f, 22)}
    field :discretionary_data, String, lambda { |f| left_justify(f, 2)}, '  '
    field :addenda_record_indicator, Integer,
        lambda { |f| sprintf('%01d', f)}, 0
    field :originating_dfi_identification, String,
        lambda {|f| f}, nil, /\A\d{8}\Z/
    field :trace_number, Integer, lambda { |f| sprintf('%07d', f)}
    
    def credit?
      @transaction_code[1..1] == '2' || @transaction_code[1..1] == '3'
    end
    
    def debit?
      !credit?
    end
    
    def amount_value
      return self.amount
    end
    
  end
end

# Uses '\r\n' (I think)
