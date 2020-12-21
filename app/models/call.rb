class Call < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(:asterisk)
  self.table_name = "cdr"
  attr_accessor :link, :linkname
  scope :main, -> (date_from, date_to) {where("(calldate >= ? and calldate <= ? + INTERVAL 1 DAY)
                                                AND (billsec>0 or src between 300 and 399 or src = \'ivoice_eva\')
                                                AND (dst<>111 or dstchannel='')",date_from,date_to)}
  scope :source, -> (src) {where(src: src) if src.present?}
  scope :dest, -> (dst) {where(dst: dst) if dst.present?}
  scope :working_day, -> (date) {where("calldate >= ? AND calldate <= ? + INTERVAL 1 DAY
                                        AND hour(calldate) BETWEEN \'8\' AND \'17\'", date, date)}
end
