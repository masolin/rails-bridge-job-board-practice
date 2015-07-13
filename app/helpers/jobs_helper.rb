module JobsHelper
  def render_job_description(job)
    truncate(job.description, length: 150)
  end

  def tag_link(tag)
    tag_path(tag.name)
  end
end
