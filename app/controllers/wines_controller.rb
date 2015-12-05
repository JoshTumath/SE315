class WinesController < ApplicationController
  require 'rest-client'

  def index
    #XXX: Temporary until this can be added to a cron or scheduler
    SyncWithSuppliersJob.perform_now

    if params[:search]
      @wines = Wine.search(params[:search])
    else
      @wines = Wine.all
    end
  end

  def show
    @wine = Wine.find(params[:id])
  end
end
