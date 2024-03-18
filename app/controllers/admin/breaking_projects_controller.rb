class Admin::BreakingProjectsController < Admin::AdminController
  def edit
    @site = Site.find(1)
  end

  def update
    @site = Site.find(1)
    @site.assign_attributes(site_params)

    if @site.valid?(:featured_project) && @site.save
      redirect_to admin_root_path, notice: '注目の新着プロジェクトを更新しました'
    else
      render :edit
    end
  end

  private

  def site_params
    params.require(:site).permit(:project_id)
  end
end