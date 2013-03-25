ActiveAdmin.register User do

  action_item only: :show do
    link_to 'Morph', login_as_admin_user_path(params[:id]), :target => '_blank'
  end

  form do |f|
    f.inputs 'User Details' do
      f.input :studio
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :phone
      f.input :admin
      f.input :owner
    end
    f.actions
  end

  # Allows admins to login as a user 
  member_action :login_as, :method => :get do
    user = User.find(params[:id])
    sign_in(user, bypass: true)
    redirect_to root_path 
  end

  controller do
    def permitted_params
      params.permit!
    end

    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      update!
    end
  end
end
