require 'rails_helper'

RSpec.describe JobsController, type: :controller do

  shared_examples_for 'public access to jobs' do
    before :each do
      @author ||= subject.current_user || create(:user)
    end

    describe 'GET #index' do
      before :each do
        @front_end_job = create(:job, author: @author)
        @rails_job = create(:rails_job, author: @author)
        @test_job = create(:test_job, author: @author)
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
        @job = create(:job, author: @author)
        get :show, id: @job
      end

      it 'assigns the requested job to @job' do
        expect(assigns(:job)).to eq(@job)
      end

      it 'renders the :show template' do
        expect(response).to render_template(:show)
      end
    end
  end

  shared_examples_for 'signed-in access to jobs' do
    before :each do
      @author ||= subject.current_user || create(:user)
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

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new job in the database' do
          expect { post :create, job: attributes_for(:job) }.to change(Job, :count).by(1)
        end

        it 'saves current user to author of the job' do
          post :create, job: attributes_for(:job, author: nil)
          expect(assigns(:job).author).to eq subject.current_user
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
  end

  shared_examples_for 'author access to jobs' do
    before :each do
      @author ||= subject.current_user || create(:user)
    end

    describe 'GET #edit' do
      before :each do
        @job = create(:job, author: @author)
        get :edit, id: @job
      end

      it 'assigns the requested job to @job' do
        expect(assigns(:job)).to eq(@job)
      end

      it 'renders the :edit template' do
        expect(response).to render_template(:edit)
      end
    end

    describe 'PATCH #update' do
      before :each do
        @job = create(:job, author: @author)
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
        @job = create(:job, author: @author)
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

  describe 'author access' do
    before :each do
      @james = create(:user)
      sign_in @james
    end

    it_behaves_like 'public access to jobs'
    it_behaves_like 'signed-in access to jobs'
    it_behaves_like 'author access to jobs'
  end

  describe 'guest access' do
    it_behaves_like 'public access to jobs'

    describe 'GET #new' do
      it 'requires login' do
        get :new
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it 'requires login' do
        get :edit, id: create(:job)
        expect(response).to require_login
      end
    end

    describe 'POST #create' do
      it 'requires login' do
        post :create, job: attributes_for(:job)
        expect(response).to require_login
      end
    end

    describe 'PATCH #update' do
      it 'requires login' do
        patch :update, id: create(:job), job: attributes_for(:job, title: 'Require Login')
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it 'requires login' do
        delete :destroy, id: create(:job)
        expect(response).to require_login
      end
    end
  end

  describe "signed in but access other author's jobs" do
    before :each do
      @author = create(:user)
      @andy = create(:user, email: 'andy@test.com')
      sign_in @andy
    end

    it_behaves_like 'public access to jobs'
    it_behaves_like 'signed-in access to jobs'

    context "modify other's jobs" do
      before :each do
        @james_job = create(:job, author: @author)
      end

      describe 'GET #edit' do
        before :each do
          get :edit, id: @james_job
        end

        it 'redirects to jobs#show' do
          expect(response).to redirect_to job_path(@james_job)
        end

        it 'pops out alert message' do
          expect(flash[:alert]).to eq('You have no permission to edit it.')
        end
      end

      describe 'PATCH #update' do
        before :each do
          patch :update, id: @james_job, job: attributes_for(:job, title: 'Andy Login')
          @james_job.reload
        end

        it 'redirects to jobs#show' do
          expect(response).to redirect_to job_path(@james_job)
        end

        it 'pops out alert message' do
          expect(flash[:alert]).to eq('You have no permission to edit it.')
        end

        it 'does not update the job' do
          expect(@james_job.title).not_to eq('Andy Login')
        end
      end

      describe 'DELETE #destroy' do
        it 'redirects to jobs#show' do
          delete :destroy, id: @james_job
          expect(response).to redirect_to job_path(@james_job)
        end

        it 'pops out alert message' do
          delete :destroy, id: @james_job
          expect(flash[:alert]).to eq('You have no permission to delete it.')
        end

        it 'does not delete the job' do
          expect { delete :destroy, id: @james_job }.not_to change(Job, :count)
        end
      end
    end
  end
end
