class CommentsController < ApplicationController

  before_filter :admin_required, :except => [:create]
  before_filter :get_place
  
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    @comment.place = @place
    @comment.user = current_user || create_user

    respond_to do |format|
      if verify_recaptcha() and @comment.save
        flash[:notice] = 'Kommentar wurde gespeichert. Ein Moderator wird diesen prüfen und anschließend freischalten. Vielen Dank.'
        ContactMailer.deliver_checkit(@comment)
        format.html { redirect_to(@place) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash.now[:error] = 'Kommentar konnte nicht gespeichert werden. Überprüfen Sie bitte Ihre reCaptcha Eingabe!'
	readtags
	format.html { render :template => "places/show" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])
    params[:comment][:activated_at] = Time.now if params[:comment][:activated_at] == "1"

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
#        if params[:final] && !admin?
#          flash[:notice] = 'Kommentar wurde gespeichert. Ein Moderator wird diesen prüfen und anschließend freischalten. Vielen Dank.'
#          ContactMailer.deliver_checkit(@comment)
#        else
          flash[:notice] = 'Kommentar wurde gespeichert.'
#        end
        format.html { redirect_to(@place) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
#      flash[:notice] = 'Kommentar wurde gelöscht'
      format.html { redirect_to(@place) }
      format.xml  { head :ok }
      format.js do
        render :update do |page|
          page.visual_effect(:blind_up, "comment_#{@comment.id}", :duration => 1)
        end
      end
    end
  end

  private

  def get_place
    @place = Place.find(params[:place_id])
#    puts @place.inspect
  end
end
