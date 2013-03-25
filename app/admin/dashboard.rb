ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Studios" do
          table do
            tr
              th "Name"
              th "Created At"
              th "Updated At"
            Studio.last(5).reverse.map do |studio|
              tr
                td link_to(studio.name, admin_studio_path(studio))
                td studio.created_at
                td studio.updated_at
            end
          end
        end
      end

      column do
        panel "Recent Users" do
          table do
            tr
              th "Name"
              th "Created At"
              th "Updated At"
            User.last(5).reverse.map do |user|
              tr
                td link_to(user.name, admin_user_path(user))
                td user.created_at
                td user.updated_at
            end
          end
        end
      end

    end
  end # content
end
