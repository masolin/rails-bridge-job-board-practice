class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @jobs = params[:tag] ? Job.tagged_with(params[:tag]) : Job.includes(:tags).all
  end

  def new
    @job = Job.new
  end

  def edit
    @job = Job.find(params[:id])
    unless @job.editable_by?(current_user)
      redirect_to @job, alert: 'You have no permission to edit it.'
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(job_params)
    @job.author = current_user
    if @job.save
      redirect_to @job
    else
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    unless @job.editable_by?(current_user)
      return redirect_to @job, alert: 'You have no permission to edit it.'
    end

    if @job.update(job_params)
      redirect_to @job
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    unless @job.editable_by?(current_user)
      return redirect_to @job, alert: 'You have no permission to delete it.'
    end

    @job.destroy
    redirect_to jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :salary, :phone, :email, :all_tags)
  end
end
