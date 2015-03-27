ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Instructionals" do
          ul do
            Instructional.recent.take(5).map do |inst|
              li "#{link_to(inst.title, admin_instructional_path(inst))} (#{inst.topic_name_with_ancestry})".html_safe
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to the Admin Area"
        end
      end
    end
  end # content
end
