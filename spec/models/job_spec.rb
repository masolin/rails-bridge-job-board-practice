require 'rails_helper'

RSpec.describe Job, type: :model do
  it "is valid with title, description, phone, email, salary, all_tags" do
    job = build(:job)
    expect(job).to be_valid
  end

  it "is invalid without title" do
    job = build(:job, title: nil)
    job.valid?
    expect(job.errors[:title]).to include("can't be blank")
  end

  it "is invalid when title length > 50" do
    job = build(:job, title: 'a'*51)
    job.valid?
    expect(job.errors[:title]).to include('is too long (maximum is 50 characters)')
  end

  it "is invalid without description" do
    job = build(:job, description: nil)
    job.valid?
    expect(job.errors[:description]).to include("can't be blank")
  end

  it "is invalid when description length > 5000" do
    job = build(:job, description: 'a'*5001)
    job.valid?
    expect(job.errors[:description]).to include('is too long (maximum is 5000 characters)')
  end

  it "is invalid without salary" do
    job = build(:job, salary: nil)
    job.valid?
    expect(job.errors[:salary]).to include("can't be blank")
  end

  it "is invalid when salary is not integer" do
    job = build(:job, salary: 0.7)
    job.valid?
    expect(job.errors[:salary]).to include('must be an integer')
  end

  it "is invalid when salary < 0" do
    job = build(:job, salary: -1)
    job.valid?
    expect(job.errors[:salary]).to include('must be greater than 0')
  end


  it "is invalid without email" do
    job = build(:job, email: nil)
    job.valid?
    expect(job.errors[:email]).to include("can't be blank")
  end

  it "is invalid when email length > 255" do
    job = build(:job, email: 'a'*256)
    job.valid?
    expect(job.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it "is invalid when email format is wrong" do
    job = build(:job, email: 'aaa')
    job.valid?
    expect(job.errors[:email]).to include('is invalid')
  end

  it "is invalid without phone" do
    job = build(:job, phone: nil)
    job.valid?
    expect(job.errors[:phone]).to include("can't be blank")
  end

  it "is valid with space tags" do
    job = build(:job, all_tags: ' ')
    job.valid?
    expect(job.tags).to be_empty
  end

  it "returns all tags as a comma-separated string" do
    job = build(:job)
    expect(job.all_tags).to eq 'Computers, Tools, Books'
  end

  describe "filter jobs by tag" do
    before :each do
      @front_end_job = create(:job)
      @rails_job = create(:rails_job)
      @test_job = create(:test_job)
    end

    context "with match tag name" do
      it "returns an array of jobs with specific tag" do
        expect(Job.tagged_with('Computers')).to eq [@front_end_job, @rails_job]
      end
    end

    context "with non-match tag name" do
      it "omits results without specific tag" do
        expect(Job.tagged_with('Computers')).not_to include @test_job
      end
    end
  end
end
