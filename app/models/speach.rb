class Speach < Struct.new(:speaker, :transcript, :filename)
  def to_hash
    {
      speaker: speaker,
      transcript: transcript,
      filename: filename
    }
  end
end
