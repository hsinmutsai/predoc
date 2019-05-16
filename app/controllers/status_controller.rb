class StatusController < ApplicationController

  def index
    # build the status hash by collecting various metrics
    status = {}
    status[:cache_directory_writable] = File.writable? Predoc::Config::CACHE_ROOT_DIRECTORY
    status[:working_directory_writable] = File.writable? Predoc::Config::WORKING_DIRECTORY
    status[:converter] = can_convert?
    status[:app_node] = (Socket.gethostname || '').split('.').first

    # prepare and render outputs
    status_text = status.all? { |key, status| status } ? 'OK' : 'PROBLEM'
    status_json = {status: status_text}.merge(status)
    respond_to do |format|
      format.all { render plain: status_text, content_type: 'text/plain' }
      format.json { render json: status_json }
    end
  end

end
