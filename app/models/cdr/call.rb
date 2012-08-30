class CDR::Call < Cdr::Base
  self.table_name = "cdr"
  attr_accessor :link, :linkname
  paginates_per 50
end
