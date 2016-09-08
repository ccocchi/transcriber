class SpeachToTextWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3

  def perform(filename, speaker)
    body = {
      'initial_request' => {
        'encoding'      => 'FLAC',
        'sampleRate'    => 44100,
        'languageCode'  => 'fr-FR'
      },
      'audio_request' => {
        'uri' => "gs://haymakerforever/uploads/#{filename}"
      }
    }
    body = Oj.dump(body)

    request = Typhoeus::Request.new(
      'https://speech.googleapis.com/v1/speech:recognize',
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

    body        = Oj.load(response.body)
    results     = body['responses'].first['results']
    transcript  = results.find { |r| r['isFinal'] }['alternatives'].first['transcript']

    if transcript
      speach    = Speach.new(speaker, transcript, filename)
      SpeachRepository.save(speach)
    end
  end
end
