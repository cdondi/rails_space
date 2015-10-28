class CommunityController < ApplicationController
  helper :profile


  def index
    @title = "Community"
    @letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    if params[:id]
      @initial = params[:id]
      specs = Spec.where("last_name like ?","#{@initial}%").order("last_name, first_name")
      @users = specs.collect{|spec| spec.user}.paginate(:page => params[:page], :per_page => 5)
    end
  end

  def browse
  end

  def search
    @title = "Search RailsSpace"
    if params[:q]
      query = params[:q]

      # First find the user hits ...
      search1 = User.search do
        fulltext query
      end
      @users = search1.results

      search2 = Spec.search do
        fulltext query
      end
      specs = search2.results

      search3 = Faq.search do
        fulltext query
      end
      faqs = search3.results

      # Now combine into one list of distinct users sorted by last name
      hits = specs + faqs
      @users.concat(hits.collect { |hit| hit.user }).uniq!
      @users.compact!
      # Sort by last name (requires a spec for each user)
      @users.each { |user| user.spec ||= Spec.new }
      @users = @users.sort_by { |user| user.spec.last_name }.paginate(:page => params[:page], :per_page => 5)

      @me = ""
    end
  end
end
