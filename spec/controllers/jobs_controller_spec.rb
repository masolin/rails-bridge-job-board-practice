require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  describe 'GET #index' do
    before do
      @front_end_job = create(:job)
      @rails_job = create(:rails_job)
      @test_job = create(:test_job)
    end

    context 'with params[:tag]' do
      before :each do
        get :index, tag: 'Computers'
      end

      it 'populates an array of jobs with the tag' do
        expect(assigns(:jobs)).to match_array([@front_end_job, @rails_job])
      end

      it 'renders the :index template' do
        expect(response).to render_template(:index)
      end
    end

    context "without params[:tag]" do
      before :each do
        get :index
      end

      it 'populates an array of jobs with the tag' do
        expect(assigns(:jobs)).to match_array([@front_end_job, @rails_job, @test_job])
      end

      it 'renders the :index template' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #show' do
    before :each do
      @job = create(:job)
      get :show, id: @job
    end

    it 'assigns the requested job to @job' do
      expect(assigns(:job)).to eq(@job)
    end

    it 'renders the :show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before :each do
      get :new
    end

    it 'assigns new job to @job' do
      expect(assigns(:job)).to be_a_new(Job)
    end

    it 'renders the :new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before :each do
      @job = create(:job)
      get :edit, id: @job
    end

    it 'assigns the requested job to @job' do
      expect(assigns(:job)).to eq(@job)
    end

    it 'renders the :edit template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new job in the database' do
        expect { post :create, job: attributes_for(:job) }.to change(Job, :count).by(1)
      end

      it 'redirects to jobs#show' do
        post :create, job: attributes_for(:job)
        expect(response).to redirect_to job_path(assigns(:job))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new job in the database' do
        expect { post :create, job: attributes_for(:invalid_job) }.not_to change(Job, :count)
      end
      it 're-renders the :new template' do
        post :create, job: attributes_for(:invalid_job)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @job = create(:job)
    end

    context 'with valid attributes' do
      before :each do
        patch :update, id: @job, job: attributes_for(:test_job)
        @job.reload
      end

      it 'updates the job in the database' do
        expect(@job.title).to eq('Test')
      end
      it 'redirects to the jobs#show' do
        expect(response).to redirect_to job_path(@job)
      end
    end

    context 'with invalid attributes' do
      before :each do
        patch :update, id: @job, job: attributes_for(:invalid_job)
        @job.reload
      end

      it 'does not update the job in the database' do
        expect(@job.title).not_to eq('Invalid')
        expect(@job.phone).to eq('254-654-1489')
      end

      it 're-renders the :edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @job = create(:job)
    end

    it 'delete the job from the database' do
      expect { delete :destroy, id: @job }.to change(Job, :count).by(-1)
    end

    it 'redirects to jobs#index' do
      delete :destroy, id: @job
      expect(response).to redirect_to jobs_path
    end
  end
end
