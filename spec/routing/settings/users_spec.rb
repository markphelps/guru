require 'spec_helper'

describe Settings::UsersController do
  describe 'not routable' do
    it 'should not route to #show through settings' do
      expect(get('/settings/users/1')).to_not be_routable
    end
    it 'should not route to #index' do
      expect(get('/users')).to_not be_routable
    end
    it 'should not route to #show' do
      expect(get('/users/1')).to_not be_routable
    end
    it 'should not route to #new' do
      expect(get('/users/new')).to_not be_routable
    end
    it 'should not route to #create' do
      expect(post('/users')).to_not be_routable
    end
    it 'should not route to #edit' do
      expect(get('/users/edit')).to_not be_routable
    end
    it 'should not route to #update' do
      expect(put('/users/1')).to_not be_routable
    end
    it 'should not route to #destroy' do
      expect(delete('/users/1')).to_not be_routable
    end
  end
end
