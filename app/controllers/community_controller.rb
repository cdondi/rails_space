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
  end
end
