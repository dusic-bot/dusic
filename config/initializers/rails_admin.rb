require 'nested_form/engine'
require 'nested_form/builder_mixin'

RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
    redirect_to main_app.root_path unless current_user&.admin
  end
  config.current_user_method(&:current_user)

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  unless Rails.env.test?
    config.excluded_models = [Blazer::Audit, Blazer::Check, Blazer::DashboardQuery, Blazer::Dashboard, Blazer::Query]
  end
end
