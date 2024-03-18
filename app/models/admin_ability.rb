class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    if admin.has_role?(:admin) || admin.has_role?(:admin_without_mail)
      can :manage, Project
      can :manage, ProjectDraft
      can :manage, Event
      can :manage, PickupProject
      can :manage, ExecutedProject
      can :manage, Site
      can :manage, User
      can :manage, Company
      can :manage, Student
      can :manage, Headline
      can :manage, Medium
      can :manage, Admin
      #can :manage, AdminCompany
      can :manage, TransactionRecord
      can :manage, Question
      can :manage, Slider
    elsif admin.has_role?(:recmatch_business)
      can :manage, Project
      can :manage, ProjectDraft
      can :manage, Event
      can :manage, Comment
      can :manage, PickupProject
      can :manage, ExecutedProject
      can :manage, Site
      can :manage, User
      can :manage, Company
      can :manage, CompanyReview
      can :manage, Student
      can :manage, Supporter
      cannot :approve, Student
      can :manage, Order
      can :manage, Headline
      can :manage, Medium
      can :manage, CaseStudy
      can :manage, PageDraft
      can :manage, Admin
      can :manage, AdminCompany
      can :manage, TransactionRecord
      can :manage, Question
      can :manage, Inflow
      can :manage, Slider
      can :manage, Staff
    elsif admin.has_role?(:recmatch_admin)
      can :manage, Project
      cannot [:approve, :reject], Project
      can :manage, ProjectDraft
      cannot [:approve, :reject], ProjectDraft
      can :manage, Comment
      can :manage, Company
      can :manage, CompanyReview
      can :manage, Student
      can :manage, Supporter
      cannot :show_details, Student
      can :manage, Order
      can :manage, TransactionRecord
      can :manage, Slider
      can :manage, GroupChat::Category
      can :manage, Staff
    elsif admin.has_role?(:recmatch_sales)
      can :manage, Company
      cannot [:create, :update, :destroy], Company
      can :manage, CompanyReview
      cannot [:create, :update, :destroy], CompanyReview
      can :manage, Supporter
      can :manage, Proposal
      can :create, AdminCompany
      can :manage, Staff
    elsif admin.has_role?(:recmatch_other)
      can :manage, Company
      cannot [:create, :update, :destroy], Company
      can :manage, CompanyReview
      cannot [:create, :update, :destroy], CompanyReview
      can :manage, Supporter
      can :create, AdminCompany
      can :manage, Staff
    end
  end
end
