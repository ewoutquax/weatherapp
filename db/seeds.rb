Measurement.delete_all
Measurement.create(measured_at: Time.parse('10:00') - 1.days, temperature: 2.3)
Measurement.create(measured_at: Time.parse('18:00') - 1.days, temperature: 16.3)
Measurement.create(measured_at: Time.parse('11:30'), temperature: 5.1)
Measurement.create(measured_at: Time.parse('17:30'), temperature: 6.2)
Measurement.create(measured_at: Time.parse('18:00'), temperature: 8.9)
Measurement.create(measured_at: Time.parse('20:00'), temperature: 4.3)
