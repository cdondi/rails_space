class SpecController < ApplicationController
  before_filter :protect
  def index
    redirect_to :controller => "user", :action => "index"
  end

  def edit
    @title = "Edit Spec"
    @user = User.find(session[:user_id])
    @user.spec ||= Spec.new
    @spec = @user.spec
    if param_posted?(:spec)
      if @user.spec.update_attributes(spec_params)
        flash[:notice] = "Changes saved."
        redirect_to :controller => "user", :action => "index"
      end
    end
  end

  def spec_params
    params.require(:spec).permit(:user_id, :first_name, :last_name, :occupation, :city, :state, :zip_code, :gender, :birthdate)
  end
end
