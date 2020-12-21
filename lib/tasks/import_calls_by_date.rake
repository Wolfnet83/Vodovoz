desc 'Import calls quantity to concatenated table'
task aggregate_calls: :environment do
  last_date = AggregatedCall.order(:calldate).last
  date = last_date.calldate
  last_date.destroy
  while date <= Date.today
    quantity_in = Call.working_day(date).where("(duration>25 or dstchannel<>'') AND dst=111").count
    quantity_out = Call.working_day(date).where("src BETWEEN 300 AND 399 AND dcontext = 'vodovoz-department' OR dcontext='from-internal'").count
    quantity_received = Call.working_day(date).where(dst: '111', disposition: 'ANSWERED').where("dstchannel<>''").count

    AggregatedCall.create(calldate: date, 
                          quantity_all: quantity_in + quantity_out,
                          quantity_in: quantity_in,
                          quantity_out: quantity_out,
                          received: quantity_received,
                          missed: quantity_in - quantity_received)

    puts "#{date} : in: #{quantity_in} out: #{quantity_out} rec: #{quantity_received}"
    date += 1.day
  end
end