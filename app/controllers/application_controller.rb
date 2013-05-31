# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery :secret => '3e43f269268ef69827621e04827b75de'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  filter_parameter_logging :password

  # Pick a unique cookie name to distinguish our session data from others'
#  session :session_key => '_KK_SID_'

  # be sure to include AuthenticatedSystem so current_user can be used in every controller
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  # before_filter :login_required

  # Let all controllers use the Logging system.
  # include Logging

  before_filter :get_id, :update_last_activity

  # The id of the currently selected list item (as Integer).
  attr_accessor :id

  # choose layout: disable global for all xhr request (AJAX), kiez specific name
  layout proc{ |c| c.request.xhr? ? false : 'application' }
  
protected

  def create_user
    # creates a new anonymous user object and corresponding session for avoid rate manipulation
    # session id should contains remote ip address therefore
    return current_user if current_user

    hacker = User.find_by_name(request.remote_ip);
    if (hacker && hacker.created_at > 2.hour.ago)
      current_user = hacker
      logger.info "hacker: #{current_user.inspect}"
    else
      anonymous = User.new({:login => "anonymous",:password => "anonymous",:name => request.remote_ip,:email => "anonymous@#{SITE_URL}"})
      anonymous.activate
      newlogin = Digest::SHA1.hexdigest("--#{anonymous.created_at.to_s(:db)}--#{request.remote_ip}--")
      anonymous.update_attribute(:login, newlogin)
      current_user = User.authenticate(newlogin, "anonymous")
      logger.info "anonymous: #{current_user.inspect}"
    end
    current_user.remember_me
    cookies["auth_token"] = {
        :value => current_user.remember_token,
        :expires => current_user.remember_token_expires_at
    }
    current_user
  end

  # Returns the id parameter as Integer if given, and nil otherwise.
  def get_id
    @id ||= params[:id] ? params[:id].to_i : nil
  end

  def admin?
    # Check if the current user is administrator.
    return logged_in? && current_user.is_admin?
  end

  def no_cache
    response.headers["Last-Modified"] = Time.now.httpdate
    response.headers["Expires"] = 0
    # HTTP 1.0
    response.headers["Pragma"] = "no-cache"
    # HTTP 1.1 ‘pre-check=0, post-check=0′ (IE specific)
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0, pre-check=0, post-check=0"
  end

  # moved here from sessions_controller for autmatic logout of anonymous users
  def do_logout
    if logged_in?
      @login = current_user.login
      current_user.forget_me
      # disabled the write token authorization
      # current_user.current_expo = nil
    end
    cookies.delete :auth_token
#    session[:return_to] = nil if %w[/login,/logout,/signup].find{|a| a == session[:return_to]}
#    reset_session
  end

  def admin_required
    return if !login_required
    current_user.is_admin? || access_denied
  end

  def readtags
    all = Place.tag_counts(:order=>'name ASC')
    @location_tags = all.find_all{|t| t.tag_list.index('tag_location')}
    @type_tags = all.find_all{|t| t.tag_list.index('tag_type')}
    @kind_tags = all.find_all{|t| t.tag_list.index('tag_kind')}
  end

  private
  def update_last_activity
    if logged_in? && !current_user==nil 
      if current_user.last_activity_at && current_user.last_activity_at < Time.now.utc - SESSION_TIMEOUT
        if current_user.email && current_user.email.index('anonymous@')
          logger.info "anonymous timed out: #{current_user.inspect}"
          do_logout
          reset_session
          current_user=nil
        else
          store_location
          flash[:notice] = 'Sitzung ist abgelaufen. Bitte neu einloggen.'
          redirect_to '/login'
        end
      else
        current_user.update_attribute(:last_activity_at, Time.now)
      end
    end
  end
end
