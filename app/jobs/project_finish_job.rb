class ProjectFinishJob < ActiveJob::Base
  queue_as :default

  def perform(*args)

    project = Project.find(args[0])

    if project.status != Project::S_FINISH && project.entry_closed <= Time.zone.now
      project.status = Project::S_FINISH
      project.save!
      project.update_column(:finish_job_id, nil)
    end

  end

end