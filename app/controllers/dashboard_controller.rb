class DashboardController < ApplicationController
  ALLOWED_MONTHS = [24, 36].freeze

  def show
    @store_id = params[:store_id].presence
    @months = params[:months].presence&.to_i
    @months = 24 unless ALLOWED_MONTHS.include?(@months)
    @category_id = params[:category_id].presence
    @channel = params[:channel].presence

    client = CirclePosClient.new
    @stores = client.stores.fetch("stores", [])
    @filter_options = client.filters.fetch("filters", {})
    @store_id ||= @filter_options["default_store_id"] || @stores.first&.fetch("id", nil)

    @comparison = client.monthly_comparison(
      store_id: @store_id,
      months: @months,
      category_id: @category_id,
      channel: @channel
    )
    @months_data = @comparison.fetch("months", [])
    @state = @months_data.empty? ? :empty : :ok
  rescue CirclePosClient::Error => e
    @state = :error
    @error_message = e.message
    @stores ||= []
    @filter_options ||= {}
  end
end
