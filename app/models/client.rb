class Client < ActiveRecord::Base
  self.table_name = "clients"

  validates :company, :length => {:minimum => 3, :too_short => "Должна содержать минимум 3 символа"},
    :presence => true

  validates :phone_number, :length => {:is => 9, :wrong_length => "Должен содержать 9 цифр"},
    :format => {:with => /\d{9}/, :message => "Должен содержать только цифры"},
    :presence => true
end
