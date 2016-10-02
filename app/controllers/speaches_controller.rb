class SpeachesController < ActionController::Base
  layout 'application'

  def edit
    @speach = Speach.find(params[:id])
  end

  def update
    @speach = Speach.find(params[:id])
    @speach.transcript = params[:transcript]
    @speach.save
    SpeachRepository.update(@speach)
    redirect_to root_path, notice: 'Speach updated successfully.'
  end
end
