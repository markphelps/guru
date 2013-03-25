module Features
  module SessionHelpers
    def login(options = {})
      studio = create(:studio)
      user = create(:user, options.merge(studio: studio))
      login_as user, scope: :user
      user
    end
  end
end
