class SyncWithSuppliersJob < ActiveJob::Base
  queue_as :default

  after_perform do |job|
    job.class.perform_later(wait: 30.minutes)
  end

  def perform(*args)
    # Do something later
  end
end
