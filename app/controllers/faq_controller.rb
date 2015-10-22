class FaqController < ApplicationController
  def index
    redirect_to hub_url
  end

  def edit
    @title = "Edit FAQ"
    @user = User.find(session[:user_id])
    @user.faq ||= Faq.new
    @faq = @user.faq
    if param_posted?(:faq)
      if @user.faq.update_attributes(faq_params)
        flash[:notice] = "FAQ saved."
        redirect_to hub_url
      end
    end
  end

  def faq_params
    params.require(:faq).permit(:user_id, :bio, :skills, :schools, :companies, :music, :movies, :television, :magazines, :books )
  end
end
