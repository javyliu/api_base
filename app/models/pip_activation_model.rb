class PipActivationModel < PipstatRecord
  self.table_name = 'pip_activation_model_day'
  scope :by_date, lambda { |sdate, edate| where(statdate: sdate..edate) }
  scope :by_channel, lambda { |chl| where(channel: chl) }
end
