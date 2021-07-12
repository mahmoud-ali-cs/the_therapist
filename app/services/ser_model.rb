class SerModel
  def self.process_sound_file(quiz_reponse)
    response = HTTParty.post(
      # 'http://127.0.0.1:5000/ser',
      'http://25339d083726.ngrok.io/ser',
      body: {
        sound_file: quiz_reponse.sound_file
      }
    )

    response_hash = JSON.parse response.body, symbolize_names: true
    response_hash[:emotion]
  end

  # def self.process_sound_file(sound_file_path)
  #   response = HTTParty.post(
  #     'http://localhost:3000/api/v1/quiz_responses',
  #     headers: {
  #       'access-token' => 'S1dXFCsOlmUKckmAXDCM_A',
  #       'client' => 'mLZbgyMaZ5692MdKgxlcNQ',
  #       'uid' => 'mahmoud@example.com',
  #     },
  #     body: {
  #       quiz_response: {
  #         quiz_id: 1,
  #         sound_file: File.open('/home/mahmoud/rails_projects/the_therapist/03-01-03-02-01-01-24.wav')
  #         # sound_file: File.open(sound_file_path)
  #       }
  #     }
  #   )

  #   response_hash = JSON.parse response.body, symbolize_names: true
  # end
end
