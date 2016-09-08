class SpeachToTextWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3

  def perform(filename, speaker)
    body = {
      'config' => {
        'encoding'        => 'FLAC',
        'sampleRate'      => 44100,
        'languageCode'    => 'fr-FR',
        'profanityFilter' => false
      },
      'audio' => {
        'uri' => "gs://haymakerforever/uploads/#{filename}"
      }
    }
    body = Oj.dump(body)

    request = Typhoeus::Request.new(
      'https://speech.googleapis.com/v1beta1/speech:syncrecognize',
      method: :post,
      body: body,
      params: { key: 'AIzaSyAKw3MqkmLIO_RFizJvxLwZ86oCELU0J6g' },
      headers: { 'Content-Type' => 'application/json' }
    )

    response = request.run

    if response.code != 200
      Sidekiq.logger.error "[Sp2Tx] Got #{response.code} when trying to process #{filename}"
      return
    end

    body       = Oj.load(response.body)
    transcript = body['results'].first['alternatives'].first['transcript']

    if transcript
      speach    = Speach.new(speaker, transcript, filename)
      SpeachRepository.save(speach)
    end
  end
end
