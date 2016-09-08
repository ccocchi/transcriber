class SearchesController < ApplicationController
  def new
  end

  def search
    speaker = params.require(:speaker)
    terms   = params[:q]

    query   = {
      query: {
        match: { transcript: terms }
      },
      filter: {
        term: { speaker: speaker }
      }
    }

    @results = SpeachRepository.search(query).to_a
    if @results.empty?
      head :no_content
    else
      render partial: 'result', collection: @results, as: :result
    end
  end
end
