class JobsController < ApplicationController
  def index
    @jobs = params[:tag] ? Job.tagged_with(params[:tag]) : Job.all
  end

  def new
    @job = Job.new
  end

  def edit
    @job = Job.find(params[:id])
  end

  def show
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.delete
    redirect_to jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :salary, :phone, :email, :all_tags)
  end
end
