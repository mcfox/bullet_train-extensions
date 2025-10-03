# frozen_string_literal: true

module TailwindUiHelpers
  # show_tabs helper (copied from host app for reuse)
  # See original comments for usage documentation.
  def show_tabs(tabs, options = {})
    raise ArgumentError, "tabs must be a Hash" unless tabs.is_a?(Hash)

    base_id = (options[:id].presence || "tabs-#{SecureRandom.hex(4)}").parameterize
    active_index = options.fetch(:active, 0).to_i

    nav_classes = [
      "border-b border-gray-200",
      options[:nav_classes]
    ].compact.join(" ")

    tabs_buttons = []
    panels = []

    tabs.to_a.each_with_index do |(label, value), idx|
      tab_id = "#{base_id}-tab-#{idx}"
      panel_id = "#{base_id}-panel-#{idx}"
      active = idx == active_index

      button_classes_active = "border-indigo-500 text-indigo-600"
      button_classes_inactive = "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
      button_base = "whitespace-nowrap border-b-2 px-1 py-4 text-sm font-medium"

      tabs_buttons << content_tag(
        :button,
        label,
        type: "button",
        role: "tab",
        id: tab_id,
        class: [button_base, (active ? button_classes_active : button_classes_inactive)].join(" "),
        aria: { controls: panel_id, selected: active },
        data: { action: "click->tabs#switch", tabs_target: "tab", tabs_panel: panel_id }
      )

      partial_path, locals = if value.is_a?(Hash)
                               [value[:partial], (value[:locals] || {})]
                             else
                               [value, {}]
                             end

      panel_content = render(partial: partial_path, locals: locals)

      panels << content_tag(
        :div,
        panel_content.html_safe,
        id: panel_id,
        role: "tabpanel",
        aria: { labelledby: tab_id },
        class: [
          (active ? "" : "hidden"),
          options[:panel_classes]
        ].compact.join(" ")
      )
    end

    nav = content_tag(:div, content_tag(:nav, safe_join(tabs_buttons, "\n"), class: "-mb-px flex space-x-8", aria: { label: "Tabs" }), class: nav_classes)
    panels_container = content_tag(:div, safe_join(panels, "\n"))

    js = <<~JS
      <script>
        (function(){
          var rootId = #{base_id.to_json};
          if (document.getElementById(rootId + "-init")) { return; }
          var marker = document.createElement("span");
          marker.id = rootId + "-init";
          marker.style.display = "none";
          document.currentScript.parentElement.insertBefore(marker, document.currentScript);

          function switchTo(panelId, container){
            var buttons = container.querySelectorAll('[data-tabs-target="tab"]');
            var panels = container.querySelectorAll('[role="tabpanel"]');
            buttons.forEach(function(btn){
              var pid = btn.getAttribute('data-tabs-panel');
              var active = (pid === panelId);
              btn.setAttribute('aria-selected', active);
              btn.classList.toggle('border-indigo-500', active);
              btn.classList.toggle('text-indigo-600', active);
              btn.classList.toggle('border-transparent', !active);
              btn.classList.toggle('text-gray-500', !active);
            });
            panels.forEach(function(p){
              if (p.id === panelId) { p.classList.remove('hidden'); }
              else { p.classList.add('hidden'); }
            });
          }

          var container = marker.parentElement;
          container.addEventListener('click', function(e){
            var btn = e.target.closest('[data-action~="click->tabs#switch"]');
            if (!btn || !container.contains(btn)) return;
            e.preventDefault();
            switchTo(btn.getAttribute('data-tabs-panel'), container);
          });
        })();
      </script>
    JS

    safe_join([nav, panels_container, js.html_safe], "\n")
  end
end
