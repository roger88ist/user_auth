class SightingsController < ApplicationController
  before_action :set_sighting, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /sightings
  # GET /sightings.json
  def index
    @sightings = Sighting.where('created_at >= ?', (Time.now - 28800))
    gon.array_of_cor = Sighting.get_cordinates(@sightings)
    # @gon = gon.array_of_cor
  end

  # GET /sightings/1
  # GET /sightings/1.json
  def show
    redirect_to sightings_path
  end

  # GET /sightings/new
  def new
    @sighting = current_user.sightings.build
  end

  # GET /sightings/1/edit
  def edit
  end

  # POST /sightings
  # POST /sightings.json
  def create
    # @alert_message = "Meter Maid is around."
    @sighting = current_user.sightings.build(sighting_params)
    # @sighting.notify
    respond_to do |format|

      # send_message("+17049955069", @alert_message)

      if @sighting.save

        format.html { redirect_to @sighting, notice: 'Sighting was successfully created.' }
        format.json { render :show, status: :created, location: @sighting }

        ################################################################
        @sighting.alert_users(InterestLocation.all)
        
        # users = @sighting.target_users(post_array, locations)
        # @sighting.send_email(users)
        ################################################################
      else
        format.html { render :new }
        format.json { render json: @sighting.errors, status: :unprocessable_entity }
      end
    end


  end

  # PATCH/PUT /sightings/1
  # PATCH/PUT /sightings/1.json
  def update
    respond_to do |format|
      if @sighting.update(sighting_params)
        format.html { redirect_to @sighting, notice: 'Sighting was successfully updated.' }
        format.json { render :show, status: :ok, location: @sighting }
      else
        format.html { render :edit }
        format.json { render json: @sighting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sightings/1
  # DELETE /sightings/1.json
  def destroy
    @sighting.destroy
    respond_to do |format|
      format.html { redirect_to sightings_url, notice: 'Sighting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sighting
      @sighting = Sighting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sighting_params
      params.require(:sighting).permit(:day, :latitude, :longitude)
    end

    # def send_message(phone_number, alert_message)
    #   account_sid = ENV['TWILIO_ACCOUNT_SID']
    #   auth_token = ENV['TWILIO_AUTH_TOKEN']

    #   # set up a client to talk to the Twilio REST API
    #   @client = Twilio::REST::Client.new account_sid, auth_token

    #   @twilio_number = ENV['TWILIO_NUMBER']
    #   @client.account.messages.create({
    #   	:from => @twilio_number,
    #   	:to => phone_number,
    #   	:body => alert_message
    #   });
    # end

end
