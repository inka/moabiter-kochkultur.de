# new generated with restful_authentication
# ruby script/generate authenticated user sessions --include-activation
#

class UsersController < ApplicationController

  before_filter :login_required, :except => [ :signup, :activate ]
  before_filter :only_admin, :only => [ :new, :create, :destroy, :list, :log ]
#  skip_before_filter :check_expo
  
  filter_parameter_logging :password  # important!

#  log :@user, :only => [ :destroy, :create, :change_password ]

  def index
#    options = params[:complete_log] ? {} : { :conditions => LogEntry.created_at_today }
#    options[:include] = [ :user, :expo ]
#    @log = LogEntry.find :all, options
    @users = User.find(:all, :order => 'id DESC')
    get_id
  end

  def show
    if get_user
      access_refused unless current_user == @user || admin?
#      @log = @user.log_entries
#      @log = @log.today unless params[:complete_log]
    end
  end

#  def log
#    options = params[:complete_log] ? {} : { :conditions => LogEntry.created_at_today }
#    options[:include] = [ :user, :expo ]
#    @log = LogEntry.find :all, options
#  end

  def new
    @user = User.new
  end

  # this called from new user form if admin creates user
  def create
    # this is for the back button if admin uses the new user form
    if !params['confirm']
      redirect_to :action => :index
      return
    end

    @user = User.new(params[:user])
    @user.save!
    @user.activate if admin?
    flash[:success] = "Benutzer \"#{@user.login}\" wurde angelegt."
    redirect_to :action => :show, :id => @user
  rescue => boom
    flash[:error] = "Bitte korrigieren Sie Ihre Angaben. (#{boom.message})"
    render :action => :new
  end

  # this called from new user form if user signs up

=begin

  def signup
    return unless request.post?
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.last_activity_at = Time.now
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      flash[:notice] = "Vielen Dank, Ihr Zugang wurde eingerichtet! Bitte aktivieren Sie Ihren Account über den Link in der Email, die Sie in wenigen Minuten erreicht."
      redirect_back_or_default('/login')
    else
      flash[:error] = "Bitte korrigieren Sie Ihre Angaben."
      render :template => '/sessions/signup', :layout => 'login'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      current_user.update_attribute(:last_activity_at, Time.now)
      flash[:notice] = "Ihre Registrierung ist nun vollständig!"
    end
    redirect_back_or_default('/')
  end

=end


  def change_password
    get_user
    access_refused unless current_user == @user || admin?
    if request.post? && params[:user]
      password_params = params[:user].restrict([:password, :password_confirmation])
      if @user.update_attributes(password_params)
        flash[:success] = "Das Passwort von \"#{@user.login}\" wurde geändert."
        redirect_to :action => :show, :id => @user
      else
        render :action => :change_password
      end
    end
  end

  def destroy
    if get_user
      raise "Don't kill yourself, please!" if @user == current_user
      @user.destroy
      flash[:success] = "Benutzer \"#{@user.login}\" wurde gelöscht."
      redirect_to :action => :index
    end
  end

  protected
  def get_user options = {}
    @user = User.find(params[:id], options)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Benutzer nicht gefunden.'
    redirect_to :action => :index
    false
  end

  def only_admin
    unless admin?
      access_denied
    end
  end

end
