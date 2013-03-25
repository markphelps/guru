require 'spec_helper'

describe MembersController do
  describe 'routable' do
    it 'routes to #index' do
      expect(get('/members')).to be_routable
    end
    it 'routes to #show' do
      expect(get('/members/1')).to be_routable
    end
    it 'routes to #new' do
      expect(get('/members/new')).to be_routable
    end
    it 'routes to #create' do
      expect(post('/members')).to be_routable
    end
    it 'routes to #edit' do
      expect(get('/members/1/edit')).to be_routable
    end
    it 'routes to #update' do
      expect(put('/members/1')).to be_routable
    end
    it 'routes to #destroy' do
      expect(delete('/members/1')).to be_routable
    end
  end
end
