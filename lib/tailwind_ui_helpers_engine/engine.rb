# frozen_string_literal: true

module TailwindUiHelpersEngine
  class Engine < ::Rails::Engine
    # Do not isolate namespace to allow views to be discovered under shared paths
    # isolate_namespace TailwindUiHelpersEngine

    initializer "tailwind_ui_helpers_engine.view_paths" do |app|
      # Ensure engine views are available to the host app
      app.config.paths["app/views"].push(root.join("app", "views").to_s)
    end

    initializer "tailwind_ui_helpers_engine.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper :all
      end

      ActiveSupport.on_load(:action_view) do
        begin
          include ::TailwindUiHelpers
        rescue NameError
          # Helper may not be defined yet; it's in this engine. Rails will include from app/helpers automatically.
        end
      end
    end
  end
end
