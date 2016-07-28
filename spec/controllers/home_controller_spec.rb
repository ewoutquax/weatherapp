require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  context 'index' do
    before do
      expect(MeasurementsPresenter).to receive(:new).with(Array)

      get :index
    end

    it 'returns http success' do
      expect(response).to be_success
    end

    # it 'renders the index template' do
    #   expect(response).to render_template(:index)
    # end
  end
end
